#include maps\_utility;
#include common_scripts\utility;
#include maps\_scene;
#include maps\_dialog;
#include maps\_anim;
#include maps\la_utility;

#insert raw\maps\_utility.gsh;

main()
{
	harper_wakeup();
	anderson_f35_exit();
	pilot_drag_setup();
	pilot_drag_van_setup();
	pilot_drag();
	pilot_drag_van_idle();
	f35_get_in();
	f35_startup();
	ai_anims();
	harper_fires_from_van();
	f35_mode_switch();
	f35_eject();
	f35_eject_manual();
	midair_collision();
	f35_outro();
//	claw_bigrig_exits();
	
	precache_assets();
	
	maps\voice\voice_la_2::init_voice();
	init_vo();
	
	init_drone_anims();
}

//claw_bigrig_exits()
//{
//	level.scr_anim[ "claw" ][ "bigrig_exit_1" ] = %bigdog::ai_crew_semi_truck_claw_1_exit;
//	level.scr_anim[ "claw" ][ "bigrig_exit_2" ] = %bigdog::ai_crew_semi_truck_claw_2_exit;
//	level.scr_anim[ "bigrig" ][ "bigrig_trailer_claw_exit" ] = %vehicles::v_crew_semi_truck_ramp_open;
//}

#using_animtree( "fakeShooters" );
init_drone_anims()
{
	level.drones.anims[ "throw_molotov" ] = %stand_grenade_throw;
}

harper_wakeup()
{
	add_scene( "harper_wakes_up", "anim_align_stadium_intersection" );
	add_actor_anim( "harper", %generic_human::ch_la_08_01_standup_harper );
}

anderson_f35_exit()
{
	add_scene( "anderson_f35_exit", "anim_align_stadium_intersection" );
	add_actor_anim( "f35_pilot", %generic_human::ch_la_08_01_save_anderson_anderson_fall, true, false, false, true );
	add_vehicle_anim( "f35", %vehicles::v_la_08_01_save_anderson_f35 );
}

pilot_drag_setup()
{
	add_scene( "pilot_drag_setup", "anim_align_stadium_intersection", false, false, true );
	add_actor_anim( "f35_pilot", %generic_human::ch_la_08_01_save_anderson_anderson_loop, true, false, false, true );
}

pilot_drag_van_setup()
{
	str_scene_name = "pilot_drag_van_setup";
	str_align_targetname = "anim_align_stadium_intersection";
	b_do_reach = false;
	b_do_generic = false;
	b_do_loop = true;
	b_do_not_align = false;
	add_scene( str_scene_name, str_align_targetname, b_do_reach, b_do_generic, b_do_loop, b_do_not_align );
	add_vehicle_anim( "intro_van", %vehicles::v_la_08_01_save_anderson_ambulance );
}

pilot_drag()
{
	add_scene( "pilot_drag_harper", "anim_align_stadium_intersection", true );
	add_actor_anim( "harper", %generic_human::ch_la_08_01_save_anderson_harper );
	
	add_scene( "pilot_drag_harper_idle", "anim_align_stadium_intersection", false, false, true );
	add_actor_anim( "harper", %generic_human::ch_la_08_01_save_anderson_harper_loop );
	
	add_scene( "pilot_drag", "anim_align_stadium_intersection");
	add_actor_anim( "f35_pilot", %generic_human::ch_la_08_01_save_anderson_anderson, true, false, true, true );	
	add_actor_anim( "intro_medic_1", %generic_human::ch_la_08_01_save_anderson_driver1, true, false, true, true );
	add_actor_anim( "intro_medic_2", %generic_human::ch_la_08_01_save_anderson_driver2, true, false, true, true );
	add_vehicle_anim( "intro_van", %vehicles::v_la_08_01_save_anderson_ambulance );
}

pilot_drag_van_idle()
{
	str_scene_name = "pilot_drag_van_idle";
	str_align_targetname = "anim_align_stadium_intersection";
	b_do_reach = false;
	b_do_generic = false;
	b_do_loop = true;
	b_do_not_align = false;
//	add_scene( str_scene_name, str_align_targetname, b_do_reach, b_do_generic, b_do_loop, b_do_not_align );
	
	b_hide_weapon = false;
	b_giveback_weapon = true;
	b_do_delete = false;  
	b_no_death = true;  
	str_tag = undefined;
//	add_actor_anim( "f35_pilot", %generic_human::ch_la_08_01_van_loop_anderson, b_hide_weapon, b_giveback_weapon, b_do_delete, b_no_death, str_tag );

	b_hide_weapon = false;
	b_giveback_weapon = true;
	b_do_delete = false;  
	b_no_death = true;  
	str_tag = undefined;
//	add_actor_anim( "harper", %generic_human::ch_la_08_01_van_loop_harper, b_hide_weapon, b_giveback_weapon, b_do_delete, b_no_death, str_tag );
		
}

f35_get_in()
{
	add_scene( "F35_get_in", "F35" );
	
	// player
	b_do_delete = false;
	n_player_number = 0;
	str_tag = "tag_driver";
	b_do_delta = false;
	n_view_fraction = 100;
	n_right_arc = 30;
	n_left_arc = 30;
	n_top_arc = 30;
	n_bottom_arc = 30;	
	b_use_tag_angles = true;
	b_center_camera = true;
	add_player_anim( "player_body", %player::ch_la_08_02_f35enter_player, 
	                b_do_delete, n_player_number, str_tag, b_do_delta, n_view_fraction,
	               	n_right_arc, n_left_arc, n_top_arc, n_bottom_arc, b_use_tag_angles, b_center_camera );	
	
	add_notetrack_custom_function( "player_body", "helmet_on", ::player_puts_on_helmet );
	add_notetrack_custom_function( "player_body", "dof_players_hand", maps\createart\la_2_art::enter_jet_players_hand );
	add_notetrack_custom_function( "player_body", "dof_cockpit", maps\createart\la_2_art::enter_jet_cockpit );
	add_notetrack_custom_function( "player_body", "dof_hud", maps\createart\la_2_art::enter_jet_hud );	
	
	// helmet
	str_model = "p6_anim_f35_helmet";
	b_do_delete = true;
	b_is_simple_prop = false;
	a_parts = undefined;
	str_tag = "tag_origin";
	add_prop_anim( "F35_helmet", %animated_props::o_la_08_02_f35enter_helmet, str_model, b_do_delete, 
	              b_is_simple_prop, a_parts, str_tag );	
	
	add_scene( "F35_get_in_vehicle", "anim_intro_jet_struct" );
	// F35
	add_vehicle_anim( "F35", %vehicles::v_la_08_02_f35enter_f35, undefined, undefined, undefined, true );
}

player_puts_on_helmet( e_player_body )
{
	clientnotify( "player_put_on_helmet" );
	level.player VisionSetNaked( "helmet_f35_low", 0.5 );
	level thread f35_hide_outer_model_parts( true, 0.25 );
	screen_fade_out( 0.25 );
	LUINotifyEvent( &"hud_f35" );
	stop_exploder( 102 );
	exploder( 103 );
	screen_fade_in( 0.25 );
}

