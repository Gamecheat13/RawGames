#include maps\_utility;
#include common_scripts\utility;
#include maps\_scene;
#include maps\_dialog;
#include maps\_anim;

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
	
	precache_assets();
	
	maps\voice\voice_la_2::init_voice();
	init_vo();
	
	init_drone_anims();
}

#using_animtree( "fakeShooters" );
init_drone_anims()
{
	level.drones.anims[ "throw_molotov" ] = %stand_grenade_throw;
}

harper_wakeup()
{
	str_scene_name = "harper_wakes_up";
	str_align_targetname = undefined;
	b_do_reach = false;
	b_do_generic = false;
	b_do_loop = false;
	b_do_not_align = true;
	add_scene( str_scene_name, str_align_targetname, b_do_reach, b_do_generic, b_do_loop, b_do_not_align );
	
	b_hide_weapon = false;
	b_giveback_weapon = true;
	b_do_delete = false;  
	b_no_death = true;  
	str_tag = undefined;
	add_actor_anim( "harper", %generic_human::ch_la_08_01_standup_harper, b_hide_weapon, b_giveback_weapon, b_do_delete, b_no_death, str_tag );
}

anderson_f35_exit()
{
	str_scene_name = "anderson_f35_exit";
	str_align_targetname = "anim_intro_jet_struct";
	b_do_reach = false;
	b_do_generic = false;
	b_do_loop = false;
	b_do_not_align = false;
	add_scene( str_scene_name, str_align_targetname, b_do_reach, b_do_generic, b_do_loop, b_do_not_align );
	
	b_hide_weapon = false;
	b_giveback_weapon = false;
	b_do_delete = false;  
	b_no_death = true;  
	str_tag = undefined;
	add_actor_anim( "f35_pilot", %generic_human::ch_la_08_01_save_anderson_anderson_fall, b_hide_weapon, b_giveback_weapon, b_do_delete, b_no_death, str_tag );

	add_vehicle_anim( "f35", %vehicles::v_la_08_01_save_anderson_f35 );
}

pilot_drag_setup()
{
	str_scene_name = "pilot_drag_setup";
	str_align_targetname = "anim_intro_jet_struct";
	b_do_reach = false;
	b_do_generic = false;
	b_do_loop = true;
	b_do_not_align = false;
	add_scene( str_scene_name, str_align_targetname, b_do_reach, b_do_generic, b_do_loop, b_do_not_align );
	
	b_hide_weapon = false;
	b_giveback_weapon = true;
	b_do_delete = false;  
	b_no_death = true;  
	str_tag = undefined;
	add_actor_anim( "f35_pilot", %generic_human::ch_la_08_01_save_anderson_anderson_loop, b_hide_weapon, b_giveback_weapon, b_do_delete, b_no_death, str_tag );
}

pilot_drag_van_setup()
{
	str_scene_name = "pilot_drag_van_setup";
	str_align_targetname = "anim_intro_jet_struct";
	b_do_reach = false;
	b_do_generic = false;
	b_do_loop = true;
	b_do_not_align = false;
	add_scene( str_scene_name, str_align_targetname, b_do_reach, b_do_generic, b_do_loop, b_do_not_align );
	
	add_vehicle_anim( "intro_van", %vehicles::v_la_08_01_save_anderson_van );
}

pilot_drag()
{
	b_do_reach = true;
	add_scene( "pilot_drag", "anim_intro_jet_struct", b_do_reach );
	
	b_hide_weapon = true;
	b_giveback_weapon = false;
	b_do_delete = false;  
	b_no_death = true;  
	str_tag = undefined;
	add_actor_anim( "f35_pilot", %generic_human::ch_la_08_01_save_anderson_anderson, b_hide_weapon, b_giveback_weapon, b_do_delete, b_no_death, str_tag );
	
	b_hide_weapon = false;
	b_giveback_weapon = true;
	b_do_delete = false;  
	b_no_death = true;  
	str_tag = undefined;	
	add_actor_anim( "harper", %generic_human::ch_la_08_01_save_anderson_harper, b_hide_weapon, b_giveback_weapon, b_do_delete, b_no_death, str_tag );
	
	add_vehicle_anim( "intro_van", %vehicles::v_la_08_01_save_anderson_van );
}

