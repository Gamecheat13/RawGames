#include common_scripts\utility;
#include maps\_utility;
#include maps\la_utility;
#include maps\_scene;
#include maps\_turret;
#include maps\_vehicle;
#include maps\_music;
#include maps\_dialog;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;
#insert raw\maps\la.gsh;

/* ------------------------------------------------------------------------------------------
SKIPTOS
-------------------------------------------------------------------------------------------*/
skipto_after_attack()
{
	skipto_teleport( "skipto_sam" );
	screen_fade_out( 0 );
}

skipto_sam_jump()
{
	skipto_teleport( "skipto_sam" );
	
	run_scene_first_frame( "cougar_crawl" );
	skip_scene( "cougar_crawl" );
	skip_scene( "cougar_crawl_player" );
	
	if ( !flag( "harper_dead" ) )
	{
		run_scene_first_frame( "cougar_crawl_harper" );
		skip_scene( "cougar_crawl_harper" );
	}
}

skipto_sam()
{
	skipto_teleport( "skipto_sam" );
	
	skip_scene( "cougar_crawl" );
	skip_scene( "cougar_crawl_player" );
	skip_scene( "sam_cougar_mount" );
	
	level thread run_scene( "sam_cougar_align" );
	
	level thread drone_sam_attack();
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
	
	ClientNotify( "argus_zone:off" );
	
	flag_clear( "drone_approach" );
	
	SetDvar( "aim_assist_script_disable", 1 );
	
	flag_set( "drone_approach" );
	
	init_hero( "harper" );
	init_hero( "hillary" );
	init_hero( "sam" );
	init_hero( "jones" );
	
	stop_exploder(10);	// Turn off intro effects
	exploder( EXPLODER_FREEWAY_DESTRUCTION );
	run_scene_first_frame( "sam_cougar_fall_vehilces" );
	
	//level thread spawn_ambient_drones();
	
	level thread run_scene_and_delete( "sam_cougar_align" );
	level thread run_scene_and_delete( "cougar_crawl_dead_loop" );
	
	SetSavedDvar( "sm_sunSampleSizeNear", 0.5 );
	
	clientnotify( "sdlbg" );
	level delay_notify( "fxanim_debris_01_start", DELAY_FALLING_DEBRIS_1 );
	OnSaveRestored_Callback( ::save_restored_function );
	level thread after_the_attack();
	
	scene_wait( "cougar_crawl_player" );
	
	ClientNotify( "argus_zone:default" );
	
	//Start the thread to play the SAM ambient sounds
	level thread maps\la_1_amb::play_sam_ambience();

	sam_jump();
	OnSaveRestored_CallbackRemove( ::save_restored_function );
	
	// GO TO sam_main()
}


save_restored_function()
{
	// temporary fix for restart issue with sound not playing after dying on freeway. -TravisJ 11/4/2011
	PlaySoundAtPosition("vox_blend_post_cougar", (7850,-57200,680));
}

sam_main()
{
	init_hero( "harper" );
	init_hero( "hillary" );
	init_hero( "sam" );
	init_hero( "jones" );
	
	SetMusicState("LA_1_TURRET");
	
	get_on_sam();
	
	level.player thread sam_fired_listener();		
	level thread sam_vo();
	
	flag_wait( "sam_success" );
	
	get_off_sam();
	
	flag_set( "sam_complete" );
	
	// GO TO cougar_fall()
}

cougar_fall()
{
	init_hero( "harper" );
	init_hero( "hillary" );
	init_hero( "sam" );
	init_hero( "jones" );
	
	a_av_allies_spawner_targetnames = array( "f35_fast" );
	a_av_axis_spawner_targetnames = array( "avenger_fast" );
	
//	level thread spawn_aerial_vehicles( 10, a_av_allies_spawner_targetnames, a_av_axis_spawner_targetnames );
	
	clientnotify( "set_sam_ext_context" );
    level thread f35_intro();
    
    level thread run_scene_and_delete( "sam_cougar_fall_player" );
    level thread run_scene_and_delete( "sam_cougar_fall_vehilces" );
    
    level thread run_scene_and_delete( "close_call_drone" );
    level thread run_scene_and_delete( "sam_cougar_fall" );
    
    if ( !flag( "harper_dead" ) )
    {
    	level thread run_scene_and_delete( "sam_cougar_fall_harper" );
    }
        
    level.player delay_thread( 4, ::switch_player_scene_to_delta );
    level.player delay_thread( 14.5, ::play_stylized_impact_audio );
    level.player delay_thread( 33, ::lock_view_clamp_over_time, 2 );
	
    level thread fa38_rumble();
    level thread cougar_fall_exploders();
	
    scene_wait( "sam_cougar_fall" );
    level clientnotify( "and_reveal" );
    level thread f38_flyoff();
    
    level thread vehicle_bullet_collisions();
    
    level.player stop_magic_bullet_shield();    
    aerial_vehicles_no_target();
}