f35_hide_outer_model_parts( hide, delay )
{
	if( IsDefined(delay) && (delay > 0) )
	{
		wait( delay );
	}
	
	//IPrintLnBold( "Hiding Mf35 model parts" );

	str_parts = [];
	str_parts[ str_parts.size ] = "tag_exterior";
	str_parts[ str_parts.size ] = "tag_engine_base_left";
	str_parts[ str_parts.size ] = "tag_engine_base_right";
	str_parts[ str_parts.size ] = "tag_engine_outer_cover_right";
	str_parts[ str_parts.size ] = "tag_engine_inner_cover_right";
	str_parts[ str_parts.size ] = "tag_engine_outer_cover_left";
	str_parts[ str_parts.size ] = "tag_engine_inner_cover_left";
	str_parts[ str_parts.size ] = "tag_side_vent_right";
	str_parts[ str_parts.size ] = "tag_side_vent_left";
	str_parts[ str_parts.size ] = "tag_landing_gear_doors";
	str_parts[ str_parts.size ] = "tag_landing_gear_down";
	str_parts[ str_parts.size ] = "tag_ladder";

	for( i=0; i<str_parts.size; i++ )
	{
		if( hide )
		{
			level.f35 hidepart( str_parts[i], level.f35.model );	
		}
		else
		{
			level.f35 showpart( str_parts[i], level.f35.model );	
		}
	}
//	
//	if ( hide )
//	{
//		// attach a low-rez body to create a proper shadow
//		level.f35_exterior = spawn_model( "veh_t6_air_fa38_low", level.f35.origin, level.f35.angles );
//		level.f35_exterior HidePart( "tag_canopy" );
//		level.f35_exterior HidePart( "tag_cockpit" );
//		level.f35_exterior HidePart( "tag_seat" );
//		level.f35_exterior LinkTo( level.f35 );
//	}
//	else
//	{
//		level.f35_exterior Delete();
//	}
	
}

f35_startup()
{
	// player rig is aligned to tag_driver of F35 during startup
	b_do_delete = true;
	n_player_number = 0;
	str_tag = "tag_driver";
	b_do_delta = false;
	n_view_fraction = 100;
	n_right_arc = 30;
	n_left_arc = 30;
	n_top_arc = 30;
	n_bottom_arc = 30;
	b_use_tag_angles = true;
	b_auto_center = true;
	
	add_scene( "F35_startup", "F35" );
	add_player_anim( "player_body", %player::ch_la_08_02_f35enter_startup_player, 
	                b_do_delete, n_player_number, str_tag, b_do_delta, n_view_fraction,
	               	n_right_arc, n_left_arc, n_top_arc, n_bottom_arc, b_use_tag_angles, b_auto_center );
	add_notetrack_custom_function( "player_body", "touch_hud", maps\la_2_player_f35::f35_startup_console );
	
	// F35 animates in reference to tag_align
	add_scene( "F35_startup_vehicle", "anim_intro_jet_struct" );
	add_vehicle_anim( "F35", %vehicles::v_la_08_02_f35enter_startup_f35, undefined, undefined, undefined, true );
}

harper_fires_from_van()
{
	level.scr_anim[ "harper" ][ "harper_fires_out_window" ][0] = %generic_human::ch_la_09_01_harpershooting_harper;
}

#using_animtree( "player" );
f35_mode_switch()
{
	b_do_delete = true;
	n_player_number = 0;
	str_tag = "tag_driver";
	b_do_delta = false;
	n_view_fraction = 100;
	n_right_arc = 30;
	n_left_arc = 30;
	n_top_arc = 30;
	n_bottom_arc = 30;
	b_use_tag_angles = true;
	b_auto_center = true;
	
	add_scene( "F35_mode_switch", "F35" );
	add_player_anim( "player_body", %player::ch_la_09_05_flightmode_switch_player, 
	                b_do_delete, n_player_number, str_tag, b_do_delta, n_view_fraction,
	               	n_right_arc, n_left_arc, n_top_arc, n_bottom_arc, b_use_tag_angles, b_auto_center );
	
	// manual
	level.scr_model["player_body"] = level.player_interactive_model;
	level.scr_animtree["player_body"] = #animtree;		
	
	level.scr_anim[ "player_body" ][ "F35_mode_switch" ] = %player::ch_la_09_05_flightmode_switch_player;	
	addNotetrack_customFunction( "player_body", "touch_hud", ::notify_mode_switch, "F35_mode_switch" );
}

notify_mode_switch( e_guy )
{
	wait 0.5;
	level.f35 notify( "f35_switch_modes_now" );
}


f35_eject()
{
	add_scene( "f35_eject_drone_intro" );	// align point set in la_2_anim.gsc
	add_vehicle_anim( "eject_sequence_drone", %vehicles::v_la_10_01_f35eject_drone_intro );
	
	//add_scene( "f35_eject_player", "F35", false, false, false );
	
	
	add_scene( "F35_eject" );		// align point set in la_2_anim.gsc
//	add_player_anim( "player_body", %player::ch_la_10_01_f35eject_start_player );
//	add_vehicle_anim( "F35", %vehicles::v_la_10_01_f35eject_start_fa38 );
	add_vehicle_anim( "eject_sequence_drone", %vehicles::v_la_10_01_f35eject_start_drone );
}

// attempting to get this animation working without the scene system...
#using_animtree( "player" );
f35_eject_manual()
{
	level.scr_model["player_body"] = level.player_interactive_model;
	level.scr_animtree["player_body"] = #animtree;		
	
	level.scr_anim[ "player_body" ][ "f35_eject_start" ] = %player::ch_la_10_01_f35eject_start_player;
}

