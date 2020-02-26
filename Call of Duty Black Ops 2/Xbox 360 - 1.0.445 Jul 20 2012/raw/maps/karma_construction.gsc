#include common_scripts\utility;
#include maps\_utility;
#include maps\karma_util;
#include maps\_scene;
#include maps\_objectives;
#include maps\_dialog;
#include maps\_dynamic_nodes;
#include maps\_glasses;
#include maps\_music;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;

/* ------------------------------------------------------------------------------------------
    INIT functions
-------------------------------------------------------------------------------------------*/
init_flags()
{
	flag_init( "exit_breach_ready" );
	flag_init( "crc_lights_out" );
	flag_init( "spawn_creepers" );
	flag_init( "room_clear" );
	flag_init( "sal_in_elevator" );
	flag_init( "player_in_elevator" );
	flag_init( "escalator_open" );
}

init_spawn_funcs()
{
	add_spawn_function_group( "creepers", "script_string", ::anim_interrupt, "e5_guards_cover_fire" );
	add_spawn_function_group( "creepers", "script_string", ::enemy_goal_update_after_anim );
	add_spawn_function_group( "construction_elevator_guys", "targetname", ::enemy_goal_update_after_anim );
	add_spawn_function_group( "construction_elevator_guys", "targetname", ::anim_interrupt, "e5_elevator_guard_flash_exit" );
	add_spawn_function_group( "construction_elevator_guys", "targetname", ::elevator_guys_spawn_func );
	add_spawn_function_group( "construction_midguard", "targetname", ::sprint_to_cover );
	GetEnt( "construction_rearguard_forward_left", "targetname" ) add_spawn_function( ::rearguard_advance, "left" );
	GetEnt( "construction_rearguard_forward_right", "targetname" ) add_spawn_function( ::rearguard_advance, "right" );
	GetEnt( "construction_rearguard_back_left", "targetname" ) add_spawn_function( ::favor_blindfire );
}

/* ------------------------------------------------------------------------------------------
	SKIPTO functions
-------------------------------------------------------------------------------------------*/
skipto_construction()
{
	/#
		IPrintLn( "construction_site" );
	#/
	
	maps\karma_anim::construction_anims();
	
	maps\karma_crc::init_door_clip();
	maps\karma_crc::init_crc_glass_monster_clip();
	maps\karma_crc::init_tarp_clip();
	maps\karma_crc::construction_vision_trigger_cleanup();
	
	maps\createart\karma_art::vision_set_change( "sp_karma_crc" );
	
	//Disable color triggers for use during construction battle after the CRC room
	trigger_off( "construction_battle_color_triggers", "script_noteworthy" );
	trigger_off( "crc_entrance_color_trigger", "targetname" );
	
	add_global_spawn_function( "axis", ::change_movemode, "cqb_run" );
	
	level.ai_salazar = init_hero( "salazar" );

	skipto_teleport( "skipto_construction", array( level.ai_salazar ) );
}


/* ------------------------------------------------------------------------------------------
	MAIN functions
-------------------------------------------------------------------------------------------*/
main()
{	
	clear_exit_victims_spawn_funcs();
	level thread contruction_objectives();	
	
	crc_exit_event();
	
	level.ai_salazar thread sal_think();
	
	flag_set( "draw_weapons" );		
	
	// Wait until the gump is loaded before proceeding to outer solar
	flag_wait( "karma_gump_club" );
	
	cleanup_ents( "cleanup_construction" );
}

