#include common_scripts\utility;
#include maps\_utility;
#include maps\la_utility;
#include maps\_scene;
#include maps\_turret;
#include maps\_vehicle;
#include maps\_music;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;
#insert raw\maps\la_1.gsh;

/* ------------------------------------------------------------------------------------------
SKIPTOS
-------------------------------------------------------------------------------------------*/
skipto_after_attack()
{
	start_teleport( "skipto_sam" );
	fade_to_black( 0 );
}

skipto_sam_jump()
{
	start_teleport( "skipto_sam" );		
	flag_set( "cougar_crawl_started" );	// skip this scene
}

skipto_sam()
{
	level thread run_scene( "sam_cougar_align" );
	start_teleport( "skipto_sam" );		
	flag_set( "cougar_crawl_started" );	// skip this scene
	flag_set( "sam_cougar_mount_started" );
	level thread set_cougar_objective();
}

skipto_cougar_fall()
{
	flag_set( "sam_complete" );
}

/////////////////////////////////////////////////////////////// Main Functions

#define DELAY_FALLING_DEBRIS_1 15

main()
{
	load_gump( "la_1_gump_1b" );
	
	flag_clear( "drone_approach" );
	
	SetDvar( "aim_assist_script_disable", 1 );
	
	flag_set( "drone_approach" );
	flag_set( "intro_done" );
	
	level.harper	= init_hero( "harper" );
	level.hillary	= init_hero( "hillary" );
	level.bill		= init_hero( "bill" );
	level.jones		= init_hero( "jones" );
	
	//spawn_vehicles_from_targetname( "high_road_civ_cars" );
	
	exploder( EXPLODER_FREEWAY_DESTRUCTION );
	run_scene_first_frame( "sam_cougar_fall_vehilces" );
	
	Start3DCinematic( "sam_hud", true, false );
	level thread spawn_ambient_drones();
	
	level thread run_scene( "sam_cougar_align" );
	level thread run_scene( "cougar_crawl_dead_loop" );
	
	SetSavedDvar( "sm_sunSampleSizeNear", 0.5 );
	
	level delay_notify( "fxanim_debris_01_start", DELAY_FALLING_DEBRIS_1 );
	after_the_attack();
	
	level thread get_to_sam_fail();
	
	//Start the thread to play the SAM ambient sounds
	level thread maps\la_1_amb::play_sam_ambience();

	sam_jump();
	
	// GO TO sam_main()
}

sam_main()
{
	level.harper	= init_hero( "harper" );
	level.hillary	= init_hero( "hillary" );
	level.bill		= init_hero( "bill" );
	level.jones		= init_hero( "jones" );
	
	get_on_sam();
	
	level delay_thread( 5, ::drone_sam_attack );
	level thread sam_vo();
	
	flag_wait( "sam_success" );
	
	get_off_sam();
	
	flag_set( "sam_complete" );
	
	// GO TO cougar_fall()
}