midair_collision()
{
	add_scene( "midair_collision", "anim_end_struct" );
	
	b_do_delete = false;
	n_player_number = 0;
	str_tag = undefined;
	b_do_delta = false;
	n_view_fraction = 0;
	n_right_arc = 30;
	n_left_arc = 30;
	n_top_arc = 30;
	n_bottom_arc = 30;	
	b_use_tag_angles = true;
	add_player_anim( "player_body", %player::ch_la_10_01_f35eject_player, 
	                b_do_delete, n_player_number, str_tag, b_do_delta, n_view_fraction,
	               	n_right_arc, n_left_arc, n_top_arc, n_bottom_arc, b_use_tag_angles );	
	add_notetrack_custom_function( "player_body", "eject", ::f35_eject_notetrack_eject );
	add_notetrack_custom_function( "player_body", "eject", ::f35_eject_notify_start );//kevin audio
	add_notetrack_custom_function( "player_body", "explosion", ::f35_eject_notetrack_explosion );	
	add_notetrack_custom_function( "player_body", "chute", ::f35_eject_notetrack_chute_opens );
	add_notetrack_custom_function( "player_body", "hit_building", ::f35_eject_notetrack_hit_building );
	add_notetrack_custom_function( "player_body", "hit_ground", ::f35_eject_notetrack_hit_ground );
	add_notetrack_custom_function( "player_body", "start_jets_animation", ::f35_eject_notetrack_start_jets );
	add_notetrack_custom_function( "player_body", "body_impact", ::f35_eject_notetrack_body_impact );
	
	add_vehicle_anim( "eject_sequence_drone", %vehicles::v_la_10_01_f35eject_drone, true, undefined, undefined, undefined, undefined, undefined, undefined, false );
	add_vehicle_anim( "F35", %vehicles::v_la_10_01_f35eject_f35, true, undefined, undefined, undefined, undefined, undefined, undefined, false );	
	add_notetrack_custom_function( "F35", "collide", ::midair_collision_notetrack );
	
	add_notetrack_custom_function( "player_body", "dof_eject", maps\createart\la_2_art::crash_eject );
	add_notetrack_custom_function( "player_body", "dof_chute", maps\createart\la_2_art::crash_chute );
	add_notetrack_custom_function( "player_body", "dof_city", maps\createart\la_2_art::crash_city );
	add_notetrack_custom_function( "player_body", "dof_hit_building", maps\createart\la_2_art::crash_hit_building );
	add_notetrack_custom_function( "player_body", "dof_land", maps\createart\la_2_art::crash_land );
	add_notetrack_custom_function( "player_body", "dof_chute", maps\la_2_ground::outro_pip );
	
	str_model = undefined;
	b_do_delete = true;
	b_is_simple_prop = false;
	a_parts = undefined;
	str_tag = undefined;
	add_prop_anim( "f35_eject_parachute", %animated_props::o_la_10_01_f35eject_parachute, str_model, b_do_delete, 
	              b_is_simple_prop, a_parts, str_tag );	
	
	add_scene( "midair_collision_amb_jets", "anim_end_struct" );
	add_vehicle_anim( "f35_2", %vehicles::v_la_10_01_f35_2, true, undefined, undefined, undefined, "plane_f35_player_vtol" );
	add_vehicle_anim( "f35_3", %vehicles::v_la_10_01_f35_3, true, undefined, undefined, undefined, "plane_f35_player_vtol" );
	add_vehicle_anim( "f35_4", %vehicles::v_la_10_01_f35_4, true, undefined, undefined, undefined, "plane_f35_player_vtol" );
}

f35_outro()
{
	add_scene( "outro_hero", "anim_end_struct" );
//	add_actor_anim( "hillary", %generic_human::ch_la_10_02_promnight_hilary, true, false, false, true );
	add_actor_anim( "harper", %generic_human::ch_la_10_02_promnight_harper, true, false, false, true );
//	add_actor_anim( "ss1", %generic_human::ch_la_10_02_promnight_ss01, false, false, false, true );
//	add_actor_anim( "ss2", %generic_human::ch_la_10_02_promnight_ss02, false, false );
	add_player_anim( "player_body", %player::ch_la_10_02_promnight_player, false, 0, undefined, false, 0, 30, 30, 30, 30, true );
	add_notetrack_custom_function( "player_body", "start_fadeout", ::level_end );
	add_notetrack_custom_function( "player_body", "dof_convoy", maps\createart\la_2_art::outro_convoy );
	add_notetrack_custom_function( "player_body", "dof_president", maps\createart\la_2_art::outro_harper );
	add_notetrack_custom_function( "player_body", "dof_president", maps\createart\la_2_art::outro_president );
	add_notetrack_custom_function( "player_body", "dof_door", maps\createart\la_2_art::outro_door );
	add_vehicle_anim( "convoy_potus_cougar", %vehicles::v_la_10_02_promnight_cougar );
	add_prop_anim( "convoy_van_prop", %animated_props::v_la_10_02_promnight_van, "veh_iw_civ_ambulance" );
	
	// optionally dead vehicles can't be in same scene, so we have separate scenes for each one.
	add_scene( "outro_g20_1", "anim_end_struct" );
	add_vehicle_anim( "convoy_g20_1", %vehicles::v_la_10_02_promnight_cougar02 );
	
	add_scene( "outro_g20_2", "anim_end_struct" );
	add_vehicle_anim( "convoy_g20_2", %vehicles::v_la_10_02_promnight_cougar03 );
	
	add_scene( "outro_hero_noharper", "anim_end_struct" );
//add_actor_anim( "hillary", %generic_human::ch_la_10_02_promnight_hilary, true, false, false, true );
	add_actor_anim( "sam", %generic_human::ch_la_10_02_promnightsam_sam, true, false, false, true );
//add_actor_anim( "ss1", %generic_human::ch_la_10_02_promnight_ss01, false, false, false, true );
//add_actor_anim( "ss2", %generic_human::ch_la_10_02_promnight_ss02, false, false );
	add_player_anim( "player_body", %player::ch_la_10_02_promnightsam_player, false, 0, undefined, false, 0, 30, 30, 30, 30, true );
	add_notetrack_custom_function( "player_body", "start_fadeout", ::level_end );
	add_notetrack_custom_function( "player_body", "dof_convoy", maps\createart\la_2_art::outro_convoy );
	add_notetrack_custom_function( "player_body", "dof_president", maps\createart\la_2_art::outro_harper );
	add_notetrack_custom_function( "player_body", "dof_president", maps\createart\la_2_art::outro_president );
	add_notetrack_custom_function( "player_body", "dof_door", maps\createart\la_2_art::outro_door );
	add_vehicle_anim( "convoy_potus_cougar", %vehicles::v_la_10_02_promnightsam_cougar );
//	add_prop_anim( "convoy_van_prop", %animated_props::v_la_10_02_promnight_van, "veh_iw_civ_ambulance" );
	
	// optionally dead vehicles can't be in same scene, so we have separate scenes for each one.
	add_scene( "outro_g20_1_noharper", "anim_end_struct" );
	add_vehicle_anim( "convoy_g20_1", %vehicles::v_la_10_02_promnightsam_cougar02 );
	
	add_scene( "outro_g20_2_noharper", "anim_end_struct" );
	add_vehicle_anim( "convoy_g20_2", %vehicles::v_la_10_02_promnightsam_cougar03 );	
}

#using_animtree ("generic_human");
ai_anims()
{
	// intro guys
	level.scr_anim[ "intro_guy" ][ "intro_death_1" ] = %ch_la_08_01_longdeath_ter1; 
	level.scr_anim[ "intro_guy" ][ "intro_death_2" ] = %ch_la_08_01_longdeath_ter2;
	level.scr_anim[ "intro_guy" ][ "intro_death_3" ] = %ch_la_08_01_longdeath_ter3;
	level.scr_anim[ "intro_guy" ][ "intro_death_4" ] = %ch_la_08_01_longdeath_ter4;
	level.scr_anim[ "intro_guy" ][ "intro_death_5" ] = %ch_la_08_01_longdeath_ter5;
	level.scr_anim[ "intro_guy" ][ "intro_death_6" ] = %ch_la_08_01_longdeath_ter6;
}

