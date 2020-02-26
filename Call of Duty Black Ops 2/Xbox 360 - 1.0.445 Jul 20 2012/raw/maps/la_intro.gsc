#include common_scripts\utility;
#include maps\_utility;
#include maps\la_utility;
#include maps\_vehicle;
#include maps\_scene;
#include maps\_dialog;
#include maps\_music;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;
#insert raw\maps\la.gsh;

#using_animtree( "generic_human" );

/* ------------------------------------------------------------------------------------------
AUTOEXEC
-------------------------------------------------------------------------------------------*/
autoexec event_funcs()
{
	add_spawn_function_group( "mason_reflection", "targetname", ::reflection_scene_head_track );
}

/* ------------------------------------------------------------------------------------------
SKIPTOS
-------------------------------------------------------------------------------------------*/
skipto_intro()
{
}

/* ------------------------------------------------------------------------------------------
MAIN
-------------------------------------------------------------------------------------------*/

main()
{
	/#
		PrintLn( "Intro" );
	#/
		
	load_gump( "la_1_gump_1a" );
	//Eckert - Moved snapshot to amb csc main **Sj reintating notify for snapshot function
	clientNotify ("intr_on");
	exploder(10);
	level thread drone_approach();
	
	flag_wait( "all_players_connected" );
	
	SetSavedDvar( "sm_sunSampleSizeNear", 0.4);

	level thread ambient_drones();
	
	s_cougar_spawner = get_vehicle_spawner( "intro_cougar" );
	veh_cougar = SpawnVehicle( "veh_t6_mil_cougar_interior", "intro_cougar", "apc_cougar_nophysics", s_cougar_spawner.origin, s_cougar_spawner.angles );
	veh_cougar SetModel( "veh_t6_mil_cougar_interior" );
	veh_cougar thread intro_cougar();
	
	n_fov = GetDvarInt( "cg_fov" );
	level.player SetClientDvar( "cg_fov", 55 );
	
	run_scene_first_frame( "intro" );
	
	if ( flag( "harper_dead" ) )
	{
		run_scene_first_frame( "intro_player_noharper" );
	}
	
	ClientNotify( "argus_zone:intro" );
	
	intro_dialog();
		
	nd_cougar_path = GetVehicleNode( "intro_cougar_path", "targetname" );
	veh_cougar thread go_path( nd_cougar_path );
	
	level thread run_reflection_scene();
	
	veh_cougar thread intro_scene_misc();
	
	/# debug_timer(); #/
		
	level.player PlaySound( "evt_la_1_intro" );
	
	level thread run_scene_and_delete( "intro_fxanim_loop" );
	
	if ( !flag( "harper_dead" ) )
	{
		level thread run_scene_and_delete( "intro_harper" );
		level thread run_scene_and_delete( "intro_player" );
	}
	else
	{
		level thread run_scene_and_delete( "intro_player_noharper" );
		n_player_body = get_model_or_models_from_scene( "intro_player_noharper", "player_body" );
		n_player_body Attach( "adrenaline_syringe_small_animated", "tag_weapon" );
	}
	
	level run_scene_and_delete( "intro" );
	
	level ClientNotify ("over_black");
	
	level.player SetClientDvar( "cg_fov", n_fov );
	
	if ( flag( "harper_dead" ) )
	{
		n_player_body Detach( "adrenaline_syringe_small_animated", "tag_weapon" );
	}
}