cougar_fall()
{
	level.harper	= init_hero( "harper" );
	level.hillary	= init_hero( "hillary" );
	level.bill		= init_hero( "bill" );
	level.jones		= init_hero( "jones" );
	
	a_av_allies_spawner_targetnames = array( "f35_fast" );	
	a_av_axis_spawner_targetnames = array( "avenger_fast" );
	
	level thread spawn_aerial_vehicles( 10, a_av_allies_spawner_targetnames, a_av_axis_spawner_targetnames );
		
	PlaySoundAtPosition( "evt_cougar_dismount", ( 0, 0, 0 ) );
    level thread f35_intro();
    level thread run_scene_and_delete( "sam_cougar_fall_vehilces" );
    
    level thread run_scene_and_delete( "close_call_drone" );
    level thread run_scene_and_delete( "sam_cougar_fall" );
    
    level.player delay_thread( 4, ::switch_player_scene_to_delta );
    level.player delay_thread( 14.5, ::play_stylized_impact_audio );
    
    level thread close_call_explosion();
    
    level thread fa38_rumble();
	
    scene_wait( "sam_cougar_fall" );
    
    level.player show_hud();
	    
    level.player stop_magic_bullet_shield();
    
    Stop3DCinematic();
    
    level.player maps\_dialog::say_dialog( "septic_007", .2 );
    level.player maps\_dialog::say_dialog( "long_story_stay_i_008", .7 );
    
    if ( is_greenlight_build() )
    {
    	fade_to_black( 2 );
    	array_delete( level.heroes );
    	maps\la_low_road::skipto_g20();
    }
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

sam_jump()
{
	trigger_wait( "sam_jump_trig" );
	level notify( "player_on_turret" );
	
	SetMusicState( "LA_1_TURRET_JUMP" );
	
	PlaySoundAtPosition( "evt_cougar_mount", (0, 0, 0) );
	
	level.player magic_bullet_shield();
	
	level.player hide_hud();	
	run_scene_and_delete( "sam_cougar_mount" );
	
	SetMusicState("LA_1_TURRET");
	
	fade_to_black( 0 );	
}

play_stylized_impact_audio()
{
	level.player playsound( "evt_big_impacts" );
}

drone_explode_impact( m_fxanim_drone )
{
	Earthquake( .8, .8, level.player.origin, 200 );
	level.player PlayRumbleOnEntity( "damage_heavy" );
}

close_call_explosion()
{
	scene_wait( "close_call_drone" );
	
	veh_drone = GetEnt( "cougar_crawl_drone", "targetname" );	
	v_origin = veh_drone GetTagOrigin( "origin_animate_jnt" );
	v_angles = veh_drone GetTagAngles( "origin_animate_jnt" );
	
	play_fx( "close_call_drone_explode", v_origin, v_angles );
	        
    level notify( "fxanim_drone_explode_start" );
    level.player PlayRumbleOnEntity( "grenade_rumble" );
    
    veh_drone Delete();
}

fa38_rumble()
{
	wait 20;
	
	veh_fa38 = GetEnt( "f35_vtol", "targetname" );
	veh_fa38 PlayRumbleOnEntity( "la_1_fa38_intro_rumble" );
}

autoexec event_funcs()
{
	if ( !level.createFX_enabled )
	{
		add_flag_function( "cougar_crawl_started", ::cougar_crawl_drone );
		add_spawn_function_veh( "sam_cougar", ::sam_cougar );	
		add_spawn_function_veh( "after_attack_explosion_launch_drone_1" , ::after_attack_explosion_launch_drone_1 );
	}
}

after_the_attack()
{
	if ( !flag( "cougar_crawl_started" ) )
	{
		fade_to_black( 0 );
		
		run_scene_first_frame( "cougar_crawl" );
		run_scene_first_frame( "cougar_crawl_player" );
		
		delay_thread( 1.5, ::cougar_crawl_vo );
		fade_with_shellshock_and_visionset();
		
		PlaySoundAtPosition( "evt_first_cougar_climb_out", ( 0, 0, 0 ) );
		
		level thread run_scene_and_delete( "cougar_crawl" );
		run_scene_and_delete( "cougar_crawl_player" );
		
		level.player thread maps\_dialog::say_dialog( "only_one_way_to_fi_009" );
		
		level thread autosave_by_name( "cougar_crawl" );
	}
	
	ClientNotify( "reset_snapshot" );
	
	//level thread run_scene( "cougar_crawl_loop" );
	
	setmusicstate ("LA_POST_CRASH");
	
	spawn_vehicle_from_targetname_and_drive( "after_attack_explosion_launch_drone_1" );
	
	level delay_thread( 3, ::set_cougar_objective );
}

cougar_crawl_vo()
{
	level.harper maps\_dialog::say_dialog( "madam_president_001" );
	level.hillary maps\_dialog::say_dialog( "no_bill_and_i_a_003", .5 );
	//level.hillary maps\_dialog::say_dialog( "what_the_hell_are_004", .5 ); // doesn't fit
	level.harper maps\_dialog::say_dialog( "stay_alert__stay_005", .5 );
	level.harper maps\_dialog::say_dialog( "agent_jones_h_stay_005", .5 );
	level.jones maps\_dialog::say_dialog( "thats_my_job_006", .2 );
	level.harper maps\_dialog::say_dialog( "well_youre_going_007", .2 );
	
	flag_wait( "near_sam_cougar" );
	
	level.harper maps\_dialog::say_dialog( "septic_what_the_001" );
	level.player maps\_dialog::say_dialog( "ill_create_a_dist_002", .5 );
}

after_attack_explosion_launch_drone_1()
{
	self endon( "death" );
	
	wait .7;
	
	e_target = GetEnt( "after_attack_explosion_launch_target_1", "targetname" );
	self maps\_turret::shoot_turret_at_target_once( e_target, undefined, 1 );
}

set_cougar_objective()
{
	waittillframeend;	// the cougar is spawned by the scene, so make sure it's spawned before we get it
	v_sam_org = GetEnt( "sam_cougar", "targetname" ) GetTagOrigin( "tag_gunner_barrel2" );
	maps\_objectives::set_objective( level.OBJ_SHOOT_DRONES, v_sam_org, "use" );
	v_sam_cougar = GetEnt( "sam_cougar", "targetname" );
	v_sam_cougar Attach( "veh_t6_mil_cougar_hood_obj", "tag_grill" );
	flag_wait( "sam_cougar_mount_started" );
	v_sam_cougar Detach( "veh_t6_mil_cougar_hood_obj", "tag_grill" );
	maps\_objectives::set_objective( level.OBJ_SHOOT_DRONES );
	flag_wait( "sam_cougar_fall_started" );
	maps\_objectives::set_objective( level.OBJ_SHOOT_DRONES, undefined, "done" );
}

get_to_sam_fail()
{
	level endon( "cougar_mount_started" );
	
	level thread get_to_sam_magic_bullets();
	level thread get_to_sam_straffing_runs();
	
	wait 20;
	
	level thread death_by_drone();
}

get_on_sam()
{
	sam_cougar = GetEnt( "sam_cougar", "targetname" );
	sam_cougar MakeVehicleUsable();
	sam_cougar UseVehicle( level.player, 2 );
	sam_cougar MakeVehicleUnusable();
	
	level.player magic_bullet_shield();
	
	sam_cougar hide_sam_turret();
 	
	level.player thread sam_turret_bink();
	
	SetDvar( "aim_assist_script_disable", 0 );
	
	level.player.old_aim_assist_min_target_distance = GetDvarInt( "aim_assist_min_target_distance" );
    level.player SetClientDvar( "aim_assist_min_target_distance", 100000 );   // default is  10000
    
    level.player.aim_turnrate_pitch_ads = GetDvarFloat(  "aim_turnrate_pitch_ads" );
    level.player.aim_turnrate_yaw_ads = GetDvarFloat(  "aim_turnrate_yaw_ads" );    
    
    level.player SetClientDvar( "aim_turnrate_pitch_ads", 120 );
    level.player SetClientDvar( "aim_turnrate_yaw_ads", 150 );
    
    fade_from_black( .2 );
}

hide_sam_turret()
{
	self HidePart( "tag_body_animate_jnt", "veh_t6_mil_cougar_turret_sam" );
	self HidePart( "gunner_turret2_animate_jnt", "veh_t6_mil_cougar_turret_sam" );
	self HidePart( "tag_enter_gunner2", "veh_t6_mil_cougar_turret_sam" );
	self HidePart( "tag_gunner_turret2", "veh_t6_mil_cougar_turret_sam" );
	self HidePart( "tag_canopy", "veh_t6_mil_cougar_turret_sam" );
	self HidePart( "tag_gunner2", "veh_t6_mil_cougar_turret_sam" );
	self HidePart( "tag_gunner_barrel2", "veh_t6_mil_cougar_turret_sam" );
	self HidePart( "tag_gunner_brass2", "veh_t6_mil_cougar_turret_sam" );
	self HidePart( "tag_stick_base", "veh_t6_mil_cougar_turret_sam" );
	self HidePart( "tag_flash_gunner2", "veh_t6_mil_cougar_turret_sam" );
	self HidePart( "tag_flash_gunner2a", "veh_t6_mil_cougar_turret_sam" );
	self HidePart( "tag_screen", "veh_t6_mil_cougar_turret_sam" );
	self HidePart( "tag_stick_grip", "veh_t6_mil_cougar_turret_sam" );
}

show_sam_turret()
{
	self ShowPart( "tag_body_animate_jnt", "veh_t6_mil_cougar_turret_sam" );
	self ShowPart( "gunner_turret2_animate_jnt", "veh_t6_mil_cougar_turret_sam" );
	self ShowPart( "tag_enter_gunner2", "veh_t6_mil_cougar_turret_sam" );
	self ShowPart( "tag_gunner_turret2", "veh_t6_mil_cougar_turret_sam" );
	self ShowPart( "tag_canopy", "veh_t6_mil_cougar_turret_sam" );
	self ShowPart( "tag_gunner2", "veh_t6_mil_cougar_turret_sam" );
	self ShowPart( "tag_gunner_barrel2", "veh_t6_mil_cougar_turret_sam" );
	self ShowPart( "tag_gunner_brass2", "veh_t6_mil_cougar_turret_sam" );
	self ShowPart( "tag_stick_base", "veh_t6_mil_cougar_turret_sam" );
	self ShowPart( "tag_flash_gunner2", "veh_t6_mil_cougar_turret_sam" );
	self ShowPart( "tag_flash_gunner2a", "veh_t6_mil_cougar_turret_sam" );
	self ShowPart( "tag_screen", "veh_t6_mil_cougar_turret_sam" );
	self ShowPart( "tag_stick_grip", "veh_t6_mil_cougar_turret_sam" );
}

get_off_sam()
{
	sam_cougar = GetEnt( "sam_cougar", "targetname" );
	
	fade_to_black( 0 );
	
	sam_cougar UseBy( level.player );
	sam_cougar show_sam_turret();
	
	level.player SetClientDvar( "aim_assist_min_target_distance", level.player.old_aim_assist_min_target_distance );
    level.player SetClientDvar( "aim_turnrate_pitch_ads", level.player.aim_turnrate_pitch_ads );
    level.player SetClientDvar( "aim_turnrate_yaw_ads", level.player.aim_turnrate_yaw_ads ); 	

    level delay_thread( 0.3, ::fade_from_black, 0.3 );
    
    SetMusicState("LA_1_OFF_TURRET");
}

cougar_crawl_drone()
{
	wait 5;
	
	veh_drone = GetEnt( "cougar_crawl_drone", "targetname" );
	
	if ( IsDefined( veh_drone ) )
	{
		veh_drone thread fire_turret_for_time( -1, 0 );		
		veh_drone thread fire_turret_for_time( -1, 1 );
		veh_drone thread fire_turret_for_time( -1, 2 );
	}
}

f35_intro()
{
	flag_wait( "sam_cougar_fall_started" );
	veh_drone = GetEnt( "cougar_crawl_drone", "targetname" );
	veh_f35 = GetEnt( "f35_vtol", "targetname" );
	veh_f35 set_turret_target( veh_drone, (0, 0, 0), 0 ); // Turret firing handled by notetrack
}

sam_cougar()
{
	level.sam_cougar = self;
	
	self godon();
	
	scene_wait( "sam_cougar_mount" );
	
	self godoff();
	
	self.overrideVehicleDamage = ::sam_cougar_damage;
}

sam_cougar_damage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, timeOffset, damageFromUnderneath, modelIndex, partName )
{
	MAX_DAMAGE = 6000;
	
	if ( !IsDefined( level.sam_cougar_damage ) )
	{
		level.sam_cougar_damage = 0;
	}
	
	level.sam_cougar_damage += iDamage;
	
	/#
		//IPrintLn( level.sam_cougar_damage );
	#/
	
	if ( level.sam_cougar_damage > MAX_DAMAGE )
	{
		level.player stop_magic_bullet_shield();
		level.player Suicide();
	}
	
	return 0;
}