#using_animtree( "player" );
player_anims()
{
	// f35_get_in
	level.scr_model[ "player_body" ] = level.player_interactive_model;
	level.scr_animtree[ "player_body" ] = #animtree;
	level.scr_anim[ "player_body" ][ "f35_get_in" ] = %player::ch_la_08_02_f35enter_player;
}

#using_animtree( "vehicles" );
vehicle_anims()
{
	// f35_get_in
	level.scr_animtree[ "f35" ] = #animtree;
	level.scr_anim[ "f35" ][ "f35_get_in" ] = %vehicles::v_la_08_02_f35enter_f35;
}

#using_animtree( "animated_props" );
object_anims()
{
	// f35_get_in - helmet
	level.scr_animtree[ "f35_helmet" ] = #animtree;
	level.scr_model[ "f35_helmet" ] = "tag_origin_animate";  // origin_animate_jnt
	level.scr_anim[ "f35_helmet" ][ "f35_get_in" ] = %animated_props::o_la_08_02_f35enter_helmet;		
}

//=============================================================================
// NOTETRACK SECTION
//=============================================================================

level_end( guy )
{
	nextmission();
}

midair_collision_notetrack( guy )
{
//	level.f35 notify( "midair_collision" );
//	//PlayFXOnTag( level._effect[ "midair_collision_explosion" ], level.f35, "body_animate_jnt" );
//	PlayFX( level._effect[ "midair_collision_explosion" ], level.f35.origin, AnglesToForward( level.f35.angles ) );
}

f35_eject_notify_start( e_player_body )//kevin audio: getting it's notify from anim
{
	ClientNotify( "stop_f35_snap" );
}

f35_eject_notetrack_eject( e_player_body )
{
	level thread f35_hide_outer_model_parts( false, undefined );
	
	maps\la_2_player_f35::F35_remove_visor();
	
	vh_drone = get_ent( "eject_sequence_drone", "targetname", true );
	vh_drone SetModel( "veh_t6_drone_avenger" );
	flag_set( "ejection_start" );
	
	level thread f35_start_flybys();

	n_earthquake_magnitude = 0.3;
	n_earthquake_duration = 0.6;
	str_rumble = "damage_heavy";
	n_rumble_count = 3;
	n_loop_time = 0.2;
	
	Earthquake( n_earthquake_magnitude, n_earthquake_duration, level.player.origin, 512, level.player );
	level.player thread rumble_loop( n_rumble_count, n_loop_time, str_rumble );	
}

f35_start_flybys()
{
	wait( 0.05 );
	
	level maps\la_2_drones_ambient::cleanup_ambient_drones( 75, 1, 1.1 );
	
	vehicles = GetVehicleArray();
	for ( i = 0; i < vehicles.size; i++ )
	{
		if ( IS_PLANE( vehicles[i] ) && ( vehicles[i].vehicleType == "drone_pegasus_low_la2" || vehicles[i].vehicleType == "plane_f35_low" || vehicles[i].vehicleType == "civ_police_la2" || vehicles[i].vehicleType == "plane_f35_fast_la2" ) )
		{
			vehicles[i] Delete();
		}
	}
	
	wait( 0.05 );
	
	trigger_use( "trig_eject_parachute_flyby_1" );	
	trigger_use( "trig_eject_parachute_flyby_2" );
	trigger_use( "trig_eject_parachute_flyby_3" );	
	trigger_use( "trig_eject_parachute_flyby_4" );

	level thread f35_end_flybys();
}

f35_end_flybys()
{
	wait( 5 );

	trigger_use( "trig_kill_parachute_flyby_3" );	
	trigger_use( "trig_kill_parachute_flyby_4" );	
	
//	wait( 5 );
//	
//	trigger_use( "trig_kill_parachute_flyby_1" );
}

f35_eject_notetrack_explosion( e_player_body )
{
	n_earthquake_magnitude = 0.3;
	n_earthquake_duration = 1;
	str_rumble = "damage_heavy";
	n_rumble_count = 4;
	n_loop_time = 0.25;
	vh_drone = get_ent( "eject_sequence_drone", "targetname", true );
	
	level.f35 notify( "midair_collision" );
	//PlayFXOnTag( level._effect[ "midair_collision_explosion" ], level.f35, "body_animate_jnt" );
	PlayFX( level._effect[ "midair_collision_explosion" ], level.f35.origin, AnglesToForward( level.f35.angles ) );	
	
	Earthquake( n_earthquake_magnitude, n_earthquake_duration, level.player.origin, 512, level.player );
	level.player thread rumble_loop( n_rumble_count, n_loop_time, str_rumble );
	
//	level.f35 do_vehicle_damage( level.f35.health_regen.health, vh_drone );
//	vh_drone do_vehicle_damage( vh_drone.health, level.f35 );	
	wait .1;
	VEHICLE_DELETE( level.f35 );
	VEHICLE_DELETE( vh_drone );
}

f35_eject_notetrack_hit_ground( e_player_body )
{	
	str_rumble = "damage_heavy";
	n_rumble_count = 5;
	n_loop_time = 0.2;
	
	level.player thread rumble_loop( n_rumble_count, n_loop_time, str_rumble );	
	PlayFXOnTag( level._effect[ "eject_hit_ground" ], e_player_body, "J_SpineLower" );	
	
	wait 1;
	level thread maps\la_2_fly::spawn_convoy_f35_allies( "start_eject_landed_flyby", 4, 1, true, false );
}

f35_eject_notetrack_start_jets( e_player_body )
{
	level thread run_scene( "midair_collision_amb_jets" );
	
//	level thread maps\la_2_fly::spawn_convoy_strafing_wave( "start_eject_fall_flyby", 2, 3 );
//	level thread maps\la_2_fly::spawn_convoy_f35_allies( "start_eject_fall_flyby", 2, 1, true, false );
	
	wait 1;
//	a_planes = GetEntArray( "convoy_strafing_plane", "targetname" );
//	foreach( vh_plane in a_planes )
//	{
//		if ( IsDefined ( vh_plane ) && IsAlive( vh_plane )  )
//		{
//			vh_plane maps\la_2_ground::do_vehicle_damage( vh_plane.health, level.f35 );
//		}
//	}
}

f35_eject_notetrack_chute_opens( e_player_body )
{
	str_rumble = "damage_heavy";
	n_rumble_count = 3;
	n_loop_time = 0.2;
	
//	level thread maps\la_2_fly::spawn_convoy_strafing_wave( "start_eject_parachute_flyby", 2, 3 );
//	wait .1;
//	level thread maps\la_2_fly::spawn_convoy_f35_allies( "start_eject_parachute_flyby", 2, 1, true, false );	
	
//	exploder( 620 );
//	exploder( 630 );		
	
	level.player thread rumble_loop( n_rumble_count, n_loop_time, str_rumble );	
}