//-------------------------------------------------------------------------------------------
// Contruction objectives all the way to Elevator 3.
//-------------------------------------------------------------------------------------------
contruction_objectives()
{	
	set_objective( level.OBJ_GET_TO_CLUB, level.ai_salazar, "follow" );
	scene_wait( "scene_sal_ready_crc_door" );
	
	set_objective( level.OBJ_GET_TO_CLUB, GetStruct( "crc_exit_obj", "targetname" ), "breadcrumb" );
	flag_wait( "scene_sal_exit_crc_door_started" );
	
	set_objective( level.OBJ_GET_TO_CLUB, undefined, "remove" );
	// This used to be scene_wait("scene_sal_exit_crc_door") but it was not getting set as done
	//	for some unknown reason.  So we're waiting for a different scene to end.
	scene_wait( "scene_victim2_exit_crc_door" );
	
	set_objective( level.OBJ_GET_TO_CLUB, GetStruct( "escalator_door_obj", "targetname" ), "breadcrumb" );
	flag_wait( "room_clear" );
	
	set_objective( level.OBJ_GET_TO_CLUB, GetStruct( "club_elevator_obj", "targetname" ), "breadcrumb" );
	flag_wait_all( "player_in_elevator", "sal_in_elevator" );
	
	set_objective( level.OBJ_GET_TO_CLUB, undefined, "done" );
	set_objective( level.OBJ_GET_TO_CLUB, undefined, "delete" );
}

crc_exit_event()
{
	level thread exit_breach_dialog();
	run_scene_and_delete( "scene_sal_ready_crc_door" );
	level thread run_scene_and_delete( "scene_sal_loop_crc_door" );
	flag_wait( "exit_breach_ready" );
	
	//Turn on color triggers for Salazar pathing
	trigger_on( "construction_battle_color_triggers", "script_noteworthy" );	
	trigger_wait( "t_sal_crc_door" );	
	
	level thread autosave_by_name("construction_site");
	
	level.ai_salazar disable_react();
	
	//-------------------------------------------------------------------------------------------
	// Animation of salazar pressing button to exit CRC room.
	//-------------------------------------------------------------------------------------------
	level thread run_scene_and_delete( "scene_sal_exit_crc_door" );
	level thread run_scene_and_delete( "scene_victim1_exit_crc_door" );
	level thread run_scene_and_delete( "scene_victim2_exit_crc_door" );
	level thread run_scene_and_delete( "scene_player_exit_crc_door" );
	flag_wait( "crc_lights_out" );
	
	playsoundatposition ("evt_lights_out", (0,0,0));
	
	level thread maps\createart\karma_art::turn_on_low_light_vision();
    level clientNotify( "lowlight_on" );
        
    playsoundatposition ("evt_lowlight_on", (0,0,0));
    
    level thread maps\_audio::switch_music_wait("KARMA_POST_CRC", 4);
	//-------------------------------------------------------------------------------------------
	// Thread that opens door.
	//-------------------------------------------------------------------------------------------
	crc_door = GetEnt( "crc_door", "targetname" );
	crc_door MoveY( 63, 0.5 );
	wait 4.0;
	
	simple_spawn( "ai_con_site_group_a" );
	// This used to be scene_wait("scene_sal_exit_crc_door") but it was not getting set as done
	//	for some unknown reason.  So we're waiting for a different scene to end.
	scene_wait( "scene_victim2_exit_crc_door" );
	
	level thread construction_dialog();
	level thread escalator_doors_open();
	
	level.ai_salazar waittill( "goal" );
	
	level.ai_salazar enable_react();
	level thread remove_tarp_blockers();
}

clear_exit_victims_spawn_funcs()
{
	GetEnt( "victim1", "targetname" ).spawn_funcs = [];
	GetEnt( "victim2", "targetname" ).spawn_funcs = [];
}

remove_tarp_blockers()
{
	foreach( blocker in GetEntArray( "tarp_blocker", "targetname" ) )
	{
		blocker Delete();
	}
	
	bloody_tarp_blocker = GetEnt( "tarp_collision_bloody", "targetname" );
	bloody_tarp_blocker NotSolid();
	bloody_tarp_blocker ConnectPaths();
	bloody_tarp_blocker Delete();
}