ambient_drone()
{
	self endon( "death" );
	
	self SetForceNoCull();
	self SetNearGoalNotifyDist( 500 );	
	self ent_flag_init( "straffing" );
	
	self thread drone_fly();
	
	waittill_any_ents( self, "crash_done", level, "sam_success", level, "sam_cougar_mount_started" );
	//VEHICLE_DELETE( self );
	self Delete();
}

#define AMBIENT_DRONE_COUNT 40
	
spawn_ambient_drones()
{
	for ( i = 0; i < AMBIENT_DRONE_COUNT; i++ )
	{
		v_random_offset = level.player.origin + (RandomIntRange( -10000, 10000 ), RandomIntRange( -10000, 10000 ), RandomIntRange( 500, 3000 ));
		veh_drone = SpawnVehicle( MODEL_AVENGER_DRONE, "ambient_drone", "drone_avenger_fast", v_random_offset, FLAT_ANGLES( random_vector( 360 ) ) );
		veh_drone thread ambient_drone();
	}
}

get_to_sam_magic_bullets()
{
	while ( !flag( "sam_cougar_mount_started" ) )
	{
		level.player waittill_not_god_mode();
		
		for ( i = 0; i < 20; i++ )
		{
			v_player_forward = level.player get_forward( true );
			v_target_offset = random_vector( 300 );
			
			v_start = level.player.origin + ( 0, 0, 500 );
			v_end = level.player.origin + v_player_forward + v_target_offset;
					
			MagicBullet( "avenger_side_minigun", v_start, v_end );
			
			wait .05;
		}
		
		wait RandomFloatRange( 2, 4 );
	}
}