f35_eject_notetrack_hit_building( e_player_body )
{
	PlayFXOnTag( level._effect[ "eject_building_hit" ], e_player_body, "tag_origin" );
	
	str_rumble = "damage_heavy";
	n_rumble_count = 5;
	n_loop_time = 0.2;
	
	level.player thread rumble_loop( n_rumble_count, n_loop_time, str_rumble );		
}

f35_eject_notetrack_body_impact( e_player_body )
{
	//PlayFXOnTag( level._effect[ "eject_hit_ground" ], e_player_body, "J_SpineLower" );
}

//=============================================================================
// VO SECTION
//=============================================================================
init_vo()
{
	// -----global convoy dialog-----
	add_dialog( "convoy_death", "We lost a vehicle! What are you doing, Mason?!" );
	add_dialog( "protect_convoy_nag_1", "Mason, the convoy is under fire! Get to our position!" );
	add_dialog( "protect_convoy_nag_2", "Mason, where are you? Cover us!" );
	add_dialog( "convoy_damage_nag_1", "The convoy is taking fire!" );
	add_dialog( "convoy_damage_nag_2", "Mason, support! We're under fire!" );
	add_dialog( "convoy_damage_nag_3", "Convoy needs support!" );
	add_dialog( "convoy_damage_nag_4", "Protect the convoy!" );
	add_dialog( "convoy_damage_nag_5", "Defend the Cougars, Mason!" );
	add_dialog( "convoy_damage_nag_6", "Convoy is taking heavy fire! Support NOW!" );	
	
	// flight section
	add_dialog( "meet_convoy", "Alright Mason, fly out of the debris and meet up with the convoy" );
	add_dialog( "convoy_sitrep", "The Presidential convoy has been under fire. We need to get them to Prom Night." );

	// F35 dialog (general)
	add_dialog( "F35_dogfight_distance_warning", "Warning: leaving combat area." );
}

vo_rooftops()
{
	level endon( "convoy_at_dogfight" );
	
	vh_van = level.convoy.vh_van;
	e_player = level.player;
	
	/*
	if ( !is_greenlight_build() )
	{
		e_harper thread say_dialog( "nice_work_septic_045" );//Nice work. Septic.
	    e_player thread say_dialog( "hows_anderson_046", 2 );//How?s Anderson?
	   
		if ( flag( "F35_pilot_saved" ) )
		{
	    	e_harper thread say_dialog("shell_make_it_047", 4 );//She?ll make it... She?s one tough lady.
	    	e_player thread say_dialog("glad_to_hear_it_h_048", 7 );//Glad to hear it, Harper.  Keep her safe.
		}
		else
		{
	    	e_harper thread say_dialog("sorry_septic_s_049", 5 );//Sorry, Septic... She... Didn?t make it...
	    	e_player thread say_dialog("damn_050", 7 );//Damn.
		}	
	}
	*/
	
	level waittill( "enemy_trucks_crash_through_barrier" );
	
	/*
	add_vo_to_nag_group( "truck_nags", e_harper, "take_?em_out_011" ); //Take ?em out!
	add_vo_to_nag_group( "truck_nags", e_harper, "hit_?em_septic_012" )  // Hit 'em, Septic!
	
	level thread maps\_dialog::add_vo
	*/
	
	wait 4;
	
	e_player thread say_dialog( "shit_enemy_trucks_020" );//Shit! Enemy trucks crashing the Hope St blockade!
	e_player thread say_dialog( "keep_moving_go_021", 3.5 );//Keep moving! Go!
//	e_harper thread say_dialog ("those_fucking_gang_008", 5.5 );//Those fucking gangbangers are all over the streets!
    
	if ( !flag( "harper_dead" ) )
	{
		vh_van thread say_dialog( "bastards_are_every_009", 8 );//Bastards are everywhere!
	}
	else
	{
		vh_van thread say_dialog( "samu_you_gotta_keep_them_0", 8 );	//You gotta keep them off us!
	}
	
	flag_wait( "convoy_at_apartment_building" );
	
	wait 12;
	
	if ( !flag( "harper_dead" ) )
	{
		e_player thread say_dialog( "helicopter_above_t_009" );//Helicopter above the parking structure!
		e_player thread say_dialog( "fuck__those_big_r_011", 3.5 );  // Fuck! Those big rigs are blocking out path!
		e_player thread say_dialog( "get_off_8th_h_turn_007", 6.0 );//Get off 9th - turn north onto Flower!
		e_player thread say_dialog( "harp_dammit_section_it_0", 8.0 );//Dammit Section!  It?s ambush fucking alley down here! 
		e_player thread say_dialog( "were_taking_fire_058", 11.5 );//We?re taking fire from all sides!
	}
	else
	{
		e_player thread say_dialog( "harp_the_helicopter_sect_0" ); //The helicopter, Section!  Take him out!
		e_player thread say_dialog( "samu_enemy_big_rigs_end_0", 3.5 );  //Enemy big rigs - End of the street!
		e_player thread say_dialog( "get_off_8th_h_turn_007", 6.0 );//Get off 9th - turn north onto Flower!
		e_player thread say_dialog( "samu_we_re_taking_fire_fr_0", 9.5 );//We?re taking fire from all sides!    		
	}
}

vo_truck_group_1_dead()
{
	level endon( "enemy_trucks_crash_through_barrier" );
	
	flag_wait( "hotel_street_truck_group_1_spawned" );
	a_trucks = get_ent_array( "hotel_street_truck_group_1", "targetname" );
	
	array_wait( a_trucks, "death" );
	
	e_harper = level.convoy.vh_van;
	e_player = level.player;
	
//	e_player thread say_dialog( "harper__roads_cl_044" );//Harper!  Road's clear - Move up!
    e_harper thread say_dialog( "harp_nice_work_section_1", 2 );//Nice work. Section.
}

vo_after_parking_structure()
{
	e_harper = level.convoy.vh_van;
	e_player = level.player;
	e_hillary = level.convoy.vh_potus;
	
	kill_all_pending_dialog( e_harper );
	kill_all_pending_dialog( e_player );
	
    e_player thread say_dialog( "we_got_enemy_gunsh_012" );//We got enemy gunships!
    e_player thread say_dialog( "keep_moving_013", 2 );  // Keep moving!
   	e_player thread say_dialog("its_too_hot_h_tur_017", 5 ); //It?s too hot - Turn right on 5th!	
}

vo_ground_air_transition()
{
	e_player = level.player;
	e_hillary = level.convoy.vh_potus;
	e_harper = level.convoy.vh_van;
	
//	e_player thread say_dialog( "jones_h_everyone_o_009" );//Jones - Everyone okay?
//	delay_thread( 1.5, maps\la_2_ground::pip_start, "pip_hilary_3" );
	level thread maps\la_2_ground::pip_start( "la_pip_seq_4" );
	e_hillary say_dialog( "samu_section_we_re_trac_0", 1 );		// Section - We’re tracking another wave of Drones advancing on our position!
	level.player say_dialog( "sect_i_ll_handle_the_dron_0" );	// I’ll handle the drones.  Just get the President to Prom Night!

//	if ( flag( "F35_pilot_saved" ) )
//	{
//		level.player 	
//	}
	
	// delay_thread( 1.5, maps\la_2_ground::pip_start, "la_pip_seq_4" );
//    e_hillary thread say_dialog( "youre_doing_a_hel_010", 2 );//You?re doing a hell of a job, Agent Mason.
    //e_player thread say_dialog( "we_aint_out_the_w_011", 4 );//We ain?t out the woods yet...
 //   e_harper thread say_dialog( "you_gotta_keep_tho_025", 4 );  // You gotta keep those drones off our backs!
}