vehicle_bullet_collisions()
{
	vh_police_car1 = GetEnt( "sam_jump_police_car", "targetname" );
	vh_police_car2 = GetEnt( "police_car_flip", "targetname" );
	vh_police_mc1 = GetEnt( "upper_freeway_cycle", "targetname" );
	vh_police_mc2 = GetEnt( "lower_freeway_cycle1", "targetname" );
	vh_police_mc3 = GetEnt( "lower_freeway_cycle2", "targetname" );
	vh_police_mc4 = GetEnt( "lower_freeway_cycle3", "targetname" );
	vh_police_mc5 = GetEnt( "lower_freeway_cycle4", "targetname" );
	vh_cougar2 = GetEnt( "g20_group1_cougar2", "targetname" );
	
	if ( IsDefined( vh_police_car1 ) )
	{
		vh_police_car1 IgnoreCheapEntityFlag( true );
	}
	
	if ( IsDefined( vh_police_car2 ) )
	{
		vh_police_car2 IgnoreCheapEntityFlag( true );
	}
	
	if ( IsDefined( vh_police_mc1 ) )
	{
		vh_police_mc1 IgnoreCheapEntityFlag( true );
	}
	
	if ( IsDefined( vh_police_mc2 ) )
	{
		vh_police_mc2 IgnoreCheapEntityFlag( true );
	}
	
	if ( IsDefined( vh_police_mc3 ) )
	{
		vh_police_mc3 IgnoreCheapEntityFlag( true );
	}
	
	if ( IsDefined( vh_police_mc4 ) )
	{
		vh_police_mc4 IgnoreCheapEntityFlag( true );
	}
	
	if ( IsDefined( vh_police_mc5 ) )
	{
		vh_police_mc5 IgnoreCheapEntityFlag( true );
	}
	
	if ( IsDefined( vh_cougar2 ) )
	{
		vh_cougar2 IgnoreCheapEntityFlag( true );
	}
}


hide_hatch( veh_cougar )
{
	veh_cougar HidePart( "tag_turret_hatch_r_jnt" );
	veh_cougar HidePart( "tag_turret_hatch_l_jnt" );
}

f38_flyoff()
{
	f38_struct = getstruct("anderson_f38_goto_struct", "targetname");
    veh_f38 = GetEnt("f35_vtol", "targetname");
    veh_f38 SetVehGoalPos( f38_struct.origin, true, 0);
    veh_f38 SetSpeed(250, 70);
    
    stop_exploder( 313 );
	exploder( 312 );
    
    veh_f38 waittill( "goal" );
    
    veh_f38 delete();
}

lock_view_clamp_over_time( n_time )
{
	level.player LerpViewAngleClamp( n_time, n_time / 2, n_time / 2, 0, 0, 0, 0 );
}

on_hillary_death( m_hillary )
{
	if (!flag( "sam_cougar_mount_started" ))
	{
		// When we reach this point, it'll complain that our heroes have a magic bullet shield, so nix them.
		level.jones stop_magic_bullet_shield();
		level.harper stop_magic_bullet_shield();
		level.hillary stop_magic_bullet_shield();
		level.sam stop_magic_bullet_shield();
		
		// fail condition.
		wait 1.0;
		
		PlayFx( level._effect[ "sam_drone_explode" ], level.player.origin - (0, 0, 3), (0, 0, 1));
		
		wait 0.5;
		
		if ( !IsGodMode( level.player ) )
		{
			level.player stop_magic_bullet_shield();
			level.player Suicide();
		}
	}
	else
	{
		// success condition.
		level.jones Delete();
		level.harper Delete();
		level.hillary Delete();
		level.sam Delete();
	}
}

player_hit_ground( m_player_body )
{
	level.player PlayRumbleOnEntity( "damage_heavy" );
}