//-------------------------------------------------------------------------------------------
// Opening of escalator doors.
//-------------------------------------------------------------------------------------------
escalator_doors_open()
{	
	e_left_door = GetEnt( "escalator_door_left", "targetname" );
	e_right_door = GetEnt( "escalator_door_right", "targetname" );
	s_left_door_open = GetStruct( "escalator_door_left_open", "targetname" );
	s_right_door_open = GetStruct( "escalator_door_right_open", "targetname" );
	//a_enemys = get_ai_group_ai( "construction_group1" );
	//waittill_dead_or_dying( a_enemys, a_enemys.size );
	trigger_wait( "escalator_door_proximity_trigger" );
	
	autosave_by_name( "crc_exit_cleared" );
	
	GetEnt( "crc_door", "targetname" ) MoveY( -63, 0.5 );
	
	
	simple_spawn( "escalator_breachers" );
	simple_spawn( "ai_con_site_group_b" );
	simple_spawn( "construction_rearguard_forward_left" );
	simple_spawn( "construction_rearguard_forward_right" );
	spawn_manager_enable( "sm_rearguard_left" );
	spawn_manager_enable( "sm_rearguard_right" );
	level thread creeper();
	level thread leaper_spawn();
	level thread mantler_spawn();
	level thread midguard_spawn_think();
	level thread elevator_spawn();
	//level thread setup_balcony_guy();
	level thread run_scene_and_delete( "call_reinforcements" );
	
	level thread run_scene_and_delete( "escalator_door_kick" );
	wait 0.15;
	
	e_left_door playsound( "evt_door_kick" );
	e_left_door RotateYaw( -120.0, 0.4 );
	e_right_door RotateYaw( 140.0, 0.25 );
	flag_set( "room_clear" );
	wait 0.4;
	
	e_left_door ConnectPaths();
	e_right_door ConnectPaths();
}

midguard_spawn_think()
{
	waittill_either_function( ::trigger_wait, "spawn_rearmidguard", ::waittill_ai_group_cleared, "construction_group2" );
	
	simple_spawn( "construction_midguard" );
}

sprint_to_cover()
{
	self endon( "death" );
	
	self change_movemode( "cqb_sprint" );
	self waittill( "goal" );
	
	self reset_movemode();
}

rearguard_advance( str_side )
{
	nd_target = GetNode( self.target, "targetname" );
	
	self waittill( "death" );
	
	ai_back = GetEnt( "construction_rearguard_back_" + str_side + "_ai", "targetname" );
	
	if( IsAlive( ai_back ) )
	{
		ai_back SetGoalNode( nd_target );
	}
}

//-------------------------------------------------------------------------------------------
// Salazar doing things in this area.
//-------------------------------------------------------------------------------------------
sal_think()
{		
	waittill_either_function( ::trigger_wait, "construction_color_trigger1", ::waittill_ai_group_cleared, "construction_group2" );
	
	trigger_use( "construction_color_trigger1" );
	
	waittill_ai_group_cleared( "construction_elevator_group" );
	
	setmusicstate ("KARMA_ELEVATOR");
	
	level thread autosave_by_name("elevator_03");
	level thread play_elevator_03_anim();
	level thread player_in_elevator();	
	run_scene_and_delete( "scene_sal_elevator_enter" );
	
	flag_set( "sal_in_elevator" );
	
	run_scene_and_delete( "scene_sal_elevator_wait" );	
}

creeper()
{
	flag_wait( "spawn_creepers" );
	
	level thread run_scene("e5_guards_cover_fire");
}

anim_interrupt( str_scene )
{
	level endon( "interrupt_" + str_scene );
	self endon( "death" );
	
	while( !flag( str_scene + "_done" ) )
	{
		if( Distance2DSquared( self.origin, level.player.origin ) <= (256 * 256) )
		{
			end_scene( str_scene );
			level notify( "interrupt_" + str_scene );
		}
		
		wait 0.05;
	}
}

enemy_goal_update_after_anim()
{
	self endon( "death" );
	self waittill( "goal" );
	
	set_goal_node( GetNode( self.target, "targetname" ) );
}