intro_cougar()
{
	level.intro_cougar = self;
	
	self Attach( "veh_t6_mil_cougar_interior_shadow" );
	self Attach( "veh_t6_mil_cougar_interior_attachment", "tag_body_animate_jnt" );
	//self Attach( "fxanim_la_cougar_interior_static_mod", "tag_body_animate_jnt" );
	fxanim_la_cougar_interior_static_mod = spawn_model( "fxanim_la_cougar_interior_static_mod" );
	fxanim_la_cougar_interior_static_mod LinkTo( self, "tag_body_animate_jnt", (0, 0, 0), (0, 0, 0) );
	
	self HidePart( "tag_windshield_blood" );
	self HidePart( "tag_windshield_crack" );
	
	self play_fx( "cougar_dashboard", undefined, undefined, -1, true, "tag_body_animate_jnt" );
	self play_fx( "cougar_dome_light", undefined, undefined, -1, true, "tag_fx_domelight" );
	self play_fx( "cougar_monitor", undefined, undefined, -1, true, "tag_fx_monitor" );
	self play_fx( "intro_dust", undefined, undefined, -1, true, "tag_body_animate_jnt" );
	
	self thread cougar_godrays();
	
	flag_wait( "intro_fxanim_loop_started" );
	
	m_fxanims = GetEnt( "intro_fxanims", "targetname" );
	m_fxanims Attach( "fxanim_gp_secret_serv_backpack_mod", "backpack_jnt" );
	m_fxanims Attach( "fxanim_gp_secret_serv_gasmask_mod", "gasmask_jnt" );
	
	scene_wait( "intro" );
	
	m_fxanims Delete();
	fxanim_la_cougar_interior_static_mod Delete();
}

set_chopper_dof( m_player_body )
{
	veh_cougar = GetEnt( "intro_cougar", "targetname" );
	veh_cougar SetClientFlag( CLIENT_FLAG_VEHICLE_REFLECTION_BLUR );
}

intro_dialog()
{
	//TUEY - setting intro music
	setmusicstate ("LA_1_INTRO");
	
	//TUEY - setting post intro music state after the intro is done.
	level thread maps\_audio::switch_music_wait ("LA_1_CRAWL", 83);
	
	//playsoundatposition("evt_la_1_intro_txt", (0,0,0));

	//level.player say_dialog( "oh_shit__oh_shit_001", 8 );
	wait 8;
}

slowmo_start( m_player_body )
{
	//Eckert - This is no longer used
	//level.player playsound ("blk_intro_snap_timer");
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
	screen_fade_out( 0 );
	ClientNotify( "reset_snapshot" );

	
}

run_reflection_scene()
{
	m_reflection_cougar = GetEnt( "cougar_reflection_scene", "targetname" );
	
	level thread run_scene_and_delete( "intro_reflection" );
	
	if ( !flag( "harper_dead" ) )
	{
		level thread run_scene_and_delete( "intro_reflection_harper" );
	}
	
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
	level.sm_cam_ent = GetEnt( "reflection_cam", "targetname" );
	level.sm_cam_ent SetClientFlag( CLIENT_FLAG_MOVER_EXTRA_CAM );
}

turn_off_reflection_cam( b_delete = false )
{
	level.sm_cam_ent ClearClientFlag( CLIENT_FLAG_MOVER_EXTRA_CAM );
	
	if ( b_delete )
	{
		level.sm_cam_ent delay_thread( 2, ::self_delete );
	}
}

//turn_on_windshield_bink()
//{
//	level.n_windshield_bink_id = Start3DCinematic( "couger_hud_512", true, false );
//}

//turn_off_windshield_bink()
//{
//	Stop3dCinematic( level.n_windshield_bink_id );
//}

#define DRONE_APRPOACH_INTERVAL 3

drone_approach()
{
	exploder( 55 );
	
	//a_drone_spawners = get_vehicle_spawner_array( "intro_drones" );//comment out for now, we don't appear to be using it - CP
	
	/*while ( flag( "drone_approach" ) )
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
	}*/
	wait 5;
	
//	for( x = 0; x < 6; x++ )
//	{
//		spawn_intro_drone_set();
//	}
	
	while ( flag( "drone_approach" ) )
	{
		wait .2;
	}	
	
	stop_exploder( 55 );
}

spawn_intro_drone_set()
{
	a_drones = spawn_vehicles_from_targetname( "intro_drones" );
	foreach ( veh_drone in a_drones )
	{
		start_node = GetVehicleNode( veh_drone.target, "targetname" );
		
		veh_drone thread go_path( start_node );
		veh_drone thread set_drone_path_variance();
		veh_drone thread restart_path_watcher();
	}
	
	wait RandomFloatRange( DRONE_APRPOACH_INTERVAL / 2, DRONE_APRPOACH_INTERVAL + DRONE_APRPOACH_INTERVAL / 2 );	
}