get_to_sam_straffing_runs()
{
	while ( !flag( "sam_cougar_mount_started" ) )
	{
		level.player waittill_not_god_mode();
		
		for ( i = 0; i < 3; i++ )
		{
			veh_drone = get_random_ambient_drone();
			if ( IsDefined( veh_drone ) )
			{
				if ( !veh_drone ent_flag( "straffing" ) )
				{
					veh_drone thread strafe_player( false );
				}
			}
		}
		
		wait 5;
	}	
}

death_by_drone()
{
	level.player EnableHealthShield( false );
	
	level thread death_by_drone_loop();
	
	//scene_wait( "sam_cougar_mount" );
	flag_wait( "sam_cougar_mount_started" );
	
	a_drones = get_vehicles( "ambient_drone", "targetname" );
	array_func( a_drones, ::ent_flag_clear, "straffing" );
}

death_by_drone_loop()
{
	while ( !flag( "sam_cougar_mount_started" ) )
	{
		level.player waittill_not_god_mode();
		
		veh_drone = get_random_ambient_drone();
		veh_drone strafe_player( true );
	}
}

get_random_ambient_drone()
{
	veh_drone = random( get_vehicles( "ambient_drone", "targetname" ) );
	return veh_drone;
}

/////////////////////////////////////////////////////////////////////////////////////////////
// SAM EVENT
/////////////////////////////////////////////////////////////////////////////////////////////