leaper_spawn()
{
	e_leaper_target = GetEnt( "leaper_target", "targetname" );
	nd_leaper_goal = GetNode( "leaper_goal", "targetname" );
	nd_leaper_cover = GetNode( "leaper_cover", "targetname" );
	//flag_wait( "spawn_creepers" );
	
	ai_leaper = simple_spawn_single( "leaper" );
	
	ai_leaper endon( "death" );
	
	ai_leaper shoot_at_target( e_leaper_target );
	ai_leaper change_movemode( "cqb_sprint" );
	ai_leaper thread force_goal( nd_leaper_goal, 8 );
	ai_leaper waittill( "goal" );
	
	ai_leaper thread force_goal( nd_leaper_cover, 8 );
	ai_leaper waittill( "goal" );
	
	ai_leaper change_movemode( "cqb_run" );
}

mantler_spawn()
{
	e_mantler_target = GetEnt( "mantler_target", "targetname" );
	nd_mantler_goal = GetNode( "mantler_goal", "targetname" );
	nd_mantler_cover = GetNode( "mantler_cover", "targetname" );
	//flag_wait( "spawn_creepers" );
	
	ai_mantler = simple_spawn_single( "mantler" );
	
	ai_mantler endon( "death" );
	
	ai_mantler shoot_at_target( e_mantler_target, undefined, 0.0, 0.25 );
	ai_mantler change_movemode( "cqb_sprint" );
	ai_mantler thread force_goal( nd_mantler_goal, 8 );
	ai_mantler waittill( "goal" );
	
	ai_mantler thread force_goal( nd_mantler_cover, 8 );
	ai_mantler waittill( "goal" );
	
	ai_mantler change_movemode( "cqb_run" );
}

setup_balcony_guy()
{
	s_align = GetStruct( "align_hallway", "targetname" );
	v_death_origin = GetStartOrigin( s_align.origin, s_align.angles, %generic_human::ch_karma_5_4_balcony_death_guy01 );
	trigger_wait( "t_spawn_balcony_guy" );
	
	guy = simple_spawn_single("ai_con_dead_balcony_guy");
	guy set_goal_pos( v_death_origin );
	guy set_goalradius( 8 );
	guy waittill( "goal" );
	
	if( IsAlive( guy ) )
	{
		guy thread magic_bullet_shield();
	}
			
	guy waittill("damage");
	
	if( DistanceSquared( guy.origin, v_death_origin ) <= (12 * 12) )
	{
		guy stop_magic_bullet_shield();
		run_scene_and_delete( "e5_balcony_guard_death" );
	}
	else
	{
		guy stop_magic_bullet_shield();
	}	
}

favor_blindfire()
{
	self.a.favorblindfire = 1;
}

elevator_spawn()
{
	trigger_wait( "construction_elevator_spawn_trigger" );

	//level clientnotify( "sndDuckSolar" );
	
	s_e3_left_open = getstruct( "e3_left_side_open", "targetname" );
	s_e3_right_open = getstruct( "e3_right_side_open", "targetname" );
	e_e3_left_door = GetEnt( "e3_left_side_top", "targetname" );
	e_e3_right_door = GetEnt( "e3_right_side_top", "targetname" );
	e_elevator_door = GetEnt( "club_elevator_door", "targetname" );
	m_elevator = GetEnt( "club_elevator_model", "targetname" );
	PlayFXOnTag( level._effect["elevator_light"], m_elevator, "tag_flashlight" );
	m_elevator add_cleanup_ent( "outer_solar" );

	playsoundatposition( "amb_elevator_2_bell_3d", (320, -5422, -4246) );
	wait 0.5;
	
	playsoundatposition( "amb_elevator_2_open", (320, -5422, -4246) );
	level thread run_scene( "club_elevator_open" );
	e_elevator_door NotSolid();
	e_e3_left_door MoveTo( (e_e3_left_door.origin[0], s_e3_left_open.origin[1], e_e3_left_door.origin[2]), 1.5 );
	e_e3_right_door MoveTo( (e_e3_right_door.origin[0], s_e3_right_open.origin[1], e_e3_right_door.origin[2]), 1.5 );
	e_e3_right_door waittill( "movedone" );
	
	playsoundatposition( "wpn_smoke_grenade_explode", (3537, -4648, -3596 ) );
	
	exploder( 550 );
	wait 3.0;
	
	e_elevator_door ConnectPaths();
	GetEnt( e_e3_left_door.target, "targetname" ) ConnectPaths();
	GetEnt( e_e3_right_door.target, "targetname" ) ConnectPaths();
	
	run_scene_and_delete("e5_elevator_guard_flash_exit");
	
	
}