pilot_drag_van_idle()
{
	str_scene_name = "pilot_drag_van_idle";
	str_align_targetname = "anim_intro_jet_struct";
	b_do_reach = false;
	b_do_generic = false;
	b_do_loop = true;
	b_do_not_align = false;
	add_scene( str_scene_name, str_align_targetname, b_do_reach, b_do_generic, b_do_loop, b_do_not_align );
	
	b_hide_weapon = false;
	b_giveback_weapon = true;
	b_do_delete = false;  
	b_no_death = true;  
	str_tag = undefined;
	add_actor_anim( "f35_pilot", %generic_human::ch_la_08_01_van_loop_anderson, b_hide_weapon, b_giveback_weapon, b_do_delete, b_no_death, str_tag );

	b_hide_weapon = false;
	b_giveback_weapon = true;
	b_do_delete = false;  
	b_no_death = true;  
	str_tag = undefined;
	add_actor_anim( "harper", %generic_human::ch_la_08_01_van_loop_harper, b_hide_weapon, b_giveback_weapon, b_do_delete, b_no_death, str_tag );
		
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
	level.player VisionSetNaked( "helmet_f35_low", 0.5 );	
	maps\la_utility::fade_to_black( 0.25 );
	maps\la_utility::fade_from_black( 0.25 );
	level.f35 thread f35_startup_bink();
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
	str_scene_name = "F35_eject";
	str_align_targetname = "F35";
	b_do_reach = false;
	b_do_generic = false;
	b_do_loop = false;
	b_do_not_align = true;
	add_scene( str_scene_name, str_align_targetname, b_do_reach, b_do_generic, b_do_loop, b_do_not_align );
	//add_scene( "F35_eject", "F35" );
	
	b_do_delete = false;
	n_player_number = 0;
	str_tag = "tag_origin";
	b_do_delta = true;
	n_view_fraction = 0;
	n_right_arc = 30;
	n_left_arc = 30;
	n_top_arc = 30;
	n_bottom_arc = 30;	
	b_use_tag_angles = true;
	add_player_anim( "player_body", %player::ch_la_10_01_f35eject_start_player, 
	                b_do_delete, n_player_number, str_tag, b_do_delta, n_view_fraction,
	               	n_right_arc, n_left_arc, n_top_arc, n_bottom_arc, b_use_tag_angles );
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
	add_notetrack_custom_function( "player_body", "explosion", ::f35_eject_notetrack_explosion );	
	add_notetrack_custom_function( "player_body", "chute", ::f35_eject_notetrack_chute_opens );
	add_notetrack_custom_function( "player_body", "hit_building", ::f35_eject_notetrack_hit_building );
	add_notetrack_custom_function( "player_body", "hit_ground", ::f35_eject_notetrack_hit_ground );
	
	add_vehicle_anim( "eject_sequence_drone", %vehicles::v_la_10_01_f35eject_drone, true );
	add_vehicle_anim( "F35", %vehicles::v_la_10_01_f35eject_f35, true );	
	add_notetrack_custom_function( "F35", "collide", ::midair_collision_notetrack );
	
	str_model = undefined;
	b_do_delete = true;
	b_is_simple_prop = false;
	a_parts = undefined;
	str_tag = undefined;
	add_prop_anim( "f35_eject_parachute", %animated_props::o_la_10_01_f35eject_parachute, str_model, b_do_delete, 
	              b_is_simple_prop, a_parts, str_tag );	
}