sam_vo()
{
	flag_wait( "start_sam_vo" );
	level.harper say_dialog( "septic_theyre_st_001" );
	level.player say_dialog( "thats_your_window_001" );
	
	flag_wait( "sam_success" );
	level.player say_dialog( "go_now_001" );
}

drone_sam_attack()
{
	level endon( "sam_complete" );
	level endon( "sam_success" );
	
	for ( i = 1; i <= 3; i++ )
	{
		n_count = i * 2;
		a_drones = spawn_sam_drone_group( n_count );
		array_wait( a_drones, "death" );
		
		wait 1;
	}
}

#define DRONE_GROUP_SPAWN_DIST 100000
#define DRONE_GROUP_SPAWN_HEIGHT 10000
	
#define DEBUG_DISPLAY_TIME 5 * 20
	
#define DRONE_SPAWN_ANGLE_MIN 170
#define DRONE_SPAWN_ANGLE_MAX 350

spawn_sam_drone_group( n_count )
{
	v_player_angles = level.sam_cougar GetTagAngles( "tag_gunner_barrel2" );
	v_spawn_angles = (0, clamp( AbsAngleClamp360( v_player_angles[1] + 180 ), DRONE_SPAWN_ANGLE_MIN, DRONE_SPAWN_ANGLE_MAX ), 0 );
	
	v_spawn_vector = AnglesToForward( v_spawn_angles ) * DRONE_GROUP_SPAWN_DIST;
	v_spawn_vector = level.player.origin + (v_spawn_vector[0], v_spawn_vector[1], DRONE_GROUP_SPAWN_HEIGHT);
	
	/#
	v_spawn_angles = VectorToAngles( v_spawn_vector );
	IPrintLnBold( v_spawn_angles[1] );
	#/
	
	v_angles = VectorToAngles( -1 * v_spawn_vector );
	
	v_spawn_horizon = AnglesToRight( v_angles );
	v_spawn_vert_offset = AnglesToUp( v_angles );
		
	a_spawned_drones = [];
	
	for ( i = 0; i < n_count; i++ )
	{
		v_origin = v_spawn_vector + v_spawn_horizon * RandomIntRange( -20000, 20000 ) + v_spawn_vert_offset * RandomIntRange( -5000, 5000 );
		
		veh_drone = spawn_vehicle_from_targetname( "sam_drone" );
		
		veh_drone.origin = v_origin;
		veh_drone SetPhysAngles( v_angles );
		 
		veh_drone thread sam_drone();
		
		ARRAY_ADD( a_spawned_drones, veh_drone );
	}
	
	return a_spawned_drones;
}