elevator_guys_spawn_func()
{
	self endon( "death" );
	
	self change_movemode( "sprint" );
	self waittill( "goal" );
	
	self reset_movemode();
}

//-------------------------------------------------------------------------------------------
// Player walking into elevator.
//-------------------------------------------------------------------------------------------
player_in_elevator()
{
	flag_wait( "sal_in_elevator" );
	trigger_wait( "t_elevator_3_anims" );
	
	flag_set( "player_in_elevator" );
	flag_set( "holster_weapons" );
	level notify( "offices_cleared" );
}

//-------------------------------------------------------------------------------------------
// Elevator 3 animation scene.
//-------------------------------------------------------------------------------------------
play_elevator_03_anim()
{
	e_e3_left_door = GetEnt( "e3_left_side_top", "targetname" );
	e_e3_right_door = GetEnt( "e3_right_side_top", "targetname" );
	s_e3_left_close = getstruct( "e3_left_side_close", "targetname" );
	s_e3_right_close = getstruct( "e3_right_side_close", "targetname" );
	
	s_club_elevator_left_open = getstruct( "club_elevator_left_side_open", "targetname" );
	s_club_elevator_right_open = getstruct( "club_elevator_right_side_open", "targetname" );
	s_club_elevator_left_close = getstruct( "club_elevator_left_side_close", "targetname" );
	s_club_elevator_right_close = getstruct( "club_elevator_right_side_close", "targetname" );	
	e_club_elevator_left_door = GetEnt( "e3_left_side", "targetname" );
	e_club_elevator_right_door = GetEnt( "e3_right_side", "targetname" );
	
	e_p_align = GetEnt( "align_elevator_last", "targetname" );
	e_elevator = GetEnt( "club_elevator", "targetname" );
	e_elevator_door = GetEnt( "club_elevator_door", "targetname" );
	nd_elevator_exit_node	= GetNode( "elevator_exit_node", "targetname" );
	
	//SOUND - Shawn J
	level.sound_elevator2_ent_1 = spawn( "script_origin", level.player.origin );	
	
	e_elevator_door LinkTo( e_elevator );
	
	//-------------------------------------------------------------------------------------------
	// There are two steps to getting the elevator to its destination.  It has to go to transfer origin then to club floor origin.  This is because we made drastic geo changes.
	//-------------------------------------------------------------------------------------------
	s_club_origin = GetStruct( "club_floor_origin", "targetname" );

	m_tag_origin = Spawn( "script_model", e_p_align.origin );
	m_tag_origin SetModel( "tag_origin" );
	m_tag_origin.angles = e_p_align.angles;
	m_tag_origin linkto( e_elevator );
	
	//-------------------------------------------------------------------------------------------
	// Keeps players and AI on platform stable.
	//-------------------------------------------------------------------------------------------
	e_elevator SetMovingPlatformEnabled( true );	
	
	//-------------------------------------------------------------------------------------------
	// Make sure that player and sal is in elevator.
	//-------------------------------------------------------------------------------------------
	flag_wait_all( "player_in_elevator", "sal_in_elevator" );
	
	e_elevator_door Solid();
	
	delete_scene("e5_guards_cover_fire", true);
	
	//SOUND: Shawn J	
	//iprintlnbold ("button_push");
	level.player playsound ("amb_elevator_2_button");

	level thread run_scene_and_delete( "scene_sal_elevator_button" );
	wait 4.0;
	
	//SOUND: Shawn J
	//iprintlnbold ("elevator_start");
	level.player playsound ("amb_elevator_2_close");
	//level.sound_elevator2_ent_1 playloopsound( "amb_elevator_2_loop", 1 );
	level.player playloopsound( "amb_elevator_2_loop", 3 );
	
	level thread run_scene( "club_elevator_close" );
	
	e_e3_left_door MoveTo( (e_e3_left_door.origin[0], s_e3_left_close.origin[1], e_e3_left_door.origin[2]), 1.5 );
	e_e3_right_door MoveTo( (e_e3_right_door.origin[0], s_e3_right_close.origin[1], e_e3_right_door.origin[2]), 1.5 );
	
	e_elevator DisconnectPaths();
	GetEnt( e_e3_left_door.target, "targetname" ) DisconnectPaths();
	GetEnt( e_e3_right_door.target, "targetname" ) DisconnectPaths();
	scene_wait( "scene_sal_elevator_button" );
	
	level clientnotify( "sndDuckSolarOff" );
	
	level thread elevator_dialog();
	
	run_scene_and_delete( "scene_sal_elevator_comment" );
	
	level thread run_scene_and_delete( "scene_sal_elevator_idle" );
	
	e_p_align linkto( e_elevator );

	level.ai_salazar linkto( m_tag_origin, "tag_origin" );

	//-------------------------------------------------------------------------------------------
	// Elevator moves.
	//-------------------------------------------------------------------------------------------
	e_elevator_model = GetEnt( "club_elevator_model", "targetname" );
	e_elevator_model LinkTo( e_elevator );
	e_elevator MoveTo( s_club_origin.origin, 10.0 );	

	level thread load_gump( "karma_gump_club" );
	
	e_elevator waittill( "movedone" );
	
	//SOUND: Shawn J
	//iprintlnbold ("elevator_stop");
	level.player playsound ("amb_elevator_2_stop");	
	level.player playsound ("amb_elevator_2_bell");		
	//level.sound_elevator2_ent_1 stoploopsound (1);
	level.player stoploopsound (1);
	e_elevator_model Unlink();
	
	// Make sure gump is loaded before opening doors	
	flag_wait( "karma_gump_club" );

	e_elevator_door NotSolid();
	
	e_club_elevator_left_door MoveTo( (e_club_elevator_left_door.origin[0], s_club_elevator_left_open.origin[1], e_club_elevator_left_door.origin[2]), 1.5 );
	e_club_elevator_right_door MoveTo( (e_club_elevator_right_door.origin[0], s_club_elevator_right_open.origin[1], e_club_elevator_right_door.origin[2]), 1.5 );
	
	run_scene_and_delete( "club_elevator_open" );
	
	e_elevator ConnectPaths();
	GetEnt( e_club_elevator_left_door.target, "targetname" ) ConnectPaths();
	GetEnt( e_club_elevator_right_door.target, "targetname" ) ConnectPaths();
	
	level.player unlink();
	
	//SOUND - Shawn J - deleting temp elevator ent
	wait 8;
	
	if ( IsDefined( level.sound_elevator_ent_1 ) )
	{
		//iprintlnbold ("deleting_ent");
		level.sound_elevator2_ent_1 delete();
	}
}

exit_breach_dialog()
{
	level.player say_dialog( "sect_farid_they_have_us_0", 0.25 );
	level.player say_dialog( "sect_can_you_access_the_p_0", 0.25 );
	level.player say_dialog( "fari_sure_what_do_you_n_0", 0.5 );
	level.player say_dialog( "sect_on_my_mark_kill_the_0", 0.5 );
	
	flag_set( "exit_breach_ready" );
}

construction_dialog()
{
	level.player say_dialog( "sect_harper_karma_is_no_0", 1.0 );
	level.player say_dialog( "harp_got_it_nice_0", 0.5 );
	level.player say_dialog( "sect_she_s_in_club_solar_0", 0.5 );
	level.player say_dialog( "harp_i_m_on_it_0", 0.5 );
}

elevator_dialog()
{
	level.player say_dialog( "sect_salazar_upstairs_0", 0.5 );
	level.player say_dialog( "sala_understood_0", 0.5 );
}