set_drone_path_variance()
{
	self waittill( "start_path_variance" ); 
	self PathVariableOffset( (1000, 1000, 100), 1.5 );
}

restart_path_watcher()
{
	while ( flag( "drone_approach" ) )
	{
		self waittill( "reached_end_node" );
		self veh_toggle_exhaust_fx( false );
		wait 0.05;
		nd_start = GetVehicleNode( self.target, "targetname" );
		self thread go_Path( nd_start );	
		wait 0.1;
		self veh_toggle_exhaust_fx( true );
	}
	self Delete();
}

blackhawk_explosion( veh_blackhawk )
{
	veh_blackhawk notify( "missile_hit" );
	veh_blackhawk play_fx( "intro_blackhawk_explode", undefined, undefined, -1, true, "body_animate_jnt" );
	wait .3;
	veh_blackhawk play_fx( "intro_blackhawk_trail", undefined, undefined, -1, true, "body_animate_jnt" );
}

missile_hide( m_missile_1 )
{
	m_missile_1 Hide();
}

intro_scene_misc()
{
	flag_wait( "intro_started" );
	
	setup_argus();
	
	level thread policecar_lights();
	
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
	
//	delay_thread( 8, ::turn_on_windshield_bink );
//	delay_thread( 10, ::turn_off_windshield_bink );
	
	delay_thread( 35, ::turn_on_reflection_cam );
	delay_thread( 45, ::turn_off_reflection_cam, true );
	
//	delay_thread( 44, ::turn_on_windshield_bink );
	
	// magic cop car fx
	delay_thread( 5,  ::play_fx, "magic_cop_car_left",  undefined, undefined, undefined, true, "tag_body_animate_jnt" );
	delay_thread( 12, ::play_fx, "magic_cop_car_left",  undefined, undefined, undefined, true, "tag_body_animate_jnt" );
	delay_thread( 17, ::play_fx, "magic_cop_car_left",  undefined, undefined, undefined, true, "tag_body_animate_jnt" );
	delay_thread( 20, ::play_fx, "magic_cop_car_right", undefined, undefined, undefined, true, "tag_body_animate_jnt" );
	delay_thread( 30, ::play_fx, "magic_cop_car_right", undefined, undefined, undefined, true, "tag_body_animate_jnt" );
	delay_thread( 35, ::play_fx, "magic_cop_car_left",  undefined, undefined, undefined, true, "tag_body_animate_jnt" );
	
	delay_thread( 52, ::exploder, EXPLODER_CITY_INTRO );
	
	scene_wait( "intro" );
	end_scene( "intro_gunner" );
}

intro_windshield_swap( vh_cougar )
{
	vh_cougar HidePart( "tag_windshield_clean" );
}

setup_argus()
{
	if ( !flag( "harper_dead" ) )
	{
		level.harper = GetEnt( "harper_drone", "targetname" );
		AddArgus( level.harper, "harper", "harper" );
	}
	
	level.hillary = GetEnt( "hillary_drone", "targetname" );
	AddArgus( level.hillary, "hillary", "hillary" );
	
	level.sam = GetEnt( "sam_drone", "targetname" );
	AddArgus( level.sam, "sam", "sam" );
	
	level.jones = GetEnt( "jones_drone", "targetname" );
	AddArgus( level.jones, "jones", "jones" );
}

sec_spit_and_drool( m_secretary )
{
	m_spit_fx = spawn_model( "tag_origin", m_secretary GetTagOrigin( "j_lip_top_ri" ), m_secretary GetTagAngles( "j_lip_top_ri" ));
	m_spit_fx LinkTo( level.intro_cougar, "tag_origin" );
	m_spit_fx play_fx( "blood_spit", undefined, undefined, -1, true, "tag_origin" );
	wait .5;
	m_secretary play_fx( "sec_drool", undefined, undefined, -1, true, "j_mouth_ri" );	
}