sam_drone()
{
	self endon( "death" );
	
	self SetForceNoCull();
	self SetNearGoalNotifyDist( 500 );
	self ent_flag_init( "straffing" );
	
	self SetSpeed( RandomIntRange( 250, 300 ) );
	
	self thread sam_drone_death();
	self thread drone_explode();
	self thread strafe_player( false, level.sam_cougar, "tag_gunner_barrel2" );
	
	self thread fall_out_of_world();
	
	/#
	self thread death_cheat();
	#/
	
	waittill_any_ents( self, "crash_done", level, "sam_success" );
	//VEHICLE_DELETE( self );
	self Delete();
}

/#
death_cheat()
{
	self endon( "death" );
	
	while ( true )
	{
		if ( level.player SprintButtonPressed() && level.player MeleeButtonPressed() )
		{
			self DoDamage( 100000, self.origin, level.player, 0, "projectile" );
			break;
		}
		
		wait .05;
	}
}
#/

fall_out_of_world()
{
	self endon( "death" );
	
	while ( self.origin[2] > -5000 )
	{
		wait .05;
	}
	
	//VEHICLE_DELETE( self );
	self Delete(0);
}

drone_explode()
{
	self waittill( "death" );
	if ( IsDefined( self ) )
	{
		PlayFx( level._effect[ "sam_drone_explode" ], self.origin, (0, 0, 1), AnglesToForward( self.angles ) );
	}
}

#define DRONE_NUM_SUCCESS 12

sam_drone_death()
{
	level endon( "sam_success" );
	
	if ( !IsDefined( level.num_planes ) )
	{
		level.num_planes = 0;
	}
		
	level.num_planes++;
	
	self waittill( "death" );
	
	if ( IsDefined( level.num_planes ) )
	{
		level.num_planes--;
	}
	
	if ( !IsDefined( level.num_planes_shot ) )
	{
		level.num_planes_shot = 0;
	}
	
	if ( ( DRONE_NUM_SUCCESS - level.num_planes_shot ) <= 2 )
	{
		flag_set( "start_sam_vo" );
	}
	
	level.num_planes_shot++;
	level notify( "sam_hint_drone_killed" );
	
	n_drones_count = get_vehicles( "ambient_drone", "targetname" ).size;
	if ( level.num_planes_shot >= DRONE_NUM_SUCCESS )
	{
		level delay_thread( 1, ::flag_set, "sam_success" );
	}
}