f35_outro()
{
	add_scene( "outro_hero", "anim_end_struct" );

	// ai
	b_hide_weapon = true;
	b_giveback_weapon = false;
	b_do_delete = false;  
	b_no_death = true;  
	str_tag = undefined;
	add_actor_anim( "hillary", %generic_human::ch_la_10_02_promnight_hilary, b_hide_weapon, b_giveback_weapon, b_do_delete, b_no_death, str_tag );
	add_actor_anim( "harper", %generic_human::ch_la_10_02_promnight_harper, b_hide_weapon, b_giveback_weapon, b_do_delete, b_no_death, str_tag );
	b_hide_weapon = false;
	add_actor_anim( "ss1", %generic_human::ch_la_10_02_promnight_ss01, b_hide_weapon, b_giveback_weapon, b_do_delete, b_no_death, str_tag );
	add_actor_anim( "ss2", %generic_human::ch_la_10_02_promnight_ss02, b_hide_weapon, b_giveback_weapon );
		
	// player 
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
	add_player_anim( "player_body", %player::ch_la_10_02_promnight_player, 
	                b_do_delete, n_player_number, str_tag, b_do_delta, n_view_fraction,
	               	n_right_arc, n_left_arc, n_top_arc, n_bottom_arc, b_use_tag_angles );

	add_notetrack_custom_function( "player_body", "start_fadeout", ::level_end );
	
	// vehicles
	add_vehicle_anim( "convoy_potus_cougar", %vehicles::v_la_10_02_promnight_cougar );
	add_vehicle_anim( "convoy_van", %vehicles::v_la_10_02_promnight_van );
	
	// optionally dead vehicles can't be in same scene, so we have separate scenes for each one.
	add_scene( "outro_g20_1", "anim_end_struct" );
	add_vehicle_anim( "convoy_g20_1", %vehicles::v_la_10_02_promnight_cougar02 );
	
	add_scene( "outro_g20_2", "anim_end_struct" );
	add_vehicle_anim( "convoy_g20_2", %vehicles::v_la_10_02_promnight_cougar03 );
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
	level.f35 notify( "midair_collision" );
	//PlayFXOnTag( level._effect[ "midair_collision_explosion" ], level.f35, "body_animate_jnt" );
	PlayFX( level._effect[ "midair_collision_explosion" ], level.f35.origin, AnglesToForward( level.f35.angles ) );
}


f35_eject_notetrack_eject( e_player_body )
{
	maps\la_2_player_f35::F35_remove_visor();
	
	n_earthquake_magnitude = 0.3;
	n_earthquake_duration = 0.6;
	str_rumble = "damage_heavy";
	n_rumble_count = 3;
	n_loop_time = 0.2;
	
	Earthquake( n_earthquake_magnitude, n_earthquake_duration, level.player.origin, 512, level.player );
	level.player thread rumble_loop( n_rumble_count, n_loop_time, str_rumble );	
}

f35_eject_notetrack_explosion( e_player_body )
{
	n_earthquake_magnitude = 0.3;
	n_earthquake_duration = 1;
	str_rumble = "damage_heavy";
	n_rumble_count = 4;
	n_loop_time = 0.25;
	
	Earthquake( n_earthquake_magnitude, n_earthquake_duration, level.player.origin, 512, level.player );
	level.player thread rumble_loop( n_rumble_count, n_loop_time, str_rumble );
}

f35_eject_notetrack_hit_ground( e_player_body )
{
	str_rumble = "damage_heavy";
	n_rumble_count = 5;
	n_loop_time = 0.2;
	
	level.player thread rumble_loop( n_rumble_count, n_loop_time, str_rumble );	
}

f35_eject_notetrack_chute_opens( e_player_body )
{
	str_rumble = "damage_heavy";
	n_rumble_count = 3;
	n_loop_time = 0.2;
	
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
	
	e_harper = level.convoy.vh_van;
	e_player = level.player;
	
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
	
	flag_wait( "convoy_at_apartment_building" );
	
	wait 10;
	
    e_harper thread say_dialog( "hope_you_know_what_054" );//Hope you know what you?re doing!
    e_player thread say_dialog( "we_got_more_rpgs_i_055", 2 );//We got more RPGs in the parking structure!
    e_player thread say_dialog( "brace_yourselves_h_056", 4 );//Brace yourselves - I?ll try to clear them out!!
    e_harper thread say_dialog( "dammit_septic__it_057", 6 );//Dammit Septic!  It?s ambush fucking alley down here!
    e_harper thread say_dialog( "were_taking_fire_058", 9 );//We?re taking fire from all sides!
    e_player thread say_dialog( "i_know_059", 12 );//I know!
    e_player thread say_dialog( "come_on_you_basta_060", 14 );//Come on, you bastards!!!
}