fa38_intro_car_roof_sparks( veh_car )
{
	veh_car thread play_fx( "fa38_car_scrape_side", undefined, undefined, -1, true, "origin_animate_jnt" );
	wait .25;
	veh_car thread play_fx( "fa38_car_scrape_roof", undefined, undefined, -1, true, "origin_animate_jnt" );
}

after_burner_off( veh_fa38 )
{
	//veh_fa38 veh_toggle_exhaust_fx( false );
	veh_fa38 notify( "hover" );
	
	exploder( 313 );
	stop_exploder( 312 );
	
	wait 3;
	
	level thread fxanim_f35_hover();
}

after_burner_on( veh_fa38 )
{
	//veh_fa38 veh_toggle_exhaust_fx( true );
	veh_fa38 notify( "fly" );
	
	stop_exploder( 313 );
	exploder( 312 );
}

fxanim_f35_hover( vh_drone )
{
	level notify( "fxanim_f35_blast_chunks_start" );
	
	wait 1;
	
	//level notify( "fxanim_police_car_f35_start" );
}

cougar_fall_exploders()
{
	wait 10;
	
	exploder( 202 );
	
	wait 0.5;
	
	exploder( 203 );
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#define UNDER_SAM_TRIG_TIME 4

sam_jump()
{
	
	trigger_wait( "sam_jump_trig" );
	
	level notify( "player_on_turret" );
	
	set_straffing_drones( "off" );
	
	clientnotify( "scjs" );
	
	level thread maps\createart\la_1_art::lerp_sun_direction( (-95, 53, 0), 1 );
	
	end_scene( "cougar_crawl_dead_loop" );
	cleanup_kvp( "cougar_destroyed_fxanim", "targetname" );
	
	level thread maps\_audio::switch_music_wait("LA_1_TURRET", 0.5);
	
	//Kick off the turret state prior to playing animation for track blending purposes.
	//level thread maps\_audio::switch_music_wait("LA_1_TURRET", 14.0);
	
	//SetMusicState("LA_1_TURRET");
	
	level.player magic_bullet_shield();
	
	level delay_thread( UNDER_SAM_TRIG_TIME, ::trigger_use, "under_the_sam" );
	
	level thread drone_sam_attack();
	
	level thread play_explosion_on_cougar_climb();
	
	run_scene_and_delete( "sam_cougar_mount", 0.65 );
	
	reset_sun_direction( 0 );
	screen_fade_out( 0 );
	level.player hide_hud();
	
	array_delete( get_vehicle_array( "under_the_sam", "script_noteworthy" ) );
}

play_explosion_on_cougar_climb()
{
	wait 9.5;
	
	sam_explosion_struct = getstruct( "sam_explosion_struct", "targetname" );
	
	MagicBullet( MAGIC_MISSILE_DRONE, sam_explosion_struct.origin + ( 0, 0, 10 ), sam_explosion_struct.origin );
	
	wait 0.1;
	playsoundatposition ("wpn_rocket_explode", sam_explosion_struct.origin);
	playsoundatposition ("evt_turret_shake", (0,0,0));
	
	Earthquake( 0.5, 2, sam_explosion_struct.origin, 1000);
}

play_stylized_impact_audio()
{
	//level.player playsound( "evt_big_impacts" );
}

drone_explode_impact( m_fxanim_drone )
{
	Earthquake( .8, .8, level.player.origin, 200 );
	playsoundatposition ("evt_turret_shake", (0,0,0));
	level.player PlayRumbleOnEntity( "damage_heavy" );
}

fa38_rumble()
{
	wait 21; // for timing from begining of animation, easier to tune then a notetrack
	
	veh_fa38 = GetEnt( "f35_vtol", "targetname" );
	veh_fa38 PlayRumbleOnEntity( "la_1_fa38_intro_rumble" );
}

autoexec event_funcs()
{
	add_flag_function( "cougar_crawl_started", ::cougar_crawl_drone );
	add_spawn_function_veh( "sam_cougar", ::sam_cougar );
	add_spawn_function_veh( "after_attack_explosion_launch_drone_1" , ::after_attack_explosion_launch_drone_1 );
}

after_the_attack()
{
	level thread get_to_sam_exploders();
	level thread cougar_crawl_squibs();
	
	if ( is_scene_skipped( "cougar_crawl" ) )
	{
		
		level thread set_cougar_objective();
		level thread get_to_sam_straffing_runs();
	}
	else
	{
		run_scene_first_frame( "cougar_crawl" );
		run_scene_first_frame( "cougar_crawl_player" );
		
		if ( !flag( "harper_dead" ) )
		{
			run_scene_first_frame( "cougar_crawl_harper" );
		}
		else
		{
			run_scene_first_frame( "cougar_crawl_noharper" );
		}
		
		waittill_textures_loaded();
		screen_fade_out( 0 );
		fade_with_shellshock_and_visionset();
		
		//PlaySoundAtPosition( "evt_first_cougar_climb_out", ( 0, 0, 0 ) );
		level notify ("cougar_blend_go");
		
		level delay_thread( 17, ::set_cougar_objective );
		level delay_thread( 9, ::get_to_sam_straffing_runs );
		level delay_thread( 13, ::exploder, 210 );	// explosion behind harper
		level delay_thread( 18, ::exploder, 210 );	// explosion behind harper
		
		level thread run_scene_and_delete( "cougar_crawl_fxanim" );
		level thread run_scene_and_delete( "cougar_crawl" );
		level thread run_scene_and_delete( "cougar_crawl_player" );
		
		if ( !flag( "harper_dead" ) )
		{
			level thread run_scene_and_delete( "cougar_crawl_harper" );
		}
		else 
		{
			level thread run_scene_and_delete( "cougar_crawl_noharper" );
		}
		
		/# debug_timer(); #/
		
		level.player delay_thread( 4, ::switch_player_scene_to_delta );
		
		scene_wait( "cougar_crawl_player" );
		
		if ( flag( "harper_dead" ) )
		{
			level.player say_dialog( "sect_i_ll_get_on_the_stin_0" );	//I'll get on the stingers and knock out some of those drones!
		}
				
		level thread autosave_by_name( "cougar_crawl" );
	}
	
	ClientNotify( "reset_snapshot" );
		
	SetMusicState("LA_POST_CRASH");
	
	//level delay_thread( 3, ::spawn_vehicle_from_targetname_and_drive, "after_attack_explosion_launch_drone_1" );
	
	flag_wait( "near_sam_cougar" );
	if( !flag( "harper_dead" ) )
	{
		level.harper maps\_dialog::say_dialog( "take_‘em_out_befor_010" );
	}
	level.player maps\_dialog::say_dialog( "ill_create_a_dist_002", .5 );
}

cougar_crawl_squibs()
{
	level endon( "cougar_crawl_player_done" );
	
	level thread triggered_cougar_crawl_squib_structs();
	
	squib_orgs = get_struct_array( "cougar_crawl_squib_structs" );
	foreach ( s_squib in squib_orgs )
	{
		v_fx_org = s_squib.origin + ( -1 * AnglesToForward( s_squib.angles ) ) * 800;
		s_squib.m_fx_tag = spawn_model( "tag_origin", v_fx_org, s_squib.angles );
	}
	
	while ( true )
	{
		s_squib = random( squib_orgs );
		fx = getfx( "squibs_" + s_squib.script_string );
		PlayFXOnTag( fx, s_squib.m_fx_tag, "tag_origin" );
		wait RandomFloatRange( .2, 1 );
	}
}

triggered_cougar_crawl_squib_structs()
{
	squib_orgs = get_struct_array( "triggered_cougar_crawl_squib_structs", "script_noteworthy" );
	foreach ( s_squib in squib_orgs )
	{
		v_fx_org = s_squib.origin + ( -1 * AnglesToForward( s_squib.angles ) ) * 800;
		s_squib.m_fx_tag = spawn_model( "tag_origin", v_fx_org, s_squib.angles );
		s_squib thread do_triggered_cougar_crawl_squib_struct();
	}
}

do_triggered_cougar_crawl_squib_struct()
{
	trigger_wait( self.targetname, "target" );
	fx = getfx( "squibs_" + self.script_string );
	PlayFXOnTag( fx, self.m_fx_tag, "tag_origin" );
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

get_to_sam_exploders()
{
	if( !is_scene_skipped( "cougar_crawl" ) )
	{
		level waittill( "cougar_blend_go" );
		wait(13.3);
	}
	else
	{
		scene_wait( "cougar_crawl_player" );
	}
	
	exploder( 211 );
	
	level waittill( "fxanim_debris_02_start" );
	level notify( "fxanim_billboard_pillar_top03_start" );

	exploder( 212 );
	
	wait 1;
	
	exploder( 212 );
}

get_on_sam()
{
	sam_cougar = GetEnt( "sam_cougar", "targetname" );
	sam_cougar MakeVehicleUsable();
	sam_cougar UseVehicle( level.player, 2 );
	sam_cougar MakeVehicleUnusable();
	
    if ( level.skipto_point == "sam" )
    {
    	v_angles_to_use = level.sam_cougar.angles;
    }
    else
    {
    	v_angles_to_use = level.sam_cougar GetTagAngles( "tag_origin_animate_jnt" );
    }
    
	v_angles = v_angles_to_use - ( 0, 71, 0 );
	v_angles = ( -15 - v_angles[0], v_angles[1], v_angles[2] );
	
	//wait_network_frame();
	wait( 0.25 );

	//level.player StartCameraTween( 0.05 );
    level.player SetPlayerAngles( v_angles );
	
	level.player magic_bullet_shield();
	
	sam_cougar hide_sam_turret();
 	
	level.player thread sam_cougar_player_damage_watcher();
	level.player thread sam_attack_exploders();
	
	SetDvar( "aim_assist_script_disable", 0 );
	
	level.player.old_aim_assist_min_target_distance = GetDvarInt( "aim_assist_min_target_distance" );
    level.player SetClientDvar( "aim_assist_min_target_distance", 100000 );   // default is  10000
    
    level.player.aim_turnrate_pitch_ads = GetDvarFloat(  "aim_turnrate_pitch_ads" );
    level.player.aim_turnrate_yaw_ads = GetDvarFloat(  "aim_turnrate_yaw_ads" );
    
    level.player SetClientDvar( "aim_turnrate_pitch_ads", 120 );
    level.player SetClientDvar( "aim_turnrate_yaw_ads", 150 );
    
    screen_fade_in( 0.5 );
        SetSavedDvar( "r_stereo3DEyeSeparation", 0.01);

}

hide_sam_turret()
{
	self HidePart( "tag_gunner_turret2", "veh_t6_mil_cougar_turret_sam" );
	self HidePart( "tag_canopy", "veh_t6_mil_cougar_turret_sam" );
	self HidePart( "tag_stick_base", "veh_t6_mil_cougar_turret_sam" );
	self HidePart( "tag_screen", "veh_t6_mil_cougar_turret_sam" );
}

show_sam_turret()
{
	self ShowPart( "tag_gunner_turret2", "veh_t6_mil_cougar_turret_sam" );
	self ShowPart( "tag_canopy", "veh_t6_mil_cougar_turret_sam" );
	self ShowPart( "tag_stick_base", "veh_t6_mil_cougar_turret_sam" );
	self ShowPart( "tag_screen", "veh_t6_mil_cougar_turret_sam" );
}

get_off_sam()
{
	sam_cougar = GetEnt( "sam_cougar", "targetname" );
	
	screen_fade_out( 0 );
	
	sam_cougar ClearTargetEntity( 1 );
	sam_cougar UseBy( level.player );
	sam_cougar show_sam_turret();
	
	level.player SetClientDvar( "aim_assist_min_target_distance", level.player.old_aim_assist_min_target_distance );
    level.player SetClientDvar( "aim_turnrate_pitch_ads", level.player.aim_turnrate_pitch_ads );
    level.player SetClientDvar( "aim_turnrate_yaw_ads", level.player.aim_turnrate_yaw_ads );
    
    level.player show_hud();

    level delay_thread( 0.3, ::screen_fade_in, 0.3 );
    
    SetMusicState("LA_1_OFF_TURRET");
        SetSavedDvar( "r_stereo3DEyeSeparation", 0.6);
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
	
	level thread maps\la_1_amb::snapshot_drone();
	
	
	wait 14;
	
	veh_drone = GetEnt( "cougar_crawl_drone", "targetname" );
	s_missile_org = get_struct( "f35_intro_missile_org" );
	MagicBullet( MAGIC_MISSILE_FA38, s_missile_org.origin, s_missile_org.angles, undefined, veh_drone );
}

sam_cougar()
{
	level.sam_cougar = self;
	
	self Attach( "veh_t6_cougar_roof_decal", "tag_origin" );
	
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

sam_attack_exploders()
{
	exploder( 220 );
	exploder( 221 );
	exploder( 225 );
	exploder( 226 );

	level waittill( "drone_wave_1" );
	
	exploder( 223 );
	Earthquake( 0.25, 1.0, self.origin, 512, self );
	playsoundatposition ("evt_turret_shake", (0,0,0));
	
	level waittill( "drone_wave_2" );
	
	exploder( 223 );
	Earthquake( 0.25, 1.0, self.origin, 512, self );
	playsoundatposition ("evt_turret_shake", (0,0,0));
	wait( 3 );
	exploder( 224 );
	Earthquake( 0.25, 1.0, self.origin, 512, self );
	playsoundatposition ("evt_turret_shake", (0,0,0));
	
	level waittill( "drone_wave_3" );
	
	exploder( 224 );
	Earthquake( 0.25, 1.0, self.origin, 512, self );
	playsoundatposition ("evt_turret_shake", (0,0,0));
}

#define AMBIENT_DRONE_COUNT 40

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

death_by_drone()
{
	level.player EnableHealthShield( false );
	
	level thread death_by_drone_loop();
	
	//scene_wait( "sam_cougar_mount" );
	flag_wait( "sam_cougar_mount_started" );
	
	a_drones = get_vehicle_array( "ambient_drone", "targetname" );
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
	veh_drone = random( get_vehicle_array( "ambient_drone", "targetname" ) );
	return veh_drone;
}

/////////////////////////////////////////////////////////////////////////////////////////////
// SAM EVENT
/////////////////////////////////////////////////////////////////////////////////////////////

sam_vo()
{
	if ( flag( "harper_dead" ) )
	{
		level.player say_dialog( "samu_here_they_come_sect_0" );	//Here they come, Section!
		level.player say_dialog( "sect_tracking_multiple_gr_0" );
	}
	else
	{
		level.player say_dialog( "tracking_multiple_001" );
		level.player say_dialog( "here_they_come_002" );
	}
	
	if ( !IsDefined( level.player.missileTurretTargetList ) || level.player.missileTurretTargetList.size == 0 )
	{
		level.player waittill( "lock_on_missile_turret_start" );
	}
	
	level thread sam_direction_vo_left();
	level thread sam_direction_vo_right();
	level thread good_shot_vo();
	level thread sam_nag_vo( "start_sam_end_vo" );
	
	if ( !flag( "harper_dead" ) )
	{
		level.player say_dialog( "dont_let_them_get_007" );
//		level.player say_dialog( "dead_ahead_h_engag_003" );
	}
	else
	{
		level.player say_dialog( "samu_you_have_to_take_dow_0" );
	}
	
	flag_wait( "start_sam_end_vo" );
	
	kill_all_pending_dialog();
	level.player waittill_dialog_finished();
	
	level notify( "stop_other_sam_vo" );
	wait 1;
	
	level thread sam_nag_vo( "sam_success" );
	
	if ( flag( "harper_dead" ) )
	{
		level.player say_dialog( "samu_they_re_all_over_us_0" );
	}
	else 
	{
		level.harper say_dialog( "harp_section_beat_they_0" );
		level.player say_dialog( "thats_your_window_001" );
	}
	
	flag_wait( "sam_success" );
	
	kill_all_pending_dialog();
	
	if ( flag( "harper_dead" ) )
	{
		level.player say_dialog( "thats_your_window_001" );		
	}
	else
	{
		level.player say_dialog( "go_now_001" );
		level.player say_dialog( "get_the_hell_out_o_002" );
	}
}

sam_direction_vo_left()
{
	level endon( "stop_other_sam_vo" );
	
	a_dialog = [];
	
	if ( flag( "harper_dead" ) )
	{
		ARRAY_ADD( a_dialog, "sect_radar_contact_left_0" );
		
	}
	else
	{
		ARRAY_ADD( a_dialog, "harp_left_side_left_side_0" );
		ARRAY_ADD( a_dialog, "come_around_90_deg_009" );
	}
	
	a_dialog = array_randomize( a_dialog );
	
	foreach ( str_line in a_dialog )
	{
		level waittill( "sam_drones_left" );
		level.player say_dialog( str_line );
	}
}

sam_direction_vo_right()
{
	level endon( "stop_other_sam_vo" );
	
	a_dialog = [];
	
	if ( flag( "harper_dead" ) )
	{
		ARRAY_ADD( a_dialog, "sect_radar_contact_right_0" );
	}
	else
	{
		ARRAY_ADD( a_dialog, "harp_right_section_righ_0" );
		ARRAY_ADD( a_dialog, "watch_your_flank_008" );
	}
	
	a_dialog = array_randomize( a_dialog );
	
	foreach ( str_line in a_dialog )
	{
		level waittill( "sam_drones_right" );
		level.player say_dialog( str_line );
	}
}

good_shot_vo()
{
	level endon( "stop_other_sam_vo" );
	
	a_dialog = [];
	
	if ( flag( "harper_dead" ) )
	{
		ARRAY_ADD( a_dialog, "sect_that_s_a_hit_0" );
		ARRAY_ADD( a_dialog, "sect_get_down_0" );
	}
	else
	{
		ARRAY_ADD( a_dialog, "good_shot_006" );
		ARRAY_ADD( a_dialog, "harp_hell_yeah_0" );
		ARRAY_ADD( a_dialog, "harp_nice_fuckin_shootin_0" );
	}
	
	foreach ( str_line in a_dialog )
	{
		level waittill( "good_shot" );
		level.player waittill_dialog_finished();	// from another thread
		level.player say_dialog( str_line );
	}	
}

sam_nag_vo( str_ender )
{
	level endon( str_ender );
	
	if ( !flag( "harper_dead" ) )	// alter this to just have the if check wrap these lines once we have alts
	{
		a_nag_general = array( "take_‘em_out_befor_010", "keep_them_off_us_012" );
		a_nag_fire = array( "fire_004", "hit_‘em_005", "dead_ahead_h_engag_003" );
		a_nag_offscreen = array( "come_around_90_deg_009", "watch_your_flank_008" );
		
		while ( true )
		{		
			a_drones = GetEntArray( "sam_drone", "targetname" );
			
			if ( level.player.missileTurretTargetList.size )
			{
				a_nag_fire = array_randomize( a_nag_fire );
				level.player say_dialog( a_nag_fire[0] );
			}
			else if ( a_drones[0] IsVehicle() && level.player is_player_looking_at( a_drones[0].origin, .7, false ) )
			{
				a_nag_offscreen = array_randomize( a_nag_offscreen );
				level.player say_dialog( a_nag_offscreen[0] );
			}
			else
			{
				a_nag_general = array_randomize( a_nag_general );
				level.player say_dialog( a_nag_general[0] );
			}
			
			wait RandomFloatRange( 5.0, 8.0 );
		}
	}
}

#define NUM_DRONE_WAVES 3

drone_sam_attack()
{
	level endon( "sam_complete" );
	level endon( "sam_success" );
	
	const n_count = 6;
	
	if ( level.skipto_point != "sam" )
	{
		wait 8.5;
	}
	
	angle_offsets = [];
	
	// RandomIntRange(0, 2) == 0 Left, RandomIntRange(0, 2) == 1 Right
	// RandomIntRange(60, 90) is in the front 180 degrees, but makes sure they spawn right out of the players view
	
	n_first_right_or_left = RandomIntRange(0, 2);
	
	angle_offset[0] = -90;
	
	angle_offset[1] = 180; //RandomIntRange(90, 100) + ( ( n_first_right_or_left - 1 ) * -170 );
	
	angle_offset[2] = -120; //RandomIntRange(90, 100) + ( RandomIntRange(0, 2) * 170 );
	
	level.vehicleJoltTime = GetDvarFloat( "g_vehicleJoltTime" );
	level.vehicleJoltWaves = GetDvarFloat( "g_vehicleJoltWaves" );
	level.vehicleJoltIntensity = GetDvarFloat( "g_vehicleJoltIntensity" );

	SetSavedDvar( "g_vehicleJoltTime", 2 );
	SetSavedDvar( "g_vehicleJoltWaves", 1 );
	SetSavedDvar( "g_vehicleJoltIntensity", 8 );
	
	for ( i = 1; i <= NUM_DRONE_WAVES; i++ )
	{
		level.n_drone_wave = i;
		a_drones = spawn_sam_drone_group( "sam_drone", n_count, angle_offset[i - 1] );
		
		if ( angle_offset[ i - 1 ] <= 180 )
		{
			level notify( "sam_drones_left" );
		}
		else
		{
			level notify( "sam_drones_right" );
		}
		
		level notify( "drones_spawned" );
		
		/#
			random( a_drones ) thread debug_speed();
		#/
		
		array_wait( a_drones, "death" );
		
		if ( level.n_drone_wave == NUM_DRONE_WAVES - 1 )
		{
			flag_set( "start_sam_end_vo" );
		}
		
		PlayFx( level._effect[ "sam_drone_explode_shockwave" ], level.player.origin, AnglesToForward( FLAT_ANGLE( level.sam_cougar GetTagAngles( "tag_gunner_barrel2" ) ) ), ( 0, 0, 1 ) );
		
		level notify( "good_shot" );
		
		level thread delete_sam_drone_corpses( a_drones );
		
		//wait 1;
//		if ( level.n_drone_wave == NUM_DRONE_WAVES )
//		{
//			wait 0.05;
//		}
	}
	

	
	SetSavedDvar( "g_vehicleJoltTime", level.vehicleJoltTime );
	SetSavedDvar( "g_vehicleJoltWaves", level.vehicleJoltWaves );
	SetSavedDvar( "g_vehicleJoltIntensity", level.vehicleJoltIntensity );
}

delete_sam_drone_corpses( a_drones )
{
	flag_wait( "sam_complete" );
	
	foreach ( vh_drone in a_drones )
	{
		if ( IsDefined( vh_drone.deathmodel_pieces ) )
		{
			array_delete( vh_drone.deathmodel_pieces );
		}

		if ( IsDefined( vh_drone ) )
			vh_drone Delete();
	}	
}

get_to_sam_straffing_runs()
{
	set_straffing_drones( "sam_drone", "sam_run_start_org", 750, "delete_before_sam_drones", .4, 1.8 );
}

/#
debug_speed()
{
	self endon( "death" );
	
	while ( true )
	{
		wait .05;
		debug_number( self GetSpeedMPH() );
	}
}

debug_number( n_speed )
{
	if ( !IsDefined( level.speed_debug ) )
	{
		level.speed_debug = NewHudElem();
		level.speed_debug.alignX = "left";
		level.speed_debug.alignY = "bottom";
		level.speed_debug.horzAlign = "left";
		level.speed_debug.vertAlign = "bottom";
		level.speed_debug.x = 0;
		level.speed_debug.y = 0;
		level.speed_debug.fontScale = 1.0;
		level.speed_debug.color = (0.8, 1.0, 0.8);
		level.speed_debug.font = "objective";
		level.speed_debug.glowColor = (0.3, 0.6, 0.3);
		level.speed_debug.glowAlpha = 1;
		level.speed_debug.foreground = 1;
		level.speed_debug.hidewheninmenu = true;
	}
	
	level.speed_debug SetValue( n_speed );
}
#/

lerp_vehicle_speed( n_goal_speed, n_time )
{
	self endon( "death" );
	
	n_current_speed = self GetSpeedMPH();
	s_timer = new_timer();
	
	do
	{
		wait .05;
		n_current_time = s_timer get_time_in_seconds();
		n_speed = LerpFloat( n_current_speed, n_goal_speed, n_current_time / n_time );
		self SetSpeed( n_speed, 1000 );
	}
	while ( n_speed > n_goal_speed );
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

#define YAW_NORTH 80

sam_wave_vo( v_player_angle, n_spawn_yaw )
{
	if ( abs( n_spawn_yaw - YAW_NORTH ) < 30 )
	{
		level.player say_dialog( "more_drones_moving_013" );
	}
	else
	{
		n_angle_diff = abs( n_spawn_yaw - v_player_angle );
		if ( ( n_angle_diff > 70 && n_angle_diff < 110 ) || ( n_angle_diff > 250 && n_angle_diff < 290 ) )
		{
			level.player say_dialog( "come_around_90_deg_009" );
		}
		else if ( n_angle_diff >= 110 && n_angle_diff <= 290 )
		{
			level.player say_dialog( "watch_your_flank_008" );
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
	a_drones = get_vehicle_array( "ambient_drone", "targetname" );
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

sam_fired_listener()
{
	level.n_sam_missiles_fired = 0;
	
	while ( !flag( "sam_complete" ) )
	{
		self waittill( "missileTurret_fired" );
		level.n_sam_missiles_fired++;
		
		//SOUND: Shawn J - rocket reload
		level.player PlaySound("wpn_sam_turret_reload");
	}
}