policecar_lights()
{
	GetEnt( "intro_copcar1", "targetname" ) thread play_fx_when_shown( "siren_light_intro", "tag_fx_siren_lights" );
	GetEnt( "intro_copcar2", "targetname" ) thread play_fx_when_shown( "siren_light_intro", "tag_fx_siren_lights" );
	GetEnt( "intro_copcar3", "targetname" ) thread play_fx_when_shown( "siren_light_intro", "tag_fx_siren_lights" );
	GetEnt( "intro_copcar4", "targetname" ) thread play_fx_when_shown( "siren_light_intro", "tag_fx_siren_lights" );
	GetEnt( "intro_copcar5", "targetname" ) thread play_fx_when_shown( "siren_light_intro", "tag_fx_siren_lights" );
	
	GetEnt( "intro_bike1", "targetname" ) thread play_fx_when_shown( "siren_light_bike_intro", "tag_fx_lights_front" );
	GetEnt( "intro_bike2", "targetname" ) thread play_fx_when_shown( "siren_light_bike_intro", "tag_fx_lights_front" );
	GetEnt( "intro_bike3", "targetname" ) thread play_fx_when_shown( "siren_light_bike_intro", "tag_fx_lights_front" );
	GetEnt( "intro_bike4", "targetname" ) thread play_fx_when_shown( "siren_light_bike_intro", "tag_fx_lights_front" );
}

play_fx_when_shown( str_fx, str_tag )
{
	self endon( "death" );
	
	while ( true )
	{
		self waittill( "show" );
		wait RandomFloatRange( 0, .3 );
		play_fx( str_fx, undefined, undefined, "hide", true, str_tag );
		self waittill( "hide" );
	}
}

cougar3_aim( veh_cougar )
{
	veh_cougar3 = GetEnt( "intro_cougar3", "targetname" );
	veh_drone2 = GetEnt( "intro_drone2", "targetname" );
	
	veh_cougar3 maps\_turret::set_turret_target( veh_drone2, undefined, 2 );	                    
}

fade_in( m_player_body )
{
	flag_set( "end_intro_screen" );	

}

intro_shellshock( m_player_body )
{
//	turn_off_windshield_bink();
	
	Earthquake( 0.75, 2, level.player.origin, 1000 );
	level.player ShellShock( "la_1_crash_exit", 2 );
}

ambient_drones()
{
	level thread spawn_ambient_drones( "trig_highway_flyby_1", "kill_highway_flyby_2", "pegasus_highway_flyby_1", "f38_highway_flyby_1", "start_highway_flyby_1", 5, 0, 3, 4, 500, 1 );
	level thread spawn_ambient_drones( "trig_highway_flyby_2", "kill_highway_flyby_2", "pegasus_highway_flyby_2", "f38_highway_flyby_2", "start_highway_flyby_2", 5, 0, 3, 4, 500, 3 );	
	level thread spawn_ambient_drones( "trig_highway_flyby_3", "kill_highway_flyby_2", "pegasus_highway_flyby_3", "f38_highway_flyby_3", "start_highway_flyby_3", 5, 0, 4, 5, 500, 5 );		
	level thread spawn_ambient_drones( "trig_highway_flyby_4", "kill_highway_flyby_2", "pegasus_highway_flyby_4", "f38_highway_flyby_4", "start_highway_flyby_4", 5, 0, 4, 5, 500, 5 );	

	wait( 0.05 );
	
	trigger_use( "trig_highway_flyby_1" );
	trigger_use( "trig_highway_flyby_2" );	
	trigger_use( "trig_highway_flyby_3" );		
	trigger_use( "trig_highway_flyby_4" );

	level waittill_any_return( "sniper_option", "rappel_option" );	

	trigger_use( "kill_highway_flyby_2" );
}

/#
show_vehicle_count()
{
	while ( 1 )
	{
		vehicles = GetVehicleArray();
		
		ambient_count = 0;
		foreach( vehicle in vehicles )
		{			
			if ( IsDefined( vehicle.b_is_ambient ) )
			{
				ambient_count++;		
			}
		}
		
		IPrintLn( "Count: " + vehicles.size + " Ambient: " + ambient_count );
		wait( 0.05 );
	}
}
#/