vo_dogfight()
{
	e_harper = level.convoy.vh_van;
	e_player = level.player;	
	vh_f35 = level.f35;
	
//	wait 1;
	
   	e_harper thread say_dialog( "bastards_tried_to_006", 1 );//Bastards tried to drop a fucking building on us!	
    e_player thread say_dialog( "shit__harper__go_063", 4 );//Shit!  Harper.  Got multiple drones incoming!  What?s your status?
    e_harper thread say_dialog( "the_convoy_vehicle_024", 7 ); //The convoy vehicles are still operational, but we need some time to clear the debris.
    //e_harper thread say_dialog( "just_worry_about_y_065", 10 );//Just worry about yourself right now!
    e_harper thread say_dialog( "harp_good_luck_section_0", 12 );//Good luck, Section! 
    
//    wait 2;
    
    flag_set( "dogfights_story_done" );
    
    flag_wait( "dogfight_done" );
    e_player thread add_dialog("harp_nice_work_section_1", 2 );//Nice work, Section.
}

vo_dogfight_f35()
{	
	flag_wait( "dogfights_story_done" );
	self thread say_dialog( "air_to_air_missile_062", 3 );//Air to Air missiles online.
	self thread say_dialog( "thruster_repair_co_061" );//Thruster repair complete.  Fixed wing flight mode restored.
	//self thread say_dialog( "death_blossom_onli_036", 5 );//Death Blossom online.	
}

// nags player to blow up gas station and/or warehouse, depending on which is alive
vo_roadblock()
{
	e_harper = level.convoy.vh_van;
	e_player = level.player;
	
	wait 7;
	
	e_harper thread say_dialog( "septic_h_the_presi_039" );//Septic - The presidential convoy is pinned down by infantry fire.
	
	wait 5;
	
	add_vo_to_nag_group( "roadblock_nag", e_harper, "get_some_fire_on_t_040" );  //Get some fire on the warehouse rooftops!
	add_vo_to_nag_group( "roadblock_nag", e_harper, "come_on_septic_041" );  //Come, on Septic!!
	add_vo_to_nag_group( "roadblock_nag", e_harper, "tear_?em_up_042" );  //Tear ?em up!!! 
	
	level thread start_vo_nag_group_flag( "roadblock_nag", "ground_targets_done", 6 );
	
	flag_wait( "ground_targets_done" );
	delete_vo_nag_group( "roadblock_nag" );
	
	e_harper thread say_dialog( "harper__roads_cl_044" );  //Harper!  Road?s clear - Move up!
}


vo_convoy_damage_nag()
{
	self notify( "_convoy_nag_end" );
	self endon( "_convoy_nag_end" );
	
	n_nag_line_frequency = 5;
	
	e_harper = level.convoy.vh_van;
	
	while( true )
	{
		self waittill( "damage" );
		
		n_index = RandomIntRange( 1,6 );
		
		e_harper thread say_dialog( "convoy_damage_nag_" + n_index );
		
		wait n_nag_line_frequency;
	}
}

vo_pip_pacing()
{
	vh_potus = level.convoy.vh_potus;
	e_mason = level.player;
	vh_van = level.convoy.vh_van;
	
//    e_hillary thread say_dialog( "agent_mason_h_what_012" );//Agent Mason - What?s the plan?
//    e_mason thread say_dialog( "the_lapd_will_try_013", 3.5 );//The LAPD will try to keep the roads clear, but with so many insurgents we?ll be under constant attack.
//    e_mason thread say_dialog( "flight_computer_wi_015", 8.5 );//Flight computer will track the convoy?s location - I?ll provide overwatch and draw attacks away from you.
//    e_hillary thread say_dialog( "good_luck_mason_015", 12.5 );//Good Luck, Mason.	
    
	vh_potus say_dialog( "samu_the_pmcs_are_floodin_0" );		// The PMCs are flooding every damn intersection!  The LAPD are overwhelmed.  We’re not gonna make it!
	level.player thread say_dialog( "sect_samuels_i_ve_secur_0" );		// Samuels.  I’ve secured an FA/38 to provide air support.
	level.player thread say_dialog( "sect_i_m_tracking_your_lo_0", 4 );	// I’m tracking your location now.  Just hang in there.
    
    flag_waitopen( "pip_playing" );
    flag_set( "pip_intro_done" );
    
    if ( !flag( "harper_dead" ) )
    {
    	vh_van say_dialog( "shit_its_a_fuc_018", 1 );//Shit... It?s a fucking mess... they really hit us hard.
    }
    else 
    {
    	vh_van say_dialog( "samu_the_attack_devastate_0", 1 );	//The attack devastated much of the area.  Dammit.
    }
    
    flag_wait( "convoy_can_move" );
    wait 1;
    
    e_mason say_dialog( "harper_h_make_a_le_016" );	//Harper - make a left on 9th.
    if ( !flag( "harper_dead" ) )
    {
    	vh_van say_dialog( "got_it_017", 1.5 );	//Got it...
    	vh_van say_dialog( "harp_mercs_moving_in_0", 2 );	// Mercs moving in!
    }
    else
    {
    	vh_van say_dialog( "samu_roger_that_0", 1.5 ); // Roger that.
    }
    
    delay_thread( 6, ::vo_truck_group_1_dead );
    
	// cut for GL build
    /*    
    e_mason say_dialog( "shit_enemy_trucks_020" );//Shit! Enemy trucks crashing the Hope St blockade!
    e_mason say_dialog( "keep_moving_go_021" );//Keep moving! Go!
    */
}

vo_pacing()
{
	vh_van = level.convoy.vh_van;
	e_player = level.player;
	
	wait 3;
	
	if ( !flag( "harper_dead" ) )
	{
	    vh_van thread say_dialog( "harp_looks_like_more_trou_0" );  //Looks like more trouble up ahead, Section.
	    vh_van thread say_dialog( "which_way__which_052", 2 );  //Which way?  Which way?!!
	    e_player thread say_dialog( "left__go_left_053", 5 );  //Left!  Go left!!
	}
	else
	{
		vh_van thread say_dialog( "samu_we_got_enemies_dead_0" );	//We got enemies dead ahead, Section.
		vh_van thread say_dialog( "samu_which_way_section_0", 2 );	//Which way, Section?
		e_player thread say_dialog( "left__go_left_053", 5 );  //Left!  Go left!!
	}
}