strafe_player( b_missiles, e_target, e_target_tag )
{
	self endon( "death" );
	
	level endon( "sam_cougar_mount_started" );
	
	self notify( "_strafe_player_" );
	self endon( "_strafe_player_" );
	
	if ( !IsDefined( e_target ) )
	{
		e_target = level.player;
	}
	
	if ( !IsDefined( b_missiles ) )
	{
		b_missiles = false;
	}
	
	self ent_flag_set( "straffing" );
	
	self thread strafe_player_plane_fire_guns( b_missiles );
	
	v_forward = e_target get_forward( true, e_target_tag );
	v_goal = e_target.origin + v_forward * 10000 + ( 0, 0, 2000 );
	
	/#
		self thread debug_goal( v_goal );
	#/
	
	self SetVehGoalPos( v_goal, 0 );
	
	self waittill( "near_goal" );
		
	v_forward = e_target get_forward( true, e_target_tag );
	v_goal = e_target.origin + v_forward * 500 + ( 0, 0, 500 );
	
	/#
		self thread debug_goal( v_goal );
	#/
	
	self SetVehGoalPos( v_goal, 0 );
		
	self waittill( "near_goal" );
	
	self ent_flag_clear( "straffing" );
}

debug_goal( v_goal )
{
	self endon( "goal" );
	self endon( "near_goal" );
	
	while ( true )
	{
		DebugStar( v_goal, 1, ( 1, 0, 0 ) );
		wait .05;
	}
}

strafe_player_plane_fire_guns( b_missles )
{
	self endon( "death" );
	self endon( "_strafe_player_" );
	
	level endon( "sam_cougar_mount_started" );
	
	if ( !IsDefined( b_missles ) )
	{
		b_missles = true;
	}
		
	do
	{
		wait .1;
		
		vec_to_target = level.player get_eye() - self.origin;
		vec_to_target = VectorNormalize( vec_to_target );
				
		forward = AnglesToForward( self.angles );
		b_facing_player = VectorDot( forward, vec_to_target ) > 0.9;
		
		wait ( 0.05 );
	}
	while ( !b_facing_player );
	
	if ( self.health > 0 )
	{
		self thread shoot_turret_at_target( level.player, 4, ( 50, 0, 50 ), 0 );
		
		if ( b_missles )
		{
			self thread shoot_turret_at_target( level.player, 2, ( 0, 0, 50 ), 1 );
			self thread shoot_turret_at_target( level.player, 2, ( 0, 0, 50 ), 2 );
		}
	}
}

get_sam_forward()
{
	v_angles = self GetTagAngles( "tag_gunner_barrel2" );
	v_forward = AnglesToForward( flat_angle( v_angles ) );
	return v_forward;
}

get_sam_pos()
{
	v_pos = self GetTagOrigin( "tag_gunner_barrel2" );
	return v_pos;
}

get_best_drone_for_straffing()
{
	a_drones = get_vehicles( "ambient_drone", "targetname" );
	v_forward = level.sam_cougar get_sam_forward();
	
	n_dot_best = 0;
	foreach ( veh_drone in a_drones )
	{
		v_to_drone = veh_drone.origin - level.sam_cougar get_sam_pos();
		n_dot = VectorDot( v_forward, v_to_drone );
		if ( n_dot > n_dot_best )
		{
			n_dot_best = n_dot;
			veh_drone_best = veh_drone;
		}
	}
	
	return veh_drone_best;
}