vo_dogfight()
{
	e_harper = level.convoy.vh_van;
	e_player = level.player;	
	vh_f35 = level.f35;
	
	wait 3;
	
   	e_harper thread say_dialog( "bastards_tried_to_006", 1 );//Bastards tried to drop a fucking building on us!	
    e_player thread say_dialog( "shit__harper__go_063", 4 );//Shit!  Harper.  Got multiple drones incoming!  What?s your status?
    e_harper thread say_dialog( "were_nearly_there_064", 7 );//We?re nearly there.  Infantry resistance is thinning out.
    e_harper thread say_dialog( "just_worry_about_y_065", 10 );//Just worry about yourself right now!
    e_harper thread say_dialog( "good_luck_septic_066", 12 );//Good luck, Septic! 
    
    wait 12;
    
    flag_set( "dogfights_story_done" );
    
    flag_wait( "dogfight_done" );
    e_player thread add_dialog("nice_work_septic_067", 2 );//Nice work, Septic.
}

vo_dogfight_f35()
{	
	self thread say_dialog( "thruster_repair_co_061" );//Thruster repair complete.  Fixed wing flight mode restored.
	self thread say_dialog( "air_to_air_missile_062", 3 );//Air to Air missiles online.
	self thread say_dialog( "death_blossom_onli_036", 5 );//Death Blossom online.	
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

vo_pacing()
{
	e_harper = level.convoy.vh_van;
	e_player = level.player;
	
	wait 3;
	
    e_harper thread say_dialog( "looks_like_more_tr_051" );  //Looks like more trouble up ahead, Septic.
    e_harper thread say_dialog( "which_way__which_052", 2 );  //Which way?  Which way?!!
    e_player thread say_dialog("left__go_left_053", 5 );  //Left!  Go left!!
}

vo_convoy_distance_check_nag()
{
	level endon( "death" );
	
	wait 1;
	
	e_player = level.player;
	e_harper = level.convoy.vh_van;
	
	while( true )
	{
		flag_waitopen( "player_in_range_of_convoy" );
	
		array_notify( level.convoy.vehicles, "convoy_stop" );
		
		// TODO: real air attack that fires on convoy

		n_line_choice = randomInt( 1 );
		
		if ( !flag( "convoy_nag_override" ) )
		{
			if ( n_line_choice == 0 )
			{
				e_harper thread say_dialog( "take_the_heat_off_009" );  //Take the heat off the convoy!
			}
			else 
			{
				e_harper thread say_dialog( "where_are_you_sep_010" );  //Where are you, Septic?  We?re taking damage here!
			}	
		}
				
		wait 8;		
	}
}

vo_f35_startup()
{
	// F35 startup dialog
	vh_f35 = level.f35;
	e_harper = level.convoy.vh_van;
	ai_harper = get_ent( "harper_ai", "targetname" );
	e_player = level.player;
	
	// player may rush to F35, where dialog could play two scenes simultaneously
	kill_all_pending_dialog( e_player );
	kill_all_pending_dialog( e_harper );
	
	if ( IsDefined( ai_harper ) )
	{
		kill_all_pending_dialog( ai_harper );
		e_harper = ai_harper; // use AI instead of van (skipto doesn't spawn him in)
	}
	
    e_harper thread say_dialog("the_flight_compute_013", 1 );//The Flight computer should handle most of the work.
    e_player thread say_dialog("are_we_sure_its_n_014", 4 );//Are we sure it?s not compromised?
    e_harper thread say_dialog("dont_sweat_it_se_015", 6 );//Don?t sweat it, Septic.  It?s independent of our defense network. Menendez can?t touch you.
    
    flag_wait( "F35_startup_started" );
    
   	e_player thread say_dialog( "engines_on_027" );//Engines on...
   	
   	// VO plays on top of each other since harper and F35 computer are doing their own things
   	e_harper thread vo_f35_startup_harper();
   	vh_f35 thread vo_f35_startup_f35();


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

vo_f35_startup_harper()
{
	e_harper = level.convoy.vh_van;
	e_player = level.player;

	e_harper thread say_dialog("ill_requisition_a_018", 9 );//I?ll requisition a vehicle and regroup with the presidential convoy.
	
    e_harper thread say_dialog("do_what_you_can_to_020", 12 );//Do what you can to provide cover from the air.
    e_player thread say_dialog("good_luck_harper_021", 16 );//Good luck, Harper. See you at Prom Night.	
}

vo_f35_startup_f35()
{
	e_player = level.player;
	vh_f35 = level.f35;
	
	vh_f35 thread say_dialog("identify_h_mason_016", 1 );//Identify - Mason, David. Priority override - ALPHA DELTA ECHO X-RAY.
    vh_f35 thread say_dialog("authorization_acce_017", 4 );//Authorization accepted - Start up  sequence initiated.
    
    vh_f35 thread say_dialog("vtol_mode_enabled_030", 8 );//VTOL Mode enabled.  Fixed wing flight unavailable, thruster repair in progress.
    vh_f35 thread say_dialog("diagnostics_comple_031", 11 );//Diagnostics complete. Auto pilot disengaged.  You have the stick.	    
     
}

vo_f35_boarding()
{
	level endon( "player_flying" );
	level endon( "player_in_f35" );
	
	wait 0.1;
	
	e_harper = get_ent( "harper_ai", "targetname", true );
	e_player = level.player;
	
    e_harper thread say_dialog("septic_002", 2 );//Septic!
    e_harper thread say_dialog("you_okay_brother_003" , 4);//You okay, brother?
    e_harper thread say_dialog("holy_shit_004", 6 );//Holy Shit...
    e_harper thread say_dialog("you_okay_005", 9 );//You okay?
    e_harper thread say_dialog("yeah_006", 11 );//Yeah...
    e_player thread say_dialog("andersons_f/a38_007", 17 );//Anderson?s F/A38. May still be viable...
	
	flag_wait( "start_anderson_f35_exit" );
	
    e_player thread say_dialog("anderson_008", 1 );//Anderson!
    e_harper thread say_dialog("anderson_ander_009", 3 );//Anderson?... Anderson?
    e_player thread say_dialog("get_her_to_safety_010",6 );//Get her to safety.
    e_harper thread say_dialog("ever_fly_one_of_th_011", 8 );//Ever fly one of these, Septic?
    e_player thread say_dialog("no___012", 10 );//No.
    e_harper thread say_dialog("you_gonna_have_to_001", 12 );//You gonna have to fly her, Septic...
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
	e_player = level.player;
	e_harper = level.convoy.vh_van;
	
	vh_f35 thread say_dialog( "ammunition_supplie_075" );  //Ammunition supplies exhausted.  All weapons are offline.
    e_player thread say_dialog( "shit_076", 2 );  //Shit!!
}

vo_eject()
{
	e_player = level.player;
	e_harper = level.convoy.vh_van;

    //TUEY kill the radio chatter.
    level notify ("player_ejected");
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
	e_player = level.player;
	
    e_harper thread say_dialog( "what_are_you_doing_077" );//What are you doing, Septic?    	
	level.player thread say_dialog( "the_only_thing_i_c_078", 1.7 );//The only thing I can.	
	self thread say_dialog( "lock_acquired_plo_079" );//Lock acquired. Plotting collision course.
	self thread say_dialog( "eject__eject__ej_080", 3 );//Eject.  Eject.  Eject.
	e_harper thread say_dialog( "septic_081", 3.5 );  //Septic!!!
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