vo_convoy_distance_check_nag()
{
	level endon( "death" );
	level notify( "vo_convoy_distance_check_nag_stop" );
	level endon( "vo_convoy_distance_check_nag_stop" );
	
	wait 15;
	
	e_player = level.player;
	vh_van = level.convoy.vh_van;
	
	while( true )
	{
		flag_waitopen( "player_in_range_of_convoy" );
	
		array_notify( level.convoy.vehicles, "convoy_stop" );
		
		// TODO: real air attack that fires on convoy

		n_line_choice = randomInt( 2 );
		
		if ( !flag( "convoy_nag_override" ) )
		{
			if ( !flag( "harper_dead" ) )
			{
				if ( n_line_choice == 0 )
				{
					vh_van thread say_dialog( "take_the_heat_off_009" );  //Take the heat off the convoy!
				}
				else 
				{
					vh_van thread say_dialog( "harp_where_are_you_secti_0" );  //Where are you, Section?  We?re taking damage here!
				}	
			}
			else
			{
				if ( n_line_choice == 0 )
				{
					vh_van thread say_dialog( "samu_dammit_we_re_under_0" );  //Dammit! We're under fire!!!
				}
				else 
				{
					vh_van thread say_dialog( "samu_where_are_you_secti_0" );  //Where are you, Section?!
				}					
			}
		}
				
		wait 15;		
	}
}

vo_f35_startup()
{
	if ( !flag( "harper_dead" ) )
	{
		// F35 startup dialog
		vh_f35 = level.f35;
		e_harper = level.convoy.vh_van;
		ai_harper = get_ent( "harper_ai", "targetname" );
		
		// player may rush to F35, where dialog could play two scenes simultaneously
		kill_all_pending_dialog( level.player );
		kill_all_pending_dialog( e_harper );
		
		if ( IsDefined( ai_harper ) )
		{
			kill_all_pending_dialog( ai_harper );
			e_harper = ai_harper; // use AI instead of van (skipto doesn't spawn him in)
		}
	    
	    e_harper say_dialog( "harp_ever_fly_one_of_thes_0" );	// Ever fly one of these, Section?
	    level.player say_dialog( "no___012" );					// No.  
	    e_harper say_dialog( "harp_well_you_re_gonna_fl_0" );	// Well you’re gonna fly one now, Section...
	    e_harper say_dialog( "the_flight_compute_013" );		// The Flight computer should handle most of the work.
	    e_harper say_dialog( "harp_i_ll_take_the_ambula_0" );	// I’ll take the ambulance with Anderson.  
	    e_harper say_dialog( "harp_stay_on_me_and_we_ll_0" );	// Stay on me and we’ll try to regroup with the presidential convoy.	
	}
    
    flag_wait( "F35_startup_started" );

    //Eckert - Changed the timing of Mason VO to play after cockpit close/ music start
//    e_player thread vo_f35_startup_player();
   	
   	// VO plays on top of each other since harper and F35 computer are doing their own things
//   	e_harper thread vo_f35_startup_harper();
//   	vh_f35 thread vo_f35_startup_f35();


 //   e_player thread say_dialog("controls_navigati_019", 11 );//Controls, Navigation, communication and telemetry systems now online.
    


   // e_player thread say_dialog("weapons_systems_di_022", 16 );//Weapons systems diagnostics initiated.
   // e_player thread say_dialog("25mm_cannon_h_onli_023", 18 );//25mm Cannon - Online.
   // e_player thread say_dialog("guided_missile_sys_024", 20 );//Guided missile system - Online.
    
   	if ( flag( "F35_pilot_saved" ) )
	{
//		e_player thread say_dialog("missile_barrage_sy_025", 22 );//Missile barrage system - Online.
	}
	else 
	{
	//	e_player thread say_dialog("missile_barrage_sy_026", 22 );//Missile barrage system - Offline.
	}	 
    

 //   e_player thread say_dialog("warning_structura_028", 26 );//Warning... Structural damage to fuselage and landing gear detected.
 //   e_player thread say_dialog("engines_operating_029",28 );//Engines operating at 60% capacity.

}

vo_f35_startup_player()
{
	wait 2;
	
	self thread say_dialog( "engines_on_027" );//Engines on...
}
	

vo_f35_startup_harper()
{
	e_harper = level.convoy.vh_van;
	e_player = level.player;

//	e_harper thread say_dialog("ill_requisition_a_018", 9 );//I?ll requisition a vehicle and regroup with the presidential convoy.
	
//    e_harper thread say_dialog("do_what_you_can_to_020", 12 );//Do what you can to provide cover from the air.
//    e_player thread say_dialog("good_luck_harper_021", 16 );//Good luck, Harper. See you at Prom Night.	
}

vo_f35_startup_f35()
{
	e_player = level.player;
	vh_f35 = level.f35;
	
//	vh_f35 thread say_dialog("identify_h_mason_016", 1 );//Identify - Mason, David. Priority override - ALPHA DELTA ECHO X-RAY.
//    vh_f35 thread say_dialog("authorization_acce_017", 4 );//Authorization accepted - Start up  sequence initiated.
    
//    vh_f35 thread say_dialog("vtol_mode_enabled_030", 8 );//VTOL Mode enabled.  Fixed wing flight unavailable, thruster repair in progress.
//    vh_f35 thread say_dialog("diagnostics_comple_031", 11 );//Diagnostics complete. Auto pilot disengaged.  You have the stick.	    
     
}

vo_f35_boarding()
{
	level endon( "player_flying" );
	level endon( "player_in_f35" );
	
	wait 6;
	
	if ( !flag( "harper_dead" ) )
	{
		e_harper = get_ent( "harper_ai", "targetname", true );
		
		e_harper say_dialog( "holy_shit_004" );					// Holy Shit...
		e_harper say_dialog( "you_okay_005", 3 );					// You okay?
		level.player say_dialog( "yeah_006", 1 );					// Yeah...
		e_harper say_dialog( "andersons_f/a38_007", 4 );			// Anderson's F/A38. May still be viable...
		level.player say_dialog( "sect_shit_anderson_s_0", 0.5 );	// Shit... Anderson.  She took a hit before - Don’t know how bad.
		
		flag_wait( "start_anderson_f35_exit" );					
		e_harper say_dialog( "harp_least_she_s_still_in_0", 2 );	// Least she’s still in one piece.
		level.player say_dialog( "sect_get_her_to_safety_0", 6 );	// Get her to safety...  Make sure she lives.  
	}
}

vo_trenchruns()
{
	e_harper = level.convoy.vh_van;
	e_player = level.player;
	vh_f35 = level.f35;
	
    e_harper thread say_dialog( "were_not_out_of_t_068", 1 );  //We?re not out of the woods yet.  We have more incoming!
    e_harper thread say_dialog( "why_are_they_comin_069", 4 );  //Why are they coming in so low?
    e_player thread say_dialog( "fuck_theyre_th_070", 6 );  //Fuck!!! They?re through being subtle - bastards are flying straight for you!
    e_player thread say_dialog( "shit_theyre_fast_072", 9 );  //Shit they?re fast!
    
    flag_wait( "convoy_at_trenchrun_turn_2" );
    e_player thread say_dialog( "damn_that_was_to_073" );  //Damn!! That was too close!
    
    flag_wait( "convoy_at_trenchrun_turn_3" );
    e_harper thread say_dialog( "keep_them_off_us_074" );  //Keep them off us!  We can?t take much more!
}