drone_fly()
{
	self endon( "death" );
	
	a_goal_groups[0] = GetStructArray( "plane_goto1", "targetname" );
	a_goal_groups[1] = GetStructArray( "plane_goto2", "targetname" );
	a_goal_groups[2] = GetStructArray( "plane_goto3", "targetname" );
	a_goal_groups[3] = GetStructArray( "plane_goto4", "targetname" );
	
	if ( cointoss() )
	{
		a_goal_groups = array_reverse( a_goal_groups );
	}

	while ( true )
	{
		foreach ( a_goals in a_goal_groups )
		{
			self ent_flag_waitopen( "straffing" );
		
			self SetSpeed( RandomIntRange( 200, 300 ), 300, 300 );
			
			do
			{
				new_goal = random( a_goals );
			}
			while( IS_EQUAL( self.current_goal, new_goal ) );
			
			self.current_goal = new_goal;
				
			self SetVehGoalPos( self.current_goal.origin, 0 );		
			self waittill( "near_goal" );
		}
	}
}

drone_evade()
{
	self endon( "goal" );
	
	self waittill( "missileTurret_fired_at_me" );
	
	angles = self.angles;
	
	pitch = AngleClamp180( angles[0] );
	yaw = AngleClamp180( angles[1] );
	
	pitch += RandomIntRange( -15, 15 );
	yaw += RandomIntRange( -5, 5 );
	
	dir = AnglesToForward( ( pitch, yaw, 0 ) );
	goal_pos = self.origin + dir * 5000;
	
	self SetVehGoalPos( goal_pos, 0 );
}

plane_fire_weapons()
{
	self endon( "death" );
	
	facing_player = false;
	
	while ( !facing_player )
	{
		vec_to_target = level.player.origin - self.origin;
		vec_to_target = VectorNormalize( vec_to_target );
				
		forward = AnglesToForward( self.angles );	
		if ( VectorDot( forward, vec_to_target ) > 0.9 )
		{
			facing_player = true;
		}
		
		wait ( 0.05 );
	}
	
	self maps\_turret::set_turret_target( level.player, ( 0, 0, 0 ), 1 );
	self thread maps\_turret::fire_turret_for_time( 8, 1 ); 
	
	self maps\_turret::set_turret_target( level.player, ( 0, 0, 0 ), 2 );
	self thread maps\_turret::fire_turret_for_time( 8, 2 ); 
	
	wait ( RandomFloatRange( 2, 3 ) );
	
	if ( RandomFloatRange( 0, 1 ) < 0.25 )
	{
		self maps\_turret::set_turret_target( level.player, ( 0, 0, 0 ), 0 );
		self thread maps\_turret::fire_turret_for_time( 1.1, 0 ); 	
	}
}

sam_turret_bink()
{	
	self endon( "death" );
	
	while ( !flag( "sam_complete" ) )
	{
		self waittill( "lock_on_missile_turret_start" );
		Stop3DCinematic();
		level notify( "sam_turret_bink" );
		Start3DCinematic( "sam_cycle", false, false);		
//		thread sam_turret_bink_think();
	}
}

sam_turret_bink_think()
{
	level endon( "sam_turret_bink" );
	
	Start3DCinematic( "sam_cycle", false, false);
	wait ( 1 );
	Start3DCinematic( "sam_cycle_loop", false, false);
}

/////////////////////////////////////////////////////////////////////////////////////////////
// SAM CHALLENGES
/////////////////////////////////////////////////////////////////////////////////////////////
challenge_turretdrones( str_notify )
{
	trigger_wait( "sam_jump_trig" );
	
	level.player thread sam_fired_listener();	// used for challenge tracking	
	
	flag_wait( "sam_success" );
	
	if ( level.n_sam_missiles_fired == level.num_planes_shot )
	{
		self notify( str_notify );
	}	
}

sam_fired_listener()
{
	level.n_sam_missiles_fired = 0;
	
	while ( !flag( "sam_complete" ) )
	{
		self waittill( "missileTurret_fired" );
		level.n_sam_missiles_fired++;
	}
}