vo_no_guns()
{
	vh_f35 = level.f35;
//	e_player = level.player;
//	e_harper = level.convoy.vh_van;
	
	vh_f35 say_dialog( "ammunition_supplie_075" );  // Ammunition supplies exhausted.  All weapons are offline.
	vh_f35 say_dialog( "lock_acquired_plo_079" );	// Lock acquired. Plotting collision course.
	vh_f35 say_dialog( "eject__eject__ej_080" );	// Eject.  Eject.  Eject.
//    e_player thread say_dialog( "shit_076", 2 );  //Shit!!
}

vo_eject()
{
	e_player = level.player;
	vh_van = level.convoy.vh_van;

    //TUEY kill the radio chatter.
    level notify ("player_ejected");
    
    level thread maps\la_2_anim::vo_no_guns();
    
   	level.player say_dialog( "shit_076" );
   	if ( !flag( "harper_dead" ) )
   	{
		vh_van say_dialog( "harp_what_are_you_doing_0" );
   	}
   	else
   	{
   		vh_van say_dialog( "samu_section_what_are_y_0" );
   	}
	level.player say_dialog( "sect_i_m_gonna_hit_him_he_0" );
	if ( !flag( "harper_dead" ) )
	{
		vh_van say_dialog( "harp_it_s_suicide_0" ); 
	}
	else
	{
		vh_van say_dialog( "samu_i_hope_you_re_sure_a_0" ); 
	}
}

vo_eject_collision()
{
	e_player = level.player;
	e_harper = level.convoy.vh_van;	
	
    e_player thread say_dialog( "shiiiiiiiit_082" );//SHIIIIIIIIT!!	
}

vo_eject_f35()
{
	e_harper = level.convoy.vh_van;
	
//	level.player say_dialog( "shit_076" );
//	e_harper say_dialog( "harp_what_are_you_doing_0" );
//	level.player say_dialog( "sect_i_m_gonna_hit_him_he_0" );
//	e_harper say_dialog( "harp_it_s_suicide_0" );
	
//    e_harper thread say_dialog( "what_are_you_doing_077" );//What are you doing, Septic?    	
//	level.player thread say_dialog( "the_only_thing_i_c_078", 1.7 );//The only thing I can.	
//	self thread say_dialog( "lock_acquired_plo_079" );//Lock acquired. Plotting collision course.
//	self thread say_dialog( "eject__eject__ej_080", 3 );//Eject.  Eject.  Eject.
//	e_harper thread say_dialog( "septic_081", 3.5 );  //Septic!!!
}

vo_hotel()
{
	e_harper = level.convoy.vh_van;
	e_player = level.player;
	
	e_harper thread say_dialog( "septic__those_dro_008" );//Septic!  Those drones are all over us!	
	
	level.f35 thread say_dialog("missiles_offline_037", 2 );//Missiles offline.
	
	if ( flag( "F35_pilot_saved" ) )
	{
		level.f35 thread say_dialog( "death_blossom_offl_035", 2 );//Death Blossom offline.
	}	
}

vo_to_implement()  // this is where something that hasn't been scripted in stays for recordkeeping purposes
{
    
}


vo_f38_target_lock_on_and_off()
{
	level endon( "dogfight_done" );
	self endon( "death" );
	
	level waittill( "dogfights_story_done" );
	
	while(1)
	{
		level waittill( "missile_turret_locked" );	
		self thread say_dialog( "target_locked_034" );
		
		//-- this got really annoying
		//level waittill( "missile_turret_lock_off" );
		//self thread say_dialog( "target_lock_h_lost_036" );
	}
	
}

vo_player_strafed()
{
	level endon( "dogfight_done" );
	
	e_harper = level.convoy.vh_van;
	
	n_current = 0;
	
	str_dialog_array = [];
	
	str_dialog_array[0] = "shit__theyre_all_019";
	str_dialog_array[1] = "warning_h_incoming_026";
	str_dialog_array[2] = "warning_h_enemy_lo_029";
	str_dialog_array[3] = "evasive_action_req_033";
		
	while(1)
	{
		level waittill( "player_being_fired_on" ); //comes from la_2_fly
		
		e_harper say_dialog( str_dialog_array[n_current] );//Septic!  Those drones are all over us!
		n_current++;
		
		if(n_current >= str_dialog_array.size)
		{
			n_current = 0;
			str_dialog_array = array_randomize( str_dialog_array );
		}
		
		wait(5.0); //-- arbitrary wait to keep from getting repeats
	}
}

vo_player_shot_down_drone()
{
	level endon( "dogfight_done" );
	
	n_current = 0;
	
	str_dialog_array = [];
	
	str_dialog_array[0] = "come_on_you_basta_022";
	str_dialog_array[1] = "ive_got_you_now_023";
	str_dialog_array[2] = "got_him_024";
	str_dialog_array[3] = "thats_a_hit_025";
		
	while(1)
	{
		level waittill( "player_shot_down_drone" ); //comes from la_2_fly
		
		level.player say_dialog( str_dialog_array[n_current] );//Septic!  Those drones are all over us!
		n_current++;
		
		if(n_current >= str_dialog_array.size)
		{
			n_current = 0;
		}
		
		wait(5.0); //-- arbitrary wait to keep from getting repeats
	}
}

vo_f38_shot_down_drone()
{
	level endon( "dogfight_done" );
	
	n_current = 0;
	
	str_dialog_array = [];
	
	str_dialog_array[0] = "target_destroyed_037";
	str_dialog_array[1] = "enemy_neutralized_038";
			
	while(1)
	{
		level waittill( "f38_shot_down_drone" ); //comes from la_2_fly
		
		level.player say_dialog( str_dialog_array[n_current] );//Septic!  Those drones are all over us!
		n_current++;
		
		if(n_current >= str_dialog_array.size)
		{
			n_current = 0;
		}
		
		wait(5.0); //-- arbitrary wait to keep from getting repeats
	}
}

vo_lost_lock_on_drone()
{
	level endon( "dogfight_done" );
	
	n_current = 0;
	
	str_dialog_array = [];
	
	str_dialog_array[0] = "target_destroyed_037";
	str_dialog_array[1] = "enemy_neutralized_038";
			
	while(1)
	{
		level waittill( "f38_shot_down_drone" ); //comes from la_2_fly
		
		level.player say_dialog( str_dialog_array[n_current] );//Septic!  Those drones are all over us!
		n_current++;
		
		if(n_current >= str_dialog_array.size)
		{
			n_current = 0;
		}
		
		wait(5.0); //-- arbitrary wait to keep from getting repeats
	}
}
