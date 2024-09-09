#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\ss_util;
#include maps\fusion;
#include soundscripts\_audio;
#include soundscripts\_snd;
#include soundscripts\_audio_music;
#include maps\_vehicle_shg;
#include maps\_shg_utility;
#include maps\_shg_debug;
#include maps\fusion_utility;
#include maps\_hud_util;

ROBOT_SAFE_PLAYER_RADIUS = 200*200;
ROBOT_SAFE_AI_RADIUS = 96*96;

fusion_intro_screen()
{
	level.player FreezeControls( true );
	thread maps\_introscreen::introscreen_generic_black_fade_in( 11, 5 );
	flag_set( "intro_screen_done" );
	flag_set( "introscreen_complete" );  // needed to trigger the beginning of level autosave
	wait 11;
	level.player FreezeControls( false );
}

gameplay_setup()
{
	maps\_variable_grenade::main();
	//thread setup_personal_drone();
	thread setup_m_turret();
	thread setup_spawn_functions();
	thread finale_enemy_transports();
	thread finale_enemy_gaz();
	thread interior_gameplay();
	thread evacuation_setup();
	thread setup_evacuation_scene();
	thread extraction_chopper();
	thread extraction_chopper_collapse();
	thread cooling_tower_collapse();
	if (level.currentgen)
		thread mobile_cover_drones_cg();
}

setup_spawn_functions()
{
	array_spawn_function_noteworthy( "enemy_street_wave_01", ::street_enemy_think );
	array_spawn_function_noteworthy( "enemy_street_wave_02", ::street_enemy_think );
	array_spawn_function_noteworthy( "enemy_street_turret_wave_2", ::street_enemy_think );
	array_spawn_function_noteworthy( "enemy_street_wave_rear_mi17_01", ::street_enemy_think );
	array_spawn_function_noteworthy( "enemy_street_wave_03", ::street_enemy_building_east_think );
	array_spawn_function_noteworthy( "enemy_street_wave_04", ::street_enemy_building_west_think );
	array_spawn_function_noteworthy( "enemy_street_zip_rooftop", ::rooftop_enemy_think );
	array_spawn_function_noteworthy( "enemy_street_zip_rooftop_strafe", ::rooftop_enemy_think );
	array_spawn_function_noteworthy( "enemy_street_tank_stage_01", ::street_enemy_tank_battle_think );
	array_spawn_function_noteworthy( "enemy_street_tank_stage_02", ::street_enemy_tank_battle_think );
	array_spawn_function_noteworthy( "enemy_street_tank_stage_03", ::street_enemy_tank_battle_think );
	array_spawn_function_noteworthy( "enemy_street_turret_wave_1", ::street_enemy_tank_damaged_think );
	array_spawn_function_noteworthy( "enemy_street_turret_wave_2", ::street_enemy_tank_damaged_think );
	array_spawn_function_noteworthy( "enemy_street_blown_building", ::street_enemy_blown_building_think );
	
	array_spawn_function_noteworthy( "turbine_room_enemy", ::turbine_room_enemy_think );
	
	array_thread( GetEntArray( "corpse_trigger", "targetname" ), ::corpse_trigger_think );
	
//	array_spawn_function_noteworthy( "enemy_street_tank_stage_04", ::street_enemy_tank_battle_think );
	
	
	
	array_spawn_function_noteworthy( "enemy_street_wave_rear", ::street_enemy_think );
	array_spawn_function_noteworthy( "rpg_vehicle", ::postspawn_rpg_vehicle );
	array_spawn_function_targetname ( "hangar_enemies_01", ::hangar_enemy_think );
	add_global_spawn_function( "allies", ::add_drone_to_squad );
	add_global_spawn_function( "allies", ::disable_badplace_for_red_guys );
	
	array_spawn_function_noteworthy( "evacuation_first_drones", ::evacuation_first_drones_think );
	
	add_global_spawn_function( "axis", ::detect_turret_death );
	add_global_spawn_function( "axis", maps\_chargeable_weapon::AI_detect_charged_damage );
}

mobile_cover_drones_cg()
{
	if (level.start_point != "fly_in_animated" &&
	    level.start_point != "fly_in_animated_part2" &&
	    level.start_point != "courtyard")
		return;
	mobile_cover_drone_spawns = GetEntArray("mobile_cover_drones", "targetname");
	cover_drones = [];
	foreach (spawner in mobile_cover_drone_spawns)
	{
		cover_drones[cover_drones.size] = spawner spawn_vehicle();
	}
	
	level waittill("street_cleanup");
	array_call(cover_drones, ::Delete);
}

heroes_post_zip()
{
	spawner = getent( "hero_alpha_leader", "script_noteworthy" );
	spawner add_spawn_function( ::alpha_leader_think );
	level.alpha_leader = spawner spawn_ai( true );
	level.alpha_leader.animname = "alpha_leader";
	level.alpha_leader magic_bullet_shield( true );
	level.alpha_leader.disableFriendlyFireReaction = true;
	
//	spawner = getent( "hero_carter", "targetname" );
//	level.carter = spawner spawn_ai( true );
	level.carter Unlink();
	level.carter teleport_ent( getstruct( "carter_zip_dest", "targetname" ) );
//	level.carter magic_bullet_shield();
	level.carter disable_ai_color();
	level.carter enable_sprint();
	level.carter.disableFriendlyFireReaction = true;
	level.carter gun_recall();
	
//	spawner = getent( "hero_joker", "targetname" );
//	level.joker = spawner spawn_ai( true );
	level.joker unlink();
	level.joker teleport_ent( getstruct( "joker_zip_dest", "targetname" ) );
//	level.joker magic_bullet_shield();
	level.joker.disableFriendlyFireReaction = true;
	level.joker gun_recall();
	

}

alpha_leader_think()
{
	flag_wait( "flag_walker_destroyed" );
	
	level.alpha_leader set_force_color( "y" );
}

disable_badplace_for_red_guys()
{
	if( !isDefined( self.script_forcecolor ) || self.script_forcecolor != "r" )
		return;
	
	self thread ignore_badplace( undefined, "flag_mt_wall_rpg_impact" );
}
		
objectives()
{
	thread set_obj_markers_current();
	obj_shut_down_reactor();
	obj_escape();
}

obj_shut_down_reactor()
{
	objective_add( obj("shutdown_reactor") , "active", &"FUSION_OBJECTIVE_REACTOR" );
	objective_current( obj("shutdown_reactor") );
	objective_position ( obj("shutdown_reactor"), getent( "obj_reactor_01", "targetname" ).origin );
	
	flag_wait( "update_obj_pos_walker" );
//	flag_wait( "flag_enemy_walker" );
	
	if( IsDefined( level.walker ) )
	{
		Objective_SetPointerTextOverride( obj("shutdown_reactor"), &"FUSION_OBJECTIVE_WALKER" );
		offset_tag = spawn_tag_origin();
		offset_tag LinkTo(level.walker, "tag_camera", (0, 0, -24), (0, 0, 0));
		Objective_OnEntity( obj("shutdown_reactor"), offset_tag, ( 0, 0, 0 ));
		
		flag_wait( "flag_walker_destroyed" );
		Objective_SetPointerTextOverride( obj("shutdown_reactor"), "" );
//		objective_position ( obj("shutdown_reactor"), getent( "obj_reactor_02", "targetname" ).origin );
		offset_tag Delete();
	}
	
	flag_wait( "update_obj_pos_security_entrance" );
	Objective_Position( obj( "shutdown_reactor" ), getstruct( "obj_pos_security_entrance", "targetname" ).origin );
	
	flag_wait( "update_obj_pos_security_room" );
	Objective_Position( obj( "shutdown_reactor" ), getstruct( "obj_pos_security_room", "targetname" ).origin );
	
	flag_wait( "update_obj_pos_security_elevator_burke" );
	if( IsDefined( level.burke ) )
	{
		Objective_OnEntity( obj( "shutdown_reactor" ), level.burke );
	}
	
	flag_wait( "update_obj_pos_security_elevator" );
	Objective_Position( obj( "shutdown_reactor" ), getstruct( "obj_pos_security_elevator", "targetname" ).origin );
	
	flag_wait( "update_obj_pos_elevator_descent" );
	Objective_Position( obj( "shutdown_reactor" ), (0, 0, 0) );
	
	flag_wait( "update_obj_pos_lab_follow_joker" );
	if( IsDefined( level.joker ) )
	{
		Objective_OnEntity( obj( "shutdown_reactor" ), level.joker );
	}
	
	flag_wait( "update_obj_pos_lab_follow_burke" );
	if( IsDefined( level.burke ) )
	{
		Objective_OnEntity( obj( "shutdown_reactor" ), level.burke );
	}
	
	flag_wait( "update_obj_pos_lab_follow_carter" );
	if( IsDefined( level.carter ) )
	{
		Objective_OnEntity( obj( "shutdown_reactor" ), level.carter );
	}
	
	flag_wait( "update_obj_pos_reactor_1" );
	Objective_Position( obj( "shutdown_reactor" ), getstruct( "obj_pos_reactor_1", "targetname" ).origin );
	
	flag_wait( "update_obj_pos_reactor_2" );
	Objective_Position( obj( "shutdown_reactor" ), getstruct( "obj_pos_reactor_2", "targetname" ).origin );
	
	flag_wait( "update_obj_pos_reactor_exit" );
	Objective_Position( obj( "shutdown_reactor" ), getstruct( "obj_pos_reactor_exit", "targetname" ).origin );
	
	flag_wait( "update_obj_pos_reactor_storage_1" );
	Objective_Position( obj( "shutdown_reactor" ), getstruct( "obj_pos_reactor_storage_1", "targetname" ).origin );
	
	flag_wait( "update_obj_pos_reactor_storage_2" );
	Objective_Position( obj( "shutdown_reactor" ), getstruct( "obj_pos_reactor_storage_2", "targetname" ).origin );
	
	flag_wait( "update_obj_pos_turbine_elevator" );
	Objective_Position( obj( "shutdown_reactor" ), getstruct( "obj_pos_turbine_elevator", "targetname" ).origin );
	
	flag_wait( "update_obj_pos_turbine_elevator_button" );
	Objective_Position( obj( "shutdown_reactor" ), getent( "elevator_button", "targetname" ).origin );
	Objective_SetPointerTextOverride( obj( "shutdown_reactor" ), &"FUSION_OBJ_POINTER_USE" );
	
	flag_wait( "update_obj_pos_turbine_elevator_ascent" );
	Objective_Position( obj( "shutdown_reactor" ), (0, 0, 0) );
	Objective_SetPointerTextOverride( obj("shutdown_reactor"), "" );
	
	flag_wait( "update_obj_pos_turbine_room_1" );
	Objective_Position( obj( "shutdown_reactor" ), getstruct( "obj_pos_turbine_room_1", "targetname" ).origin );
	
	flag_wait( "update_obj_pos_turbine_room_exit" );
	Objective_Position( obj( "shutdown_reactor" ), getstruct( "obj_pos_turbine_room_exit", "targetname" ).origin );
	
	flag_wait( "update_obj_pos_control_room_door" );
	Objective_Position( obj( "shutdown_reactor" ), getstruct( "obj_pos_control_room_door", "targetname" ).origin );
	
	flag_wait( "update_obj_pos_control_room_explosion" );
	Objective_Position( obj( "shutdown_reactor" ), (0, 0, 0) );
	
	flag_wait( "update_obj_pos_control_room_console" );
	Objective_Position( obj( "shutdown_reactor" ), getstruct( "obj_pos_control_room_console", "targetname" ).origin );
	
	flag_wait( "update_obj_pos_control_room_using_console" );
	Objective_Position( obj( "shutdown_reactor" ), (0, 0, 0) );
	
	flag_wait( "flag_shut_down_reactor_failed" );
	
	wait 2;

	Objective_State( obj("shutdown_reactor"), "failed" );
	
	wait 2;
}

set_obj_markers_current()
{
	flag_wait( "flag_obj_markers" );
	objective_add( obj("use_mobile_cover"), "invisible", "" );
	objective_add( obj("enter_mobile_turret"), "invisible", "" );
	objective_add( obj("use_smaw"), "invisible", "" );
	
	thread obj_use_mobile_cover();
	thread obj_enter_mobile_turret();
	thread obj_use_smaw();
}

obj_use_mobile_cover()
{
	Objective_State_NoMessage( obj("use_mobile_cover"), "active" );
	Objective_Current_NoMessage( obj("use_mobile_cover"), obj("shutdown_reactor"), obj("enter_mobile_turret") );
	Objective_SetPointerTextOverride( obj("use_mobile_cover"), &"FUSION_OBJ_POINTER_USE" );
	objective_position ( obj("use_mobile_cover"), getent( "org_obj_use_mobile_cover", "targetname" ).origin );
	
	level.player waittill ( "player_linked_to_cover" );
	
	objective_state_nomessage( obj("use_mobile_cover"), "done" );
}

obj_enter_mobile_turret()
{
	flag_wait( "flag_mt_move_up_03" );
	Objective_State_NoMessage( obj("enter_mobile_turret"), "active" );
	Objective_Current_NoMessage( obj("enter_mobile_turret"), obj("shutdown_reactor") );
	Objective_SetPointerTextOverride( obj("enter_mobile_turret"), &"FUSION_OBJ_POINTER_ENTER" );
	objective_position ( obj("enter_mobile_turret"), getent( "org_obj_enter_mobile_turret", "targetname" ).origin );
	
	level.player waittill ( "player_starts_entering_mobile_turret" );
	
	objective_state_nomessage( obj("enter_mobile_turret"), "done" );
}

obj_use_smaw()
{
	
	flag_wait( "flag_enemy_walker" );
	
	thread track_smaw();
	
	Objective_State_NoMessage( obj("use_smaw"), "active" );
	Objective_Current_NoMessage( obj("use_smaw"), obj("shutdown_reactor") );
	Objective_SetPointerTextOverride( obj("use_smaw"), &"FUSION_OBJ_POINTER_USE" );
	
	flag_wait( "flag_walker_reveal_dialogue_complete" );
	
	showing_objective = false;
	while( !flag( "flag_walker_destroyed" ) )
	{
		if( does_player_have_smaw() )
		{
			if(showing_objective)
			{
			objective_state_nomessage( obj("use_smaw"), "done" );
				showing_objective = false;
		}
		}
		else
	{	
			if(!showing_objective)
		{
	Objective_State_NoMessage( obj("use_smaw"), "active" );
	Objective_Current_NoMessage( obj("use_smaw"), obj("shutdown_reactor") );
	Objective_SetPointerTextOverride( obj("use_smaw"), &"FUSION_OBJ_POINTER_USE" );
				objective_onentity ( obj("use_smaw"), level.smaw_location );
				showing_objective = true;
			}
		}
		waitframe();
		}
		
	if(showing_objective)
		{
			objective_state_nomessage( obj("use_smaw"), "done" );
		showing_objective = false;
		}
	
	level notify( "stop_track_smaw" );
	
	level.smaw_location Delete();
	level.smaw_location = undefined;
}

track_smaw()
{
	level endon ( "stop_track_smaw" );
	
	// initially this will be at the radiant authored position
	level.smaw_location = spawn_tag_origin();
	level.smaw_location.origin = getent( "org_obj_use_smaw", "targetname" ).origin;
	
	while( true )
	{
		level.player waittill( "pickup", weapon, dropped_weapon );
		
		if( IsDefined ( dropped_weapon ) && IsSubStr( dropped_weapon.classname, "smaw_nolock_fusion" ) )
		{
			level.smaw_location LinkTo(dropped_weapon, "", (-10, 8, 1), (0, 0, 0));
		}
	}
}

does_player_have_smaw()
{
		weapons = level.player GetWeaponsListAll();
		
		foreach( player_weapon in weapons )
		{
			if( player_weapon == "smaw_nolock_fusion" )
			{
			return true;
			}
		}
		
	return false;
}


obj_escape()
{
	objective_number = 2;
	objective_add( objective_number, "active", &"FUSION_OBJECTIVE_ESCAPE" );
	objective_current( objective_number );
	objective_position ( objective_number, getent( "obj_escape_01", "targetname" ).origin );
	
	flag_wait( "update_obj_pos_control_room_exit_1" );
	objective_position ( objective_number, getstruct( "obj_pos_control_room_exit_1", "targetname" ).origin );
	
	flag_wait( "update_obj_pos_control_room_exit_2" );
	objective_position ( objective_number, getstruct( "obj_pos_control_room_exit_2", "targetname" ).origin );
	
	flag_wait( "update_obj_pos_hangar_entrance" );
	objective_position ( objective_number, getstruct( "obj_pos_hangar_entrance", "targetname" ).origin );
	
	flag_wait( "flag_obj_02_pos_update_02" );
	objective_position ( objective_number, getent( "obj_escape_02", "targetname" ).origin );
	
	flag_wait( "flag_obj_02_pos_update_03" );
	objective_position ( objective_number, getent( "obj_escape_03", "targetname" ).origin );
	
	flag_wait( "objective_on_extraction_chopper" );
	if( IsDefined( level.extraction_chopper ) )
	{
		Objective_OnEntity( objective_number, level.extraction_chopper );
	}
	
	flag_wait ( "tower_knockback" );
	
	//wait 5;
	Objective_State( objective_number, "invisible" );
}

#using_animtree( "vehicles" );
squad_heli_zip()
{
	flag_wait( "intro_squad_helis_start" );
	
	wait( 0.05 ); //wait for heli to spawn
	
	level.heli_squad_01.animname = "npc_zip_warbird";
	level.heli_squad_01.goalradius = 1;
	
	org = spawn( "script_origin", ( -80, -2480, 752 ) ); //mad hacks
	org.angles = ( 0, 265, 0 );
	
	flag_wait( "flag_squad_heli_2_unload" );
	
	level.heli_squad_01 SetVehGoalPos( org.origin, true );
	level.heli_squad_01 waittill( "goal" );
	
	level.heli_squad_01 Vehicle_SetSpeedImmediate( 0, 0.05, 0.05 );
  	level.heli_squad_01 SetHoverParams( 0, 0, 0 );
	
	level.heli_squad_01 notify( "stop_handle_rotors" );
	
	org anim_first_frame_solo( level.heli_squad_01, "npc_zip" );
	
	spawner_1 = getent( "npc_zip_guy_1", "targetname" );
	spawner_2 = getent( "npc_zip_guy_2", "targetname" );
	spawner_3 = getent( "npc_zip_guy_3", "targetname" );
	spawner_4 = getent( "npc_zip_guy_4", "targetname" );
	
	guy_1 = spawner_1 spawn_ai( true );
	guy_1.animname = "npc_zip_1";
	guy_1.ignoreme = true;
	
	guy_2 = spawner_2 spawn_ai( true );
	guy_2.animname = "npc_zip_2";
	guy_2.ignoreme = true;
	
	guy_3 = spawner_3 spawn_ai( true );
	guy_3.animname = "npc_zip_3";
	guy_3.ignoreme = true;
	
	guy_4 = spawner_4 spawn_ai( true );
	guy_4.animname = "npc_zip_4";
	guy_4.ignoreme = true;
	
	rope_1 = spawn_anim_model( "zipline_1" );
	rope_2 = spawn_anim_model( "zipline_2" );
	rope_3 = spawn_anim_model( "zipline_3" );
	rope_4 = spawn_anim_model( "zipline_4" );
	
	guys = [ guy_1, guy_2, guy_3, guy_4, rope_1, rope_2, rope_3, rope_4 ]; //TODO: verify ropes are deleted when done
	
	level.heli_squad_01 anim_first_frame( guys, "npc_zip", "TAG_GUY0" );
	
	foreach( guy in guys )
	{
		guy linkto( level.heli_squad_01, "TAG_GUY0" );
	}
	
	org thread anim_single_solo( level.heli_squad_01, "npc_zip" );
	level.heli_squad_01 anim_single( guys, "npc_zip", "TAG_GUY0" );
		
	foreach( guy in guys )
	{
		guy Unlink();
	}
		
	rope_1 delete();
	rope_2 delete();
	rope_3 delete();
	rope_4 delete();
	
	guy_1 goto_node( "node_squad_zip_guard_01", false );
	guy_2 goto_node( "node_squad_zip_guard_02", false );
	
	guy_3 delete();
	guy_4 delete();
	
	wait 2;
	
	flag_set( "flag_rpg_at_heli" );
	flag_set( "flag_squad_heli_01_zip_complete" );
	level.heli_squad_01 SetHoverParams( 50, 10, 10 );
	level.heli_squad_01 SetMaxPitchRoll ( 15, 40 );
	level.heli_squad_01 thread vehicle_scripts\_xh9_warbird::handle_rotors();
	
	level.heli_squad_01.script_vehicle_selfremove = true;
	
	flag_wait( "flag_player_zip_started" );
	
	guy_1 delete();
	guy_2 delete();
	org delete();
}

#using_animtree( "vehicles" );
fly_in_scene_part1( org, warbird_a, player_rig )
{
	anim_time = GetAnimLength( %fusion_fly_in_intro_warbird_a );
	level.player Shellshock( "fusion_slowview", anim_time ); 
	
//	level.burke gun_remove();
	level.joker gun_remove();
	level.carter gun_remove();
	
	helis_intro = [];
	helis_intro[0] = warbird_a;
	
	org anim_first_frame( helis_intro, "fly_in_intro" );
	
	warbird_a_guys = [];
	warbird_a_guys[0] = player_rig;
	warbird_a_guys[1] = level.burke;
	warbird_a_guys[2] = level.joker;
	warbird_a_guys[3] = level.carter;
	warbird_a_guys[4] = level.copilot_intro;
	warbird_a_guys[5] = level.pilot_intro;
	warbird_a_guys[6] = level.guy_facing_player_intro;
	
	snd_message("start_hologram_audio");
	snd_message("start_burke_foley", level.burke);
	snd_message("start_intro_npc_foley", level.guy_facing_player_intro);
	
	foreach( guy in warbird_a_guys )
	{
		guy thread hide_friendname_until_flag_or_notify( "warbird_fly_in_arrived" );
	}
	
	warbird_a anim_first_frame( warbird_a_guys, "fly_in_intro", "tag_guy0" );
	foreach( guy in warbird_a_guys )
	{
		guy LinkTo( warbird_a, "tag_guy0" );
	}
	
	// line up player view
	level.player PlayerLinkToDelta( player_rig, "tag_player", 1, 0, 0, 0, 0, true );
	//player_rig Show();
	
	flag_wait( "intro_screen_done" );
	
	thread intro_heli_movies();
	
	level.player thread widen_player_view( player_rig );
	
	org thread anim_single( helis_intro, "fly_in_intro" );
	warbird_a anim_single( warbird_a_guys, "fly_in_intro", "tag_guy0" );
	
//	level.guy_facing_player_intro delete();
	
	//rotor shadow on player's warbird
	rotor_originL = spawn_tag_origin(); //TODO: verify org is deleted when done
	rotor_originL linkto(warbird_a,"TAG_ORIGIN", (0,0,0), (270,0,0));
	PlayFxOnTag(getfx("warbird_rotor"), rotor_originL, "TAG_ORIGIN");
}

widen_player_view( player_rig )
{
	// wait for animation to start
	wait 0.2;
	self PlayerLinkToDelta( player_rig, "tag_player", .75, 35, 0, 15, 25, true );
		
	flag_wait( "flag_combat_zip_rooftop_start" );
	
	self LerpViewAngleClamp( 4.0, 2.0, 2.0, 50, 30, 15, 45 );
}

lerp_wind( wind_amplitude, wind_frequency, end_wind_amplitude, end_wind_frequency, lerp_time )
{
	wind_amplitude_step = ( end_wind_amplitude - wind_amplitude ) / ( lerp_time / 0.05 );
	wind_frequency_step = ( end_wind_frequency - wind_frequency ) / ( lerp_time / 0.05 );
	while ( lerp_time > 0 )
	{
		wind_amplitude += wind_amplitude_step;
		wind_frequency += wind_frequency_step;
		SetSavedDvar( "r_reactiveMotionWindAmplitudeScale", wind_amplitude );
		SetSavedDvar( "r_reactiveMotionWindFrequencyScale", wind_frequency );
		
		lerp_time -= 0.05;
		wait 0.05;
	}
}

wind_over_trees()
{
	wait 20;
	
	lerp_wind( 0.3, 1, 15, 1.5, 1.5 );
	
	wait 1.75;
	
	lerp_wind( 15, 1.5, 10, 1, 1 );
	
	wait 3;
	
	lerp_wind( 10, 1, 20, 2, 2 );
	
	wait 5;
	
	SetSavedDvar( "r_reactiveMotionWindAmplitudeScale", "0.3" );
	SetSavedDvar( "r_reactiveMotionWindFrequencyScale", "0.5" );
}

fly_in_scene_part2( org, warbird_a, player_rig )
{
	thread wind_over_trees();
//	anim_time = GetAnimLength( %fusion_fly_in_pt2_warbird_a );
	level.player Shellshock( "fusion_slowview", 50 ); 
	
	warbird_b = spawn_vehicle_from_targetname( "squad_blackhawk" ); //TODO: Verify warbird is deleted when done
	warbird_b.animname = "warbird_b";
	warbird_b.no_anim_rotors = true;
	warbird_b Vehicle_TurnEngineOff();  //Turning off default engine audio.
	//warbird_b DontCastShadows();
	
	warbird_c = spawn_vehicle_from_targetname( "warbird_c" );
	warbird_c.animname = "warbird_c";
	warbird_c.no_anim_rotors = true;
	warbird_c Vehicle_TurnEngineOff();  //Turning off default engine audio.
	//warbird_c DontCastShadows();
	
	warbird_d = spawn_vehicle_from_targetname( "warbird_d" );
	warbird_d.animname = "warbird_d";
	warbird_d.no_anim_rotors = true;
	warbird_d Vehicle_TurnEngineOff();  //Turning off default engine audio.
	//warbird_d DontCastShadows();
	
	warbird_e = spawn_vehicle_from_targetname( "warbird_e" );
	warbird_e.animname = "warbird_e";
	warbird_e.no_anim_rotors = true;
	warbird_e Vehicle_TurnEngineOff();  //Turning off default engine audio.
	//warbird_e DontCastShadows();
	
	npc_b_spawner = GetEnt( "npc_b", "targetname" );
	npc_b = npc_b_spawner spawn_ai( true );
	npc_b.animname = "npc_b";
	//npc_b DontCastShadows();
	
	npc_c_spawner = GetEnt( "npc_c", "targetname" );
	npc_c = npc_c_spawner spawn_ai( true );
	npc_c.animname = "npc_c";
	//npc_c DontCastShadows();
	
	npc_d_spawner = GetEnt( "npc_d", "targetname" );
	npc_d = npc_d_spawner spawn_ai( true );
	npc_d.animname = "npc_d";
	//npc_d DontCastShadows();
	
	npc_e_spawner = GetEnt( "npc_e", "targetname" );
	npc_e = npc_e_spawner spawn_ai( true );
	npc_e.animname = "npc_e";
	// DontCastShadows();
	
	waittillframeend;
	waittillframeend;
	
	warbird_b vehicle_scripts\_xh9_warbird::cloak_warbird();
	npc_b Hide();
	npc_c Hide();
	npc_d Hide();
	npc_e Hide();
	warbird_b thread wait_to_decloak_helicopter( 4.25, npc_b, npc_c, npc_d, npc_e );
	
	thread fly_in_squad_uncloak();

	tower_debris = spawn_anim_model( "tower_debris" );
	
	debris_org = getstruct( "tower_debris_part", "targetname" );
	
	helis_part2 = [];
	helis_part2[0] = warbird_a;
	helis_part2[1] = warbird_b;
	helis_part2[2] = warbird_c;
	helis_part2[3] = warbird_d;
	helis_part2[4] = warbird_e;
	
	warbird_a_guys = [];
	warbird_a_guys[0] = player_rig;
	warbird_a_guys[1] = level.burke;
	warbird_a_guys[2] = level.joker;
	warbird_a_guys[3] = level.carter;
	warbird_a_guys[4] = level.copilot_intro;
	warbird_a_guys[5] = level.pilot_intro;
	warbird_a_guys[6] = level.guy_facing_player_intro;
	
	// setup warbirds
	org anim_first_frame( [ warbird_b, warbird_c, warbird_d, warbird_e ], "fly_in_part2" );
	
	// setup warbird_b
	warbird_b_guys = [];
	warbird_b_guys[0] = npc_b;
	warbird_b_guys[1] = npc_c;
	warbird_b_guys[2] = npc_d;
	warbird_b_guys[3] = npc_e;
	
	PlayFxOnTag(getfx("distortion_warbird"), warbird_b, "TAG_STATIC_MAIN_ROTOR_R");
	
	/*rotor_originR = spawn_tag_origin();
	rotor_originR linkto(warbird_b,"TAG_STATIC_MAIN_ROTOR_R", (0,0,0), (270,0,0));
	PlayFxOnTag(getfx("warbird_rotor"), rotor_originR, "TAG_ORIGIN");
	
	rotor_originL = spawn_tag_origin();
	rotor_originL linkto(warbird_b,"TAG_STATIC_MAIN_ROTOR_L", (0,0,0), (270,0,0));
	PlayFxOnTag(getfx("warbird_rotor"), rotor_originL, "TAG_ORIGIN");
	
	rotor_originSM = spawn_tag_origin();
	rotor_originSM linkto(warbird_b,"TAG_SPIN_TAIL_ROTOR", (0,0,0), (0,90,0));
	PlayFxOnTag(getfx("warbird_rotor_sm"), rotor_originSM, "TAG_ORIGIN");*/
	
	warbird_b anim_first_frame( warbird_b_guys, "fly_in_part2", "tag_guy0" );
	foreach( guy in warbird_b_guys )
	{
		//guy gun_remove();
		//guy DontCastShadows();
		guy LinkTo( warbird_b, "tag_guy0" );
	}
	
	// setup warbirds carrying walkers
	warbird_c thread play_warbird_carrying_walker( "warbird_pulley_c", "warbird_walker_c", "fly_in_part2", "tag_guy0", "TAG_ATTACH" );
	warbird_d thread play_warbird_carrying_walker( "warbird_pulley_d", "warbird_walker_d", "fly_in_part2", "tag_guy0", "TAG_ATTACH" );
	warbird_e thread play_warbird_carrying_walker( "warbird_pulley_e", "warbird_walker_e", "fly_in_part2", "tag_guy0", "TAG_ATTACH" );
	warbird_c thread custom_dust_kickup();
	warbird_d thread custom_dust_kickup();
	warbird_e thread custom_dust_kickup();
	
	warbird_a maps\fusion_anim::clear_vehicle_anim(0);
	warbird_b maps\fusion_anim::clear_vehicle_anim(0);
	player_rig maps\fusion_anim::clear_player_anim(0);
	level.burke maps\fusion_anim::clear_npc_anim(0);
	level.joker maps\fusion_anim::clear_npc_anim(0);
	level.carter maps\fusion_anim::clear_npc_anim(0);
	level.copilot_intro maps\fusion_anim::clear_npc_anim(0);
	level.pilot_intro maps\fusion_anim::clear_npc_anim(0);
	
	// play animations
	org thread anim_single( helis_part2, "fly_in_part2" );
	debris_org thread anim_single_solo( tower_debris, "tower_debris_collision" );
	debris_org thread maps\fusion_fx::play_tower_debris_fx(tower_debris);
	warbird_b thread anim_single( warbird_b_guys, "fly_in_part2", "tag_guy0" );
	
	level.guy_facing_player_intro delaycall( 3, ::Delete );
	
	warbird_a anim_single( warbird_a_guys, "fly_in_part2", "tag_guy0" );
	
	//warbird_a thread anim_loop_solo( level.burke, "fly_in_end_idle", "stop_idle", "tag_guy0" );
	org thread anim_loop_solo( warbird_a, "burke_intro_zip_loop", "stop_idle" );
	
	npc_b Delete();
	npc_c Delete();
	npc_d Delete();
	npc_e Delete();
//	level.guy_facing_player_intro delete();
	
	warbird_c Delete();
	warbird_d Delete();
	warbird_e Delete();
	
	/*rotor_originR Delete();
	rotor_originL Delete();
	rotor_originSM Delete();*/
	
	level notify( "warbird_fly_in_arrived" );
		
	thread rooftop_strafe();
	thread delete_guys_in_heli_when_vo_complete();
	thread delete_tower_debris(tower_debris);
}

delete_tower_debris(tower_debris)
{
	flag_wait( "player_fly_in_done" );
	tower_debris StopAnimScripted();
	tower_debris Delete();
}

play_warbird_carrying_walker( pulley_name, walker_name, scene_name, warbird_tag, pulley_tag )
{
	pulley = spawn_anim_model( pulley_name );
	self anim_first_frame_solo( pulley, scene_name, warbird_tag );
	pulley LinkTo( self, warbird_tag );
	walker = spawn_anim_model( walker_name );
	pulley anim_first_frame_solo( walker, scene_name, pulley_tag );
	walker LinkTo( pulley, "TAG_ATTACH" );
	//self DontCastShadows();
	//walker DontCastShadows();
	shadow_tag = spawn_tag_origin();
	shadow_tag LinkTo( self, "tag_origin", (0,0,0), (-90,0,0) );
	PlayFXOnTag( getfx( "warbird_shadow" ), shadow_tag, "tag_origin" );
	
	self thread anim_single_solo( pulley, scene_name, warbird_tag );
	pulley thread anim_single_solo( walker, scene_name, pulley_tag );
	
	level waittill( "warbird_fly_in_arrived" );
	
	StopFXOnTag( getfx( "warbird_shadow" ), shadow_tag, "tag_origin" );
	shadow_tag Delete();
	
	pulley Delete();
	walker Delete();
}

delete_guys_in_heli_when_vo_complete()
{
	flag_wait( "squad_out_dialogue_complete" );
	
//	level.joker delete();
//	level.carter delete();	
//	level.guy_facing_player_intro delete();
}

launch_missile( missile_name )
{
	missile = spawn_anim_model( missile_name );
	missile.animname = missile_name;
	
	missile thread missile_fly( self, missile_name );
	return missile;
}

missile_fly( org, missile_name )
{
	if(missile_name == "missile_0")
		fx = getfx( "smoketrail_groundtoair_large" );
	else
		fx = getfx( "smoketrail_groundtoair" );
	PlayFXOnTag( fx, self, "TAG_FX" );
	
	org anim_single_solo( self, "fly_in_part2" );
	
	if(missile_name == "missile_0")
		fx = getfx( "smoketrail_groundtoair_large" );
	else
		fx = getfx( "smoketrail_groundtoair" );
	StopFXOnTag( fx, self, "TAG_FX" );
	self Delete();
}
		
spawn_intro_pilots()
{
	// co-pilot of level.warbird_a
	npc_f_spawner = GetEnt( "npc_f", "targetname" );
	level.copilot_intro = npc_f_spawner spawn_ai( true );
	level.copilot_intro.animname = "npc_f";
	level.copilot_intro gun_remove();
	
	// pilot of level.warbird_a
	npc_g_spawner = GetEnt( "npc_g", "targetname" );
	level.pilot_intro = npc_g_spawner spawn_ai( true );
	level.pilot_intro.animname = "npc_g";
	level.pilot_intro gun_remove();
	
	thread clean_up_intro_pilots();
}

clean_up_intro_pilots()
{
	level waittill( "warbird_fly_in_arrived" );
	level.copilot_intro Delete();
	level.pilot_intro Delete();
}

spawn_intro_heroes()
{
//	burke_spawner = GetEnt( "intro_burke", "targetname" );
//	level.burke = burke_spawner spawn_ai( true );
//	level.burke.animname = "burke";
//	
//	joker_spawner = GetEnt( "intro_joker", "targetname" );
//	level.joker = joker_spawner spawn_ai( true );
//	level.joker.animname = "joker";	
//	
//	carter_spawner = GetEnt( "intro_carter", "targetname" );
//	level.carter = carter_spawner spawn_ai( true );
//	level.carter.animname = "carter";
	
	guy_facing_player_spawner = GetEnt( "npc_h", "targetname" );
	level.guy_facing_player_intro = guy_facing_player_spawner spawn_ai( true );
	level.guy_facing_player_intro.animname = "npc_h";
}

fly_in_sequence()
{
	flag_set( "sun_shad_fly_in" );
		
	thread flag_set_delayed( "intro_squad_helis_start", 50 );
	thread flag_set_delayed( "street_combat_start", 90 );
	//thread flag_set_delayed( "zipline_fog", 94 );
	thread move_squad_and_walkers(); //set flags and activate triggers that would normally be set from radiant spline
	thread squad_heli_zip();
	thread fly_in_ambient_heli_squad();
	thread fly_in_ambient_jets();
	thread fly_in_ambient_street_jets();
	thread hide_objective_during_fly_in();

	level.warbird_a = spawn_vehicle_from_targetname( "blackhawk" );
	level.warbird_a.animname = "warbird_a";
	level.warbird_a.no_anim_rotors = true;
	level.warbird_a Vehicle_TurnEngineOff();  //Turning off default engine audio.
	level.warbird_a snd_message( "player_warbird_spawn" );
	
	//Removed vfx lighting playing on tags. Put this into the fusion_lighting.gsc
	wait 0.1;
	wait 0.1;

	spawn_intro_heroes();
	spawn_intro_pilots();
	
	player_rig = spawn_player_anim_rig();
	player_rig Hide();	

	level.player setup_player_for_scene();
	
	org = getstruct( "org_flyin", "targetname" );
	
	fly_in_scene_part1( org, level.warbird_a, player_rig );
		
	finish_fly_in_sequence( org, level.warbird_a, player_rig );
}

play_dust(heli)
{
	noself_delayCall(1, ::PlayFxOnTag, getfx("fast_blowing_dust"), level.warbird_a, "TAG_outside_door"); 
}

hide_objective_during_fly_in()
{
	setsaveddvar( "objectiveHide", true );
	flag_wait( "player_fly_in_done" );
	setsaveddvar( "objectiveHide", false );
}

finish_fly_in_sequence( org, warbird_a, player_rig )
{
	delayThread( 50, ::start_rooftop_combat );
	
	warbird_a.missile_org = org;
	fly_in_scene_part2( org, warbird_a, player_rig );
	level.burke gun_recall();
	thread burke_rooftop_combat( org, warbird_a );
	noself_delayCall(0, ::Stopfxontag, getfx("fast_blowing_dust"), level.warbird_a, "TAG_outside_door");
	
	thread burke_fastzip_scene( org, level.warbird_a );
		
	flag_wait( "player_can_zip" );
	flag_set( "ready_zip" );
	activate_trigger_with_targetname( "trig_move_squad_from_heli" );
	
	player_rig Hide();
	
	player_arms = spawn_anim_model( "player_arms", player_rig.origin );
	player_arms.angles = player_rig.angles;
	player_arms Hide();

	thread rooftop_slide();
		
	level.player thread maps\_player_fastzip::fastzip_turret_think( level.warbird_a, "tag_turret_zipline_kl", player_arms, 2.7 );
	level.player waittill( "using_zip" );
	
	level.player DisableWeapons();
	
	level.player waittill( "fastzip_start" );
	thread zip_debris_anim();
	thread street_hanging_pipes_anim();
	flag_set( "flag_player_zip_started" );
	
	level.player waittill( "fastzip_arrived" );
	flag_set( "sun_shad_off_zip" );
	
	level.player setup_player_for_gameplay();
	
	player_rig Delete();
	player_arms Delete();
	
	wait 0.05;
	flag_set( "player_fly_in_done" );
	delayThread(3, ::autosave_by_name);
	thread delete_rooftop_los_blockers();
	thread show_hide_plant_vista();
	
	//heli vehicle_detachfrompath();
	level.warbird_a Vehicle_SetSpeed( 60, 15, 5 );
	node = getstruct ( "heli_path_leave", "targetname" ); 
	level.warbird_a thread vehicle_dynamicpath( node, false );	
	level.warbird_a snd_message( "player_warbird_flyout" );
	level.warbird_a.script_vehicle_selfremove = true;
}


show_hide_plant_vista()
{
	vista = getentarray( "brushmodel_vista_plant", "targetname" );
	
	if( isDefined( vista ) )
	{
		vista thread hide_plant_vista_via_trigger();
		vista thread show_plant_vista_via_trigger();
	}
}

show_hide_plant_vista_intro()
{
	vista = getentarray( "brushmodel_vista_plant", "targetname" );
	
	if( isDefined( vista ) )
	{
		vista thread hide_plant_vista_intro();
		vista thread show_plant_vista_intro();
	}
}

hide_plant_vista_intro()
{
	foreach( thing in self )
	{
		thing Hide();
	}
}

show_plant_vista_intro()
{
	level.player endon( "death" );
	
	wait( 71 ); //hack
	
	foreach( thing in self )
	{
		thing Show();
	}
}

hide_plant_vista_via_trigger()
{
	level endon( "street_cleanup" );
	
	while( true )
	{
		trigger_wait_targetname( "trig_hide_plant_vista" );
		foreach( thing in self )
		{
			thing Hide();
		}
	}
}

show_plant_vista_via_trigger()
{
	level endon( "street_cleanup" );
	
	while( true )
	{
		trigger_wait_targetname( "trig_show_plant_vista" );
		foreach( thing in self )
		{
			thing Show();
		}
	}
}

zip_debris_anim()
{
	wait( 1.0 );
	
	org = getstruct( "org_zip_debris", "targetname" );
	
	debris_1 = spawn_anim_model( "zip_debris_01" ); //TODO: verify debris is deleted when done
	debris_2 = spawn_anim_model( "zip_debris_02" );
	
	guys = [ debris_1, debris_2 ];
	
	org anim_single( guys, "zip_falling_debris" );
}

street_hanging_pipes_anim()
{		  
	org = getstruct( "org_hanging_pipes_01", "targetname" );
	pipes = spawn_anim_model( "street_pipes_01" ); //TODO: verify pipes are deleted when done
	org anim_loop_solo( pipes, "street_hanging_pipes" );
	
	if (level.currentgen)
	{
		level waittill("street_cleanup");
		org anim_stopanimscripted();
		pipes Delete();
	}
}

fly_in_ambient_heli_squad()
{
	flag_wait( "intro_squad_helis_start" );
	
	level.heli_squad_01 = spawn_ambient_warbird( "squad_warbird_01", 25, 45 );
	level.heli_squad_02 = spawn_ambient_warbird( "squad_warbird_02", 25, 45, true );
	level.heli_squad_03 = spawn_ambient_warbird( "squad_warbird_03", 20, 50, true );
	//level.heli_squad_04 = spawn_ambient_warbird( "squad_warbird_04", 25, 50, true );
	level.heli_squad_05 = spawn_ambient_warbird( "squad_warbird_05", 25, 50, true );
	level.heli_squad_06 = spawn_ambient_warbird( "squad_warbird_06", 25, 50, true );
	level.heli_squad_07 = spawn_ambient_warbird( "squad_warbird_07", 25, 50, true );
	
	//cargo_warbirds
	level.heli_squad_08 = spawn_ambient_warbird( "squad_warbird_08", 10, 25, true );
	level.heli_squad_09 = spawn_ambient_warbird( "squad_warbird_09", 10, 25, true );
	//level.heli_squad_10 = spawn_ambient_warbird( "squad_warbird_cargo10", 10, 25, true );
	level.heli_squad_11 = spawn_ambient_warbird( "squad_warbird_cargo11", 10, 25, true );
	
	//cargo_warbirds
	level.heli_squad_11 thread add_warbird_cargo( "cargo_walker11", "cargo_pully11" );
	level.heli_squad_08 thread add_warbird_cargo( "cargo_walker12", "cargo_pully12" );
	level.heli_squad_05 thread add_warbird_cargo( "cargo_walker13", "cargo_pully13" );

	//turning off default engine audio.
	level.heli_squad_01 Vehicle_TurnEngineOff();
	level.heli_squad_02 Vehicle_TurnEngineOff();
	level.heli_squad_03 Vehicle_TurnEngineOff();
	//level.heli_squad_04 Vehicle_TurnEngineOff();
	level.heli_squad_05 Vehicle_TurnEngineOff();
	level.heli_squad_06 Vehicle_TurnEngineOff();
	level.heli_squad_07 Vehicle_TurnEngineOff();
	level.heli_squad_08 Vehicle_TurnEngineOff();
	level.heli_squad_09 Vehicle_TurnEngineOff();
	level.heli_squad_11 Vehicle_TurnEngineOff();
}

spawn_ambient_warbird( vehicle_targetname, max_pitch, max_roll, self_remove )
{
	warbird = spawn_vehicle_from_targetname_and_drive( vehicle_targetname );
	warbird vehicle_scripts\_xh9_warbird::cloak_warbird();
	warbird SetMaxPitchRoll( max_pitch, max_roll );
	
	warbird vehicle_scripts\_xh9_warbird::set_cloak_parameter( 0.0, 0.0 );	// start with cloak transition faded out

	if ( IsDefined( self_remove ) )
	{
		warbird.script_vehicle_selfremove = self_remove;
	}
	
	warbird.shadow_tag = spawn_tag_origin();
	warbird.shadow_tag LinkTo( warbird, "tag_origin", (0,0,0), (-90,0,0) );
	PlayFXOnTag( getfx("warbird_shadow_cloaked"), warbird.shadow_tag, "tag_origin" );
	
	return warbird;
}

add_warbird_cargo( cargo_name, cargo_pulley )
{
	cargo = GetEnt( cargo_name, "targetname" );
    cargo LinkTo( self );
    
    pulley = GetEnt( cargo_pulley, "targetname" );
    pulley LinkTo( self );
    
    self waittill( "death" );
    
    cargo unlink();
    cargo delete();
    
    pulley unlink();
    pulley delete();
}
	
fly_in_squad_uncloak()
{
	wait 3.5;
	level.heli_squad_01 thread uncloak_ambient_warbird( level.shadow_tag_01, 3.3 );
	wait .15;
	level.heli_squad_09 thread uncloak_ambient_warbird( level.shadow_tag_09, 3.3 );
	wait .15;
	level.heli_squad_11 thread uncloak_ambient_warbird( level.shadow_tag_11, 3.3 );
	wait .15;
	level.heli_squad_06 thread uncloak_ambient_warbird( level.shadow_tag_06, 3.3 );
	wait .15;
	level.heli_squad_07 thread uncloak_ambient_warbird( level.shadow_tag_07, 3.3 );
	wait .15;
	level.heli_squad_08 thread uncloak_ambient_warbird( level.shadow_tag_08, 3.3 );
	wait .15;
	level.heli_squad_05 thread uncloak_ambient_warbird( level.shadow_tag_05, 3.3 );
	wait .15;
	//level.heli_squad_04 thread uncloak_ambient_warbird( level.shadow_tag_04, 3.3 );
	wait .15;
	level.heli_squad_03 thread uncloak_ambient_warbird( level.shadow_tag_03, 3.3 );
	wait 1.25;
	level.heli_squad_02 thread uncloak_ambient_warbird( level.shadow_tag_02, 3.3 );
	
	//turn off transparent shadows when helis hit cliff as you can see the particles draw for them.
	flag_wait("fx_flak_intro");
	
	level.heli_squad_01 clean_up_shadow_tag();
	level.heli_squad_02 clean_up_shadow_tag();
	level.heli_squad_03 clean_up_shadow_tag();
	//level.heli_squad_04 clean_up_shadow_tag();
	level.heli_squad_05 clean_up_shadow_tag();
	level.heli_squad_06 clean_up_shadow_tag();
	level.heli_squad_07 clean_up_shadow_tag();
	level.heli_squad_08 clean_up_shadow_tag();
	level.heli_squad_09 clean_up_shadow_tag();
	//level.heli_squad_10 clean_up_shadow_tag();
	level.heli_squad_11 clean_up_shadow_tag();
}

uncloak_ambient_warbird( shadow_tag, transition_time )
{
	curr_transition_time = 5.3;
	if( isDefined( transition_time ) ) transition_time = curr_transition_time;
	self vehicle_scripts\_xh9_warbird::uncloak_warbird( 8.3 );
	//self DontCastShadows();
	//maps\_vehicle::vehicle_lights_on( "running" );	
	
	if ( IsDefined( self.shadow_tag ) )
	{
		StopFXOnTag( getfx( "warbird_shadow_cloaked" ), self.shadow_tag, "tag_origin" );
		PlayFXOnTag( getfx( "warbird_shadow" ), self.shadow_tag, "tag_origin" );
	}
}

clean_up_shadow_tag()
{
	if ( IsDefined( self.shadow_tag ) )
	{
		StopFXOnTag( getfx("warbird_shadow"), self.shadow_tag, "tag_origin" );
		self.shadow_tag Delete();
	}
}
	
fly_in_ambient_jets()
{
	thread spawn_looping_jets( "f15_01" );
	thread spawn_looping_jets( "f15_02" );
	thread spawn_looping_jets( "f15_03" );
	thread spawn_looping_jets( "f15_04" );
	thread spawn_looping_jets( "f15_05" );
	thread spawn_looping_jets( "f15_06" );
}

spawn_looping_jets( tname )
{
	while( !flag("flag_combat_zip_rooftop_complete") )
	{
		jet = spawn_vehicle_from_targetname_and_drive( tname );
		jet waittill( "death" );
	}
}

fly_in_ambient_street_jets()
{
	flag_wait( "flag_player_zip_started" );
	
	thread spawn_looping_street_jets( "f15_street01" ); //TODO: verify jets are deleted when done
	thread spawn_looping_street_jets( "f15_street02" );
	thread spawn_looping_street_jets( "f15_street03" );
	thread spawn_looping_street_jets( "f15_street04" );
	thread spawn_looping_street_jets( "f15_street05" );
	thread spawn_looping_street_jets( "f15_street06" );
	thread spawn_looping_street_jets( "f15_street07" );
	thread spawn_looping_street_jets( "f15_street08" );
}

spawn_looping_street_jets( tname )
{
	while( !flag("flag_player_at_reactor_entrance") )
	{
		jet = spawn_vehicle_from_targetname_and_drive( tname );
		//send message to audio system for courtyard jets audio -jgavazza
		jet snd_message( "snd_start_ambient_jet" );
		jet waittill( "death" );
	}
}

wait_to_decloak_helicopter( delay_time, npc_1, npc_2, npc_3, npc_4 )
{
	level.player endon( "death" );
	
	wait( delay_time );
	self snd_message( "decloak_intro_helicopter" );
	self thread vehicle_scripts\_xh9_warbird::uncloak_warbird();
	//self DontCastShadows(); 

	wait( 1.5 );
	npc_1 Show();
	npc_2 Show();
	npc_3 Show();
	npc_4 Show();
	npc_1 StopUsingHeroOnlyLighting();
	npc_2 StopUsingHeroOnlyLighting();
	npc_3 StopUsingHeroOnlyLighting();
	npc_4 StopUsingHeroOnlyLighting();
}

/////////// BURKE ROOFTOP COMBAT //////////////////////
#using_animtree( "generic_human" );
burke_rooftop_combat( org, warbird )
{
	if ( flag( "flag_burke_zip" ) )
		return;
	
	org anim_single_solo( level.burke, "burke_rooftop_shoot_enter" );
	
	level.burke.face_direction = AnglesToForward( level.burke.angles );
	
	level.burke notify( "killanimscript" );
	level.burke.custom_animscript[ "combat" ] = ::burke_rooftop_combat_animscript;
	level.burke.custom_animscript[ "stop" ] = ::burke_rooftop_combat_animscript;
	
	flag_wait( "flag_burke_zip" );
	level.burke.custom_animscript[ "combat" ] = undefined;
	level.burke.custom_animscript[ "stop" ] = undefined;
	level.burke notify( "killanimscript" );
	level.burke ClearAnim( %burke_aiming, 0.2 );
	level.burke ClearAnim( %burke_add_fire, 0.2 );
	level.burke.last_pitch_aim = undefined;
	level.burke.last_yaw_aim = undefined;
	level.burke.face_direction = undefined;
}

burke_rooftop_combat_animscript()
{
	self notify( "killanimscript" );
	self endon( "killanimscript" );
	
	level.burke OrientMode( "face direction", level.burke.face_direction );
	
	self setup_burke_aim_anims();

	current_enemy = undefined;
	
	while ( true )
	{
		// pick an enemy
		if ( !IsDefined( current_enemy ) || !IsAlive( current_enemy ) )
		{
			if ( IsDefined( self.enemy ) && self CanSee( self.enemy ) && IsAlive( self.enemy ) )
			{
				current_enemy = self.enemy;
			}
		}
		
		if ( IsDefined( current_enemy ) )
		{
			shoot_from_pos = self animscripts\shared::getShootFromPos();
			target_pos = current_enemy GetShootAtPos();
				
			to_target_pos = target_pos - shoot_from_pos;
			aim_angles = VectorToAngles( to_target_pos );
				
			on_target = self aim_burke_at_angles( aim_angles, 48 );
			if ( on_target )
			{
				burst_number = RandomIntRange( 2, 4 );
				for ( i = 0; i < burst_number; i++ )
				{
					self burke_burst_shoot( current_enemy );
					wait RandomFloatRange( 0.2, 0.4 );
				}
				
				wait RandomFloatRange( 3, 5 );
			}
		}
		
		if ( cointoss() )
		{
			current_enemy = undefined;
		}
		
		wait 0.05;
	}
}

setup_burke_aim_anims()
{
	self ClearAnim( %root, 0.2 );
	self SetAnim( %fusion_fly_in_burke_aim_5, 1, 0.2, 1 );
	
	self SetAnimLimited( %fusion_fly_in_burke_aim_4, 1, 0, 1 );
	self SetAnimLimited( %fusion_fly_in_burke_aim_6, 1, 0, 1 );
	self SetAnimLimited( %fusion_fly_in_burke_aim_2, 1, 0, 1 );
	self SetAnimLimited( %fusion_fly_in_burke_aim_8, 1, 0, 1 );
	
	self SetAnimLimited( %burke_aim_4, 0, 0, 1 );
	self SetAnimLimited( %burke_aim_6, 0, 0, 1 );
	self SetAnimLimited( %burke_aim_2, 0, 0, 1 );
	self SetAnimLimited( %burke_aim_8, 0, 0, 1 );
	
	self SetAnim( %fusion_fly_in_burke_aim_idle, 1, 0, 1 );
}

aim_burke_at_angles( aim_angles, aim_range )
{
	aim_on_target = true;
	
	if ( !IsDefined( self.last_pitch_aim ) )
	{
		self.last_pitch_aim = 0;
	}
	
	if ( !IsDefined( self.last_yaw_aim ) )
	{
		self.last_yaw_aim = 0;
	}
	
	pitch = AngleClamp180( aim_angles[0] - self.angles[0] );
	if ( abs(pitch) > aim_range )
		pitch = 0;
	
	pitch_weight = pitch / aim_range;
	pitch_delta = pitch_weight - self.last_pitch_aim;
	if ( abs( pitch_delta ) > 0.2 )
	{
		aim_on_target = false;
		pitch_delta = clamp( pitch_delta, -0.2, 0.2 );
		pitch_weight = self.last_pitch_aim + pitch_delta;
	}
	
	if ( pitch_weight < 0 )
	{
		self SetAnimLimited( %burke_aim_8, abs(pitch_weight), 0.2, 1 );
		self SetAnimLimited( %burke_aim_2, 0, 0.2, 1 );
	}
	else
	{
		self SetAnimLimited( %burke_aim_8, 0, 0.2, 1 );
		self SetAnimLimited( %burke_aim_2, pitch_weight, 0.2, 1 );
	}
	
	yaw = AngleClamp180( aim_angles[1] - self.angles[1] );
	if ( abs(yaw) > aim_range )
		yaw = 0;
	
	yaw_weight = yaw / aim_range;
	yaw_delta = yaw_weight - self.last_yaw_aim;
	if ( abs( yaw_delta ) > 0.2 )
	{
		aim_on_target = false;
		yaw_delta = clamp( yaw_delta, -0.2, 0.2 );
		yaw_weight = self.last_yaw_aim + yaw_delta;
	}
	
	if ( yaw_weight < 0 )
	{
		self SetAnimLimited( %burke_aim_6, abs(yaw_weight), 0.2, 1 );
		self SetAnimLimited( %burke_aim_4, 0, 0.2, 1 );
	}
	else
	{
		self SetAnimLimited( %burke_aim_6, 0, 0.2, 1 );
		self SetAnimLimited( %burke_aim_4, yaw_weight, 0.2, 1 );
	}
	
	self.last_pitch_aim = pitch_weight;
	self.last_yaw_aim = yaw_weight;
	
	return aim_on_target;
}

burke_burst_shoot( current_enemy )
{
	burst_fire_shots = RandomIntRange( 2, 4 );
	for ( i = 0; i < burst_fire_shots; i++ )
	{
		self shoot();
		self SetAnimRestart( %fusion_fly_in_burke_fire, 1, 0, 1 );
		wait 0.1;
	}
}


start_rooftop_combat()
{
	flag_set( "flag_combat_zip_rooftop_start" );
	autosave_by_name();
	
	wait 2;
	
	level.player EnableWeapons();
	while ( !(level.player EnableHybridSight( true )) )
		wait 0.05;
}

rooftop_strafe()
{
	node = getstruct( "path_rooftop_strafe", "targetname" );
	level.heli_squad_01 thread vehicle_dynamicpath( node, false );
	level.heli_squad_01 SetMaxPitchRoll ( 10, 10 );
	
	flag_wait_or_timeout( "flag_player_cleared_rooftop", 15.0 );
	
	flag_set( "flag_rooftop_strafe" );
	level.heli_squad_01 snd_message( "rooftop_strafe_start" );
	
		level.heli_squad_01 thread warbird_shooting_think( true );
	
		wait 1;
	
		level.heli_squad_01 notify( "warbird_fire" );
	
		flag_wait( "flag_combat_zip_rooftop_complete" );
	
	level.heli_squad_01 notify( "warbird_stop_firing" );
	}

delete_rooftop_los_blockers()
{
	blockers = GetEntArray( "street_rooftop_los_blocker", "targetname" );
	
	foreach( blocker in blockers )
	{
		blocker delete();
	}
}

allow_player_zip()
{
	wait 8.9;
	flag_wait( "flag_combat_zip_rooftop_complete" );
	flag_set( "player_can_zip" );
}

burke_fastzip_scene( org, warbird_a )
{
	flag_wait( "flag_burke_zip" );
	
	// stop fly in end idle
	warbird_a notify( "stop_idle" );
	org notify( "stop_idle" );
	
	thread burke_fastzip_aim_turret( warbird_a, "tag_turret_zipline_fl" );
	
	burke_zip_gun = warbird_a.zipline_gun_model["tag_turret_zipline_fl"];
	burke_zip_gun Unlink();
	level.burke Unlink();
	
	// initialize burke and give him a goal before the fast zip animation
	//   so he transitions smoothly to run
	level.burke = level.burke;
	thread burke_rally_init();
	
	thread allow_player_zip();
	
	level.burke anim_stopanimscripted();
	org thread anim_single_solo_run( level.burke, "burke_intro_zip" );
	guys = [ warbird_a, burke_zip_gun ];
	org anim_single( guys, "burke_intro_zip" );
	
	flag_set( "burke_fastzip_done" );
	
	guys_loop = [ warbird_a, burke_zip_gun ];
	org thread anim_loop( guys_loop, "burke_intro_zip_loop", "stop_loop" );
	
	thread heroes_post_zip();
	thread allies_rally_init();
	
	flag_wait( "player_fly_in_done" );
	
	org notify( "stop_loop" );
	
	burke_zip_gun LinkTo( warbird_a, "tag_turret_zipline_fl", ( 0, 0, 0 ), ( 0, 0, 0 ) );
}

#using_animtree( "script_model" );
burke_fastzip_aim_turret( warbird_a, turret_tag )
{
	zipline_gun_model = warbird_a.zipline_gun_model[ turret_tag ];
	heli_turret_rope = warbird_a vehicle_scripts\_xh9_warbird::spawn_zipline_turret( "zipline_gun_rope", turret_tag, zipline_gun_model.rope_model, "_turret_fastzip" );
	heli_turret_rope Hide();
	
	ground_target = spawn_tag_origin();
	ground_target.origin = zipline_gun_model GetTagOrigin( "jnt_harpoon" );
	heli_turret_rope SetTargetEntity( ground_target );
	
	while ( !flag( "burke_fastzip_done" ) )
	{
		ground_target.origin = zipline_gun_model GetTagOrigin( "jnt_harpoon" );
		wait 0.1;
	}
	
	ground_target.origin = zipline_gun_model GetTagOrigin( "jnt_harpoon" );
	
	start = zipline_gun_model GetTagOrigin( "tag_flash" );
	dist = Distance( start, ground_target.origin ) / 12; //units to feet... ish
	AssertEx( dist <= 200, "distance is longer than the rope" );
	percent_of_anim = dist / 200;
	rope_anim = %fastzip_launcher_fire_right;
	heli_turret_rope SetAnimKnob( rope_anim, 1, 0, 0 );
	heli_turret_rope SetAnimTime( rope_anim, percent_of_anim );
	
	if ( IsDefined( zipline_gun_model.rope_model ) )
	{
		zipline_gun_model Detach( zipline_gun_model.rope_model );
	}
	heli_turret_rope Show();
	
	heli_turret_rope maps\_player_fastzip::retract_rope( dist, "right" );
	
	ground_target Delete();
	
	flag_wait( "player_fly_in_done" );
	heli_turret_rope Delete();
}

burke_rally_init()
{
	level.burke set_force_color( "g" );
	level.burke disable_ai_color();
	goal_node_burke = GetNode("node_cover_burke_after_zip", "targetname");
	level.burke goto_node(goal_node_burke, false);
		
	thread courtyard_burke_rally();
}

allies_rally_init()
{
	level.joker disable_ai_color();
	goal_node_joker = GetNode("node_cover_joker_after_zip", "targetname");
	level.joker goto_node(goal_node_joker, false);
}


/*
squad_fly_in()
{
	level.player endon( "death" );
	
	heli_1 = spawn_vehicle_from_targetname( "squad_blackhawk" );
	heli_1 setmaxpitchroll( 25, 45 );
	
	heli_2 = spawn_vehicle_from_targetname( "squad_heli_2" );spawn_looping_jets
	heli_2 setmaxpitchroll( 25, 45 );
	
	flag_wait( "start_heli_fly" );
	
	heli_1 thread gopath();
	heli_2 thread gopath();
	
	flag_wait( "buddy_chopper_explode" );
		
	PlayFxOnTag( getfx( "generic_explosion" ), heli_1, "tag_origin" );
	heli_1 kill();
	//heli_1 notify( "death" );
}
*/

move_squad_and_walkers()
{
	level.player endon( "death" );
	
	flag_wait( "ready_zip" );
	activate_trigger_with_targetname( "trig_move_squad_from_heli" );
}

setup_m_turret()
{
	set_player_rig_spawn_function( ::spawn_player_anim_rig );
	
	if (level.currentgen)
	{
		// do not spawn vehicles after security_room point to avoid issues with transient fast files
		if (level.start_point != "fly_in_animated" &&
		   	level.start_point != "fly_in_animated_part2" &&
		   	level.start_point != "courtyard" &&
		   	level.start_point != "security_room")
			return;
	}
	
	turrets = GetEntArray( "mobile_turret", "targetname" );
	turret_vehicles = [];
	foreach( turret in turrets )
	{
		turret_vehicle = turret spawn_vehicle();
		turret_vehicle thread monitor_mobile_turret_health();
		turret_vehicle thread manage_mobile_turret_usability();
		turret_vehicle thread disable_cover_drone_on_mobile_turret_mount();
		turret_vehicle.godmode = true;
		turret_vehicles[turret_vehicles.size] = turret_vehicle;
	}
	
	if (level.currentgen)
	{
		level waittill("street_cleanup");
		array_call(turret_vehicles, ::Delete);
	}
}

disable_cover_drone_on_mobile_turret_mount()
{
	level.player endon( "death" );
	
	while ( true )
	{
		level.player waittill( "player_starts_entering_mobile_turret" );
		level.player.disable_cover_drone = true;
		level.player waittill( "player_exited_mobile_turret" );
		level.player.disable_cover_drone = undefined;
	}
}

// hack to make mobile turret unusable while on cover drone
manage_mobile_turret_usability()
{
	self endon( "death" );
	
	waittillframeend;
	
	self.use_semaphore = 0;
	self thread monitor_cover_drone_hint();
	self thread monitor_cover_drone_link();
	
	while ( true )
	{
		self waittill( "use_changed" );
		
		if ( self.use_semaphore > 0 )
		{
			self vehicle_scripts\_x4walker_wheels_turret::make_mobile_turret_unusable();
		}
		else if ( self.use_semaphore == 0 )
		{
			self vehicle_scripts\_x4walker_wheels_turret::make_mobile_turret_usable();
		}
		else
		{
			AssertMsg( "Mobile cover sent more messages than expected?" );
		}
	}
}

monitor_cover_drone_link()
{
	self endon( "death" );
	
	while ( true )
	{
		level.player waittill( "player_linked_to_cover" );
		self.use_semaphore++;
		self notify( "use_changed" );
		level.player waittill( "player_unlinked_from_cover" );
		self.use_semaphore--;
		self notify( "use_changed" );
	}
}

monitor_cover_drone_hint()
{
	self endon( "death" );
	
	while ( true )
	{
		level.player waittill( "showing_cover_drone_hint", cover_drone );
		self.use_semaphore++;
		self notify( "use_changed" );
		
		self thread wait_for_hint_hide( cover_drone );
	}
}

wait_for_hint_hide( cover_drone )
{
	self endon( "death" );
	while ( true )
	{
		message_drone = wait_for_drone_message_or_death( cover_drone );
		if ( !IsDefined( message_drone ) || message_drone == cover_drone )
		{
			self.use_semaphore--;
			self notify( "use_changed" );
			return;
		}
	}
}

wait_for_drone_message_or_death( cover_drone )
{
	cover_drone endon( "death" );
	level.player waittill( "hiding_cover_drone_hint", message_drone );
	return message_drone;
}

setup_personal_drone()
{
	player_drone_spawner = GetEnt( "player_pdrone", "targetname" );
	level.player thread maps\_weapon_pdrone::give_player_pdrone( player_drone_spawner );
}

setup_ally_squad()
{
	flag_wait( "street_combat_start" );
	
	spawners = GetEntArray( "allies_street", "script_noteworthy" );
	
	foreach( spawner in spawners )
	{
		if(IsDefined(spawner))
			spawner spawn_ai(true);
	}
	
	guys = GetAIArray( "allies" );
	
	foreach( guy in guys )
	{
		if(IsDefined(guy))
		{
			if(!IsDefined(guy.magic_bullet_shield))
			{
				guy thread deletable_magic_bullet_shield();
			}
			guy.disableFriendlyFireReaction = true;
		}
	}
}

road_battle_setup()
{	
	thread setup_triggers_street_battle();
	thread setup_cover_nodes_street();

	thread combat_zip_rooftop();	
	flag_wait( "street_combat_start" );
	
	thread biasgroup_think();
	thread moblie_turrets_intro();
	thread personal_drone_spline();
	thread street_volume_manager();
	thread combat_street_wave_01();
	thread combat_street_wave_02();
	thread combat_street_wave_03();
	thread combat_street_blown_building();
	thread combat_player_in_m_turret();
	thread combat_street_wave_04();
	thread combat_street_initial();
	thread combat_street_wave_rear();
	thread combat_enemy_trans_heli_wave_01();
	thread combat_enemy_tank();
	thread rpg_at_heli();
	thread wall_explosion_01();
	thread building_explosion_01();
	thread courtyard_mobile_cover_guys();
	thread street_mobile_cover_guys();
	thread mobile_turret_dropoff();
	thread smaw_laser_think();
}
	
biasgroup_think()
{
	level.player setthreatbiasgroup( "player" );
	
	CreateThreatBiasGroup( "drones" );
	// enemies less likely to target pdrones
	SetThreatBias( "drones", "axis_street", -20000 );
	
	flag_wait( "flag_enemy_bullet_shield_off" );
	
	// make enemies go after the player 
	setthreatbias( "player", "axis_street", 8000 );
	
	flag_wait( "flag_enemy_walker" );
	
	setthreatbias( "player", "axis_street", 0 );
}

setup_triggers_street_battle()
{
	trigger_street_end = getent( "color_t_street_end", "targetname" );
	trigger_street_end trigger_off();
	
	trigger_walker = getent( "color_t_walker_destroyed", "targetname" );
	trigger_walker trigger_off();
	
	trigger_mt = getent( "color_t_mt_destroyed", "targetname" );
	trigger_mt trigger_off();
	
	flag_wait_all( "flag_mt_wall_rpg_impact", "flag_mt_move_up_02" );

	wait 1;
	trigger_mt trigger_on();
	activate_trigger_with_targetname( "color_t_mt_destroyed" );
	
	trigger_bcs_titan = GetEntArray( "bcs_titan", "targetname" );
	foreach( trigger in trigger_bcs_titan )
	{
		trigger trigger_off();
	}
	
	flag_wait( "flag_enemy_walker" );
	
	wait 3;
	
	foreach( trigger in trigger_bcs_titan )
	{
		trigger trigger_on();
	}
	
	trigger_bcs_hill = GetEntArray( "bcs_hill", "targetname" );
	foreach( trigger in trigger_bcs_hill )
	{
		trigger trigger_off();
	}
}

setup_cover_nodes_street()
{
	nodes = GetNodeArray( "cover_node_walker_hill", "targetname" );
	foreach( cover_node in nodes )
	{
		cover_node DisconnectNode();
	}
	
	flag_wait( "flag_enemy_walker" );
	foreach( cover_node in nodes )
	{
		cover_node ConnectNode();
	}
}

moblie_turrets_intro()
{
	turret_2 = spawn_vehicle_from_targetname( "ally_walker_02" );
	turret_2 thread kill_path_on_death();
	turret_2 snd_message("spawn_ally_walker_02");
	
	turret_2 godon();
	
	flag_wait( "ready_zip" );
	
	// remove magic bullet shield on turret drivers so turrets can be destroyed
	turrets = [ turret_2 ];
	foreach ( turret in turrets )
	{
		if ( IsDefined( turret.riders ) )
		{
			foreach ( rider in turret.riders )
			{
				if ( IsDefined( rider.deletable_magic_bullet_shield ) )
					rider stop_magic_bullet_shield();
			}
		}
	}
	
	turret_2 delayThread( 2, ::mobile_turret_gopath );
	
	flag_wait( "flag_mt_move_up_03" );
	turret_2 godoff();
	
	if (level.currentgen)
	{
		level waittill("street_cleanup");
		turret_2 Delete();
	}
}

mobile_turret_gopath()
{
	self endon( "death" );
	self gopath();
	
	wait 0.1;
	
	// stop when pushing the player
	while ( true )
	{
		level.player waittill_pushed_by( self );
		
		self Vehicle_SetSpeed( 0, 60, 60 );
			
		touch_distance = DistanceSquared( level.player.origin, self.origin );
		move_again_distance = touch_distance * 2;
		while ( touch_distance < move_again_distance )
		{
			wait 0.1;
			touch_distance = DistanceSquared( level.player.origin, self.origin );
		}

		self ResumeSpeed( 1 );
	}
}

waittill_pushed_by( pushing_entity )
{
	self thread monitor_player_pushed( pushing_entity );
	self thread monitor_player_unresolved( pushing_entity );
	self thread monitor_player_pushed_while_linked( pushing_entity );
	
	while ( true )
	{
		self waittill( "notify_push", pusher );
		if ( pushing_entity == pusher )
		{
			break;
		}
	}
	
	self notify( "kill_push_monitor" );
}

monitor_player_pushed( pushing_entity )
{
	self endon( "kill_push_monitor" );
	pushing_entity endon( "death" );
	while ( true )
	{
		self waittill( "player_pushed", displacement, pusher );
		self notify( "notify_push", pusher );
	}
}

monitor_player_unresolved( pushing_entity )
{
	self endon( "kill_push_monitor" );
	pushing_entity endon( "death" );
	while ( true )
	{
		self waittill( "unresolved_collision", pusher );
		self notify( "notify_push", pusher );
	}
}

monitor_player_pushed_while_linked( pushing_entity )
{
	self endon( "kill_push_monitor" );
	pushing_entity endon( "death" );
	
	while( true )
	{
		dist = 200;
		angle = 80;
		cos_angle = Cos( angle );
		
		while( self IsLinked() )
		{
			forward = AnglesToForward( pushing_entity.angles );
			player_to_ent = VectorNormalize( level.player.origin - pushing_entity.origin );
			
			if( VectorDot( forward, player_to_ent ) >= cos_angle && Distance( self.origin, pushing_entity.origin ) < dist )
			{
				self notify( "notify_push", pushing_entity );
				return;
			}
			
			wait( 0.1 );
		}
		
		wait( 0.05 );
	}
}

monitor_turret_2_death()
{
	self waittill ( "death" );
	flag_set( "flag_m_turret_dead" );
}

personal_drone_spline()
{
	flag_wait( "flag_ambient_p_drones_01" );

	thread spawn_looping_drone ( "p_drone_spline_01" ); //TODO: verify drones are deleted when done
	thread spawn_looping_drone ( "p_drone_spline_03" );
	if (level.nextgen)
	{
		thread spawn_looping_drone ( "p_drone_spline_02" );
		thread spawn_looping_drone ( "p_drone_spline_04" );
	}
}

spawn_looping_drone( tname )
{
	while( !flag( "flag_obj_01_pos_update_02" ) )
	{
		drone = spawn_vehicle_from_targetname_and_drive( tname );
		drone MakeEntitySentient( "allies" );
		drone SetThreatBiasGroup( "drones" );
		drone waittill( "death" );
	}
}

rooftop_enemy_think()
{
	Assert(IsAI(self));
	self endon( "death" );
	
	self set_baseaccuracy (.5);
	self disable_grenades();
	self disable_long_death();
	
	flag_wait( "flag_combat_zip_rooftop_complete" );
	
	self bloody_death ( 2 );
}

street_enemy_think()
{
	Assert(IsAI(self));
	self endon( "death" );
	
	self setthreatbiasgroup( "axis_street" );
	
	volume_1 = getent( "vol_street_battle_01_left", "targetname" );
	volume_2 = getent( "vol_street_battle_01_right", "targetname" );
	volumes = [ volume_1, volume_2 ];
	self street_set_volume_from_pair( volumes );
	
	flag_wait( "flag_mt_move_up_03" );
	
	volume_1 = getent( "vol_street_battle_02_left", "targetname" );
	volume_2 = getent( "vol_street_battle_02_right", "targetname" );
	volumes = [ volume_1, volume_2 ];
	self street_set_volume_from_pair( volumes );
	
	flag_wait( "flag_mt_move_up_05" );
	
	volume_1 = getent( "vol_street_battle_03_left", "targetname" );
	volume_2 = getent( "vol_street_battle_03_right", "targetname" );
	volumes = [ volume_1, volume_2 ];
	self street_set_volume_from_pair( volumes );
	
	flag_wait( "flag_obj_01_pos_update_02" );
	
	volume_1 = getent( "vol_street_battle_reactor_entrance_left", "targetname" );
	volume_2 = getent( "vol_street_battle_reactor_entrance_right", "targetname" );
	volumes = [ volume_1, volume_2 ];
	self street_set_volume_from_pair( volumes );
	
	flag_wait( "flag_walker_destroyed" );
		
	self ClearGoalVolume();
	self SetGoalVolumeAuto ( getent( "vol_street_battle_reactor_entrance", "targetname" ) );
	
	flag_wait( "flag_player_at_reactor_entrance" );
	
	self ClearGoalVolume();
	self SetGoalVolumeAuto ( getent( "vol_street_battle_reactor_entrance_end", "targetname" ) );
}

street_enemy_blown_building_think()
{
	Assert(IsAI(self));
	self endon( "death" );
	
	self setthreatbiasgroup( "axis_street" );
	
	self ClearGoalVolume();
	self SetGoalVolumeAuto ( getent( "vol_street_battle_02_left", "targetname" ) );
	
	flag_wait( "flag_spawn_gaz_01" );
	
	volume_1 = getent( "vol_street_battle_03_left", "targetname" );
	volume_2 = getent( "vol_street_battle_03_right", "targetname" );
	volumes = [ volume_1, volume_2 ];
	self street_set_volume_from_pair( volumes );
	
	flag_wait( "flag_obj_01_pos_update_02" );
	
	volume_1 = getent( "vol_street_battle_reactor_entrance_left", "targetname" );
	volume_2 = getent( "vol_street_battle_reactor_entrance_right", "targetname" );
	volumes = [ volume_1, volume_2 ];
	self street_set_volume_from_pair( volumes );
	
	flag_wait( "flag_walker_destroyed" );
		
	self ClearGoalVolume();
	self SetGoalVolumeAuto ( getent( "vol_street_battle_reactor_entrance", "targetname" ) );
	
	flag_wait( "flag_player_at_reactor_entrance" );
	
	self ClearGoalVolume();
	self SetGoalVolumeAuto ( getent( "vol_street_battle_reactor_entrance_end", "targetname" ) );
}

street_volume_manager()
{
	volume_1 = getent( "vol_street_battle_01_left", "targetname" );
	volume_2 = getent( "vol_street_battle_01_right", "targetname" );
	volumes = [ volume_1, volume_2 ];
	street_enemy_movement( "flag_mt_move_up_03", 2, 5, volumes );
	
	volume_1 = getent( "vol_street_battle_02_left", "targetname" );
	volume_2 = getent( "vol_street_battle_02_right", "targetname" );
	volumes = [ volume_1, volume_2 ];
	street_enemy_movement( "flag_mt_move_up_05", 2, 5, volumes );
	
	volume_1 = getent( "vol_street_battle_03_left", "targetname" );
	volume_2 = getent( "vol_street_battle_03_right", "targetname" );
	volumes = [ volume_1, volume_2 ];
	street_enemy_movement( "flag_obj_01_pos_update_02", 2, 5, volumes );
	
	volume_1 = getent( "vol_street_battle_reactor_entrance_left", "targetname" );
	volume_2 = getent( "vol_street_battle_reactor_entrance_right", "targetname" );
	volumes = [ volume_1, volume_2 ];
	street_enemy_movement( "flag_walker_destroyed", 8, 20, volumes );
}

street_set_volume_from_pair( volumes )
{
	if( !isDefined( volumes ) )
		return;
	
	volume = undefined;
	
	if( isArray( volumes ) )
	{
		if( cointoss() )
		{
			volume = volumes[ 0 ];
			
			if( self IsTouching( volume ) )
			{
				volume = volumes[ 1 ];
			}
		}
		else
		{
			volume = volumes[ 1 ];
			
			if( self IsTouching( volume ) )
			{
				volume = volumes[ 0 ];
			}
		}
	}
	
	if( isDefined( volume ) )
	{
		self ClearGoalVolume();
		self SetGoalVolumeAuto( volume );
	}
}

street_enemy_movement( msg, min_time, max_time, volumes )
{
	level.player endon( "death" );
	level endon( msg );
	
	AssertEx( IsDefined( msg ), "you must specify an end flag for street_enemy_movement" );
	AssertEx( IsDefined( msg ), "you must specify which volumes you want the ai to run between" );
	
	if( !isDefined( min_time ) )
	{
		min_time = 5;
	}
	
	if( !isDefined( max_time ) )
	{
		max_time = 15;
	}
	
	while( !flag( msg ) )
	{
		wait( RandomFloatRange( min_time, max_time ) );
		{
			guys = [];
			foreach( volume in volumes )
			{
				volume_guys = volume get_ai_touching_volume( "axis" );
				if(volume_guys.size > 0)
				{
					guys = array_combine( guys, volume_guys );
				}
			}
			if(guys.size > 0)
			{
				guy = guys[ RandomInt( guys.size ) ];
				//guy thread mover_debug_text();
				guy street_set_volume_from_pair( volumes );
			}
		}
	}
}

mover_debug_text()
{
	self endon( "death" );

	counter = 5;
	
	while( counter > 0 )
	{
		print3d( self.origin + ( 0, 0, 80 ), "MOVER", ( 1, 1, 1 ), 1, 1, 1 );
		counter -= 0.05;
		wait( 0.05 );
	}
}

street_enemy_tank_battle_think()
{
	Assert(IsAI(self));
	self endon( "death" );
	
	self SetGoalVolumeAuto ( getent( "vol_street_tank_stage_01", "targetname" ) );
	
	flag_wait( "flag_walker_destroyed" );
	
	self ClearGoalVolume();
	self SetGoalVolumeAuto ( getent( "vol_street_battle_reactor_entrance", "targetname" ) );
	
	flag_wait( "flag_player_at_reactor_entrance" );
	
	self ClearGoalVolume();
	self SetGoalVolumeAuto ( getent( "vol_street_battle_reactor_entrance_end", "targetname" ) );
}

street_enemy_tank_damaged_think()
{
	Assert(IsAI(self));
	self endon( "death" );
		
	flag_wait( "walker_damaged" );
	
	self ClearGoalVolume();
	self SetGoalVolumeAuto ( getent( "vol_street_battle_reactor_entrance", "targetname" ) );
	
	flag_wait( "flag_player_at_reactor_entrance" );
	
	self ClearGoalVolume();
	self SetGoalVolumeAuto ( getent( "vol_street_battle_reactor_entrance_end", "targetname" ) );
}
	
street_enemy_building_east_think()
{
	Assert(IsAI(self));
	self endon( "death" );
	
	self SetGoalVolumeAuto ( getent( "vol_street_battle_rear_building_east", "targetname" ) );
		
	flag_wait( "flag_obj_01_pos_update_02" );
	
	self ClearGoalVolume();
	self SetGoalVolumeAuto ( getent( "vol_street_battle_reactor_entrance", "targetname" ) );
	
	flag_wait( "flag_player_at_reactor_entrance" );
	
	self ClearGoalVolume();
	self SetGoalVolumeAuto ( getent( "vol_street_battle_reactor_entrance_end", "targetname" ) );
}

street_enemy_building_west_think()
{
	Assert(IsAI(self));
	self endon( "death" );
	
	self SetGoalVolumeAuto ( getent( "vol_street_battle_rear_building_west", "targetname" ) );
		
	flag_wait( "flag_obj_01_pos_update_02" );
	
	self ClearGoalVolume();
	self SetGoalVolumeAuto ( getent( "vol_street_battle_reactor_entrance", "targetname" ) );
	
	flag_wait( "flag_player_at_reactor_entrance" );
	
	self ClearGoalVolume();
	self SetGoalVolumeAuto ( getent( "vol_street_battle_reactor_entrance_end", "targetname" ) );
}

combat_street_wave_01()
{
	spawners = getentarray( "enemy_street_wave_01", "script_noteworthy" );
	
	if(spawners.size > 0)
 	{
		maps\_spawner::flood_spawner_scripted( spawners );
	}
	
	foreach(guy in GetEntArray("enemy_street_wave_01", "script_noteworthy"))
	{
		if(IsAlive(guy))
		{
			guy deletable_magic_bullet_shield();	
		}	
	}
	
	flag_wait( "flag_enemy_bullet_shield_off" );
	
	foreach(guy in GetEntArray("enemy_street_wave_01", "script_noteworthy"))
	{
		if(IsAlive(guy))
		{
			guy stop_magic_bullet_shield();	
		}	
	}
	
	flag_wait( "flag_mt_move_up_03" );
	
	spawners = ["enemy_street_wave_01"];
	delete_spawners(spawners);
}

combat_street_wave_02()
{
	flag_wait( "flag_mt_move_up_01" );
	
	spawners = getentarray( "enemy_street_wave_02", "script_noteworthy" );
	
	if(spawners.size > 0)
 	{
		maps\_spawner::flood_spawner_scripted( spawners );
	}
	
	spawners = getentarray( "enemy_street_wave_mobile_cover_a", "script_noteworthy" );
	
	foreach( spawner in spawners )
	{
		spawner spawn_ai(true);
	}
	
	flag_wait( "flag_mt_move_up_02" );
	
	spawners = getentarray( "enemy_street_wave_mobile_cover_b", "script_noteworthy" );
	
	foreach( spawner in spawners )
	{
		spawner spawn_ai(true);
	}
	
	flag_wait( "flag_delete_spawners_wave_02" );
	
	spawners = ["enemy_street_wave_02"];
	delete_spawners(spawners);
}

combat_street_wave_03()
{
	flag_wait( "flag_delete_spawners_wave_02" );
	
	spawners = getentarray( "enemy_street_wave_03", "script_noteworthy" );
	
	if(spawners.size > 0)
 	{
		maps\_spawner::flood_spawner_scripted( spawners );
	}
	
	flag_wait( "flag_enemy_reinforcements_big_wave" );
	
	enemy_trans_street_01 = spawn_vehicle_from_targetname_and_drive( "enemy_trans_street_01" );
	enemy_trans_street_01 thread heli_turret_death_think();
	snd_message( "courtyard_mi17_spawn_01", enemy_trans_street_01);
	
	enemy_trans_street_02 = spawn_vehicle_from_targetname_and_drive( "enemy_trans_street_02" );
	enemy_trans_street_02 thread heli_turret_death_think();
	snd_message( "courtyard_mi17_spawn_02", enemy_trans_street_02);
	
	flag_wait( "flag_mt_move_up_03" );
	
	spawners = ["enemy_street_wave_03"];
	delete_spawners(spawners);
}

combat_street_blown_building()
{
	flag_wait( "flag_combat_blown_building" );
	
	if( !flag( "flag_delete_spawners_wave_02" ) )
	{		
		spawners = getentarray( "enemy_street_blown_building", "script_noteworthy" );
			
		if(spawners.size > 0)
	 	{
			maps\_spawner::flood_spawner_scripted( spawners );
		}
	}
	
	flag_wait( "flag_slow_explosions_2" );
	
	spawners = ["enemy_street_blown_building"];
	delete_spawners(spawners);
}

heli_turret_death_think()
{
	level.player endon( "death" );
	level endon( "street_cleanup" );
	
	self waittill( "death", attacker );
	
	if( isPlayer( attacker ) && isDefined( attacker.drivingVehicleAndTurret ) )
	{
		wait( 0.05 );
		self notify( "crash_done" );
	}
}

combat_player_in_m_turret()
{
	level endon( "street_cleanup" );
	
	level.player waittill( "player_enters_mobile_turret" );
	
	thread hint_mt_controls();
	
	delayThread(2, ::autosave_now);
	
	spawners_1 = getentarray( "enemy_street_turret_wave_1", "script_noteworthy" );
	
	if(spawners_1.size > 0)
 	{
		maps\_spawner::flood_spawner_scripted( spawners_1 );
	}
	
	spawners_2 = getentarray( "enemy_street_turret_wave_2", "script_noteworthy" );
	
	if(spawners_2.size > 0)
 	{
		maps\_spawner::flood_spawner_scripted( spawners_2 );
	}
		
	flag_wait( "walker_damaged" );
	
	spawners_1 = ["enemy_street_turret_wave_1"];
	delete_spawners(spawners_1);
	
	spawners_2 = ["enemy_street_turret_wave_2"];
	delete_spawners(spawners_2);
}

hint_mt_controls()
{
	display_hint( "hint_mt_fire_gun" );
	
	wait 1.0;
	
	display_hint( "hint_mt_fire_missiles" );
}

monitor_mobile_turret_health()
{
	//self is a mobile turret
	level.player endon( "death" );
	level endon( "street_cleanup" );
	
	level.player waittill( "player_starts_entering_mobile_turret" );
	flag_set( "flag_player_starts_entering_mobile_turret" );
	
	level.player waittill( "player_enters_mobile_turret" );
	flag_set( "flag_player_enters_mobile_turret" );
	
	thread mobile_turret_tutorial_hints();
	
	fx_locators = getentarray( "mobile_turret_damage", "targetname" );
	foreach( locator in fx_locators )
	{
		locator linkto( self );
	}
	
	trigger = getent( "trig_mobile_turret_health_1", "targetname" );
	trigger mobile_turret_health_think( self, ::mobile_turret_health_1 );
	
	trigger = getent( "trig_mobile_turret_health_2", "targetname" );
	trigger mobile_turret_health_think( self, ::mobile_turret_health_2 );
	
	trigger = getent( "trig_mobile_turret_health_3", "targetname" );
	trigger mobile_turret_health_think( self, ::mobile_turret_health_3 );
	
	trigger = getent( "trig_mobile_turret_missile", "targetname" );
	trigger mobile_turret_health_think( self, ::mobile_turret_missile );
	
	//trigger = getent( "trig_mobile_turret_health_4", "targetname" );
	//trigger mobile_turret_health_think( self, ::mobile_turret_health_4 );
}

mobile_turret_tutorial_hints()
{
	
}

mobile_turret_health_think( walker, func )
{
	//self is a trigger
	level.player endon( "death" );
	walker endon( "death" );
	level endon( "street_cleanup" );
	
	while( true )
	{
		self waittill( "trigger", ent );
		if( ent == level.player && isDefined( walker.player_driver ) && walker.player_driver == level.player )
		{
			walker thread [[ func ]]();
			break;
		}
	}
}

mobile_turret_health_1()
{
	//self is a mobile turret
	self endon( "death" );
	self endon( "stop_mobile_turret_health_1" );
	
	//org = getent( "mobile_turret_locator_dashboard_left", "script_noteworthy" );
	
//	IPrintLn( "damage_state_1" );

	fx = "mobile_turret_smoke";
	tag = "TAG_SMOKE";

	play_and_store_fx_on_tag( fx, self, tag );
	
	
	/*while( true )
	{
		PlayFXOnTag( getfx( "mobile_turret_sparks" ), org, "tag_origin" );
		fx_delay = RandomFloatRange( 1.0, 2.5 );
		wait( fx_delay );
	}*/
}

mobile_turret_health_2()
{
	//self is a mobile turret
	self endon( "death" );
	self endon( "stop_mobile_turret_health_2" );
	
	//org = getent( "mobile_turret_locator_dashboard_right", "script_noteworthy" );
	
//	IPrintLn( "damage_state_2" );
	
	fx = "mobile_turret_sparks";
	tag_1 = "TAG_SPARKS_1";
	tag_2 = "TAG_SPARKS_2";
	
	play_and_store_fx_on_tag( fx, self, tag_1 );
	wait 0.1;
	play_and_store_fx_on_tag( fx, self, tag_2 );
	}

mobile_turret_health_3()
{
	//self is a mobile turret
	self endon( "death" );
	self endon( "stop_mobile_turret_health_3" );
	
	
	//org = getent( "mobile_turret_locator_turret", "script_noteworthy" );
	
//	IPrintLn( "damage_state_3" );
	
	//playFXonTag(getfx("mobile_turret_fire_small"), self.mgturret[0], "TAG_FIRE_1");
	/*while( true )
	{
		PlayFXOnTag( getfx( "mobile_turret_smoke" ), org, "tag_origin" );
		wait( 0.1 );
	}*/
}

mobile_turret_missile()
{
	//self is a mobile turret
	self endon( "death" );
	
	org = getstruct( "org_missile_disable_mt", "targetname" );
	end_pos = org.origin + ( AnglesToForward( org.angles ) * 256 );
	
	missile = MagicBullet( "mobile_turret_missile", org.origin, end_pos );
	missile Missile_SetTargetPos( self.mgturret[0] GetTagOrigin( "tag_flash" ) + AnglesToForward( self.mgturret[0].angles ) * 64 );
	missile Missile_SetFlightModeDirect();
	
	missile waittill( "death" );
	PlayFx( getfx( "rpg_explode" ), self.mgturret[0].origin );
	
	earthquake_origin = self.mgturret[0].origin;
	if ( IsDefined( self.player_driver ) )
	{
		earthquake_origin = self.player_driver.origin;
		thread flag_set_delayed( "flag_bailout_vo", 0.5 );
	}
	Earthquake( 2.0, 1.0, earthquake_origin, 256 );
	
	self thread mobile_turret_health_4();
}

mobile_turret_health_4()
{
	//self is a mobile turret
	
//	IPrintLn( "damage_state_4: immobilized" );
	
	self ent_flag_waitopen( "player_in_transition" );
	if ( IsDefined( level.player.drivingVehicleAndTurret ) )
	{
		level.player DriveVehicleAndControlTurretOff( self );
		self thread mobile_turret_burning();
		self.burning = true;
		
		fx = "mobile_turret_fire_large";
		tag = "TAG_FIRE_2";
		
		play_and_store_fx_on_tag( fx, self, tag );

	}
	else
	{
		self.burning = true;
		self destroy_mobile_turret();
	}
}

mobile_turret_burning()
{
	//self is a mobile turret
	self thread destroy_turret_when_player_leaves();
	
	level.player endon( "death" );
	level endon( "street_cleanup" );
	self endon( "dismount_vehicle_and_turret" );
	
	self notify( "play_damage_warning" );
	
	time = 20;
	
	wait( time );
	
	//destroy vehicle
	level.player DisableInvulnerability();
	level.player kill();
}

destroy_turret_when_player_leaves()
{
	level.player endon( "death" );
	level endon( "street_cleanup" );
	
	self waittill( "player_exited_mobile_turret" );

	self destroy_mobile_turret();
}

destroy_mobile_turret()
{
	level.player endon( "death" );
	level endon( "street_cleanup" );
	
	self vehicle_scripts\_x4walker_wheels_turret::make_mobile_turret_unusable();
	
	dist = 256;
	time = 20;
	
	while( Distance( self.origin, level.player.origin ) <  dist && time >= 0 )
	{
		time -= 0.05;
		wait( 0.05 );
	}
	
	//destroy vehicle
	self.mgturret[0] Hide();
	self SetModel( "vehicle_x4walker_wheels_dstrypv" );
	PlayFxOnTag( getfx( "mobile_turret_explosion" ), self, "tag_death_fx" );
	earthquake( 1, 1.6, self.origin, 625 );
	
	self snd_message( "player_mobile_turret_explo" );
	
	self notify( "stop_mobile_turret_health_1" );
	self notify( "stop_mobile_turret_health_2" );
	self notify( "stop_mobile_turret_health_3" );
	self notify( "stop_mobile_turret_health_4" );
	
	//turn on smoke to cover base of mobile turret
	wait 0.5;
	PlayFxOnTag( getfx( "mobile_turret_ground_smoke" ), self, "tag_death_fx" );
}

play_and_store_fx_on_tag( fx, ent, tag )
{
	PlayFXonTag( getfx( fx ), ent.mgturret[0], tag );
	
	fx_struct = SpawnStruct();
	fx_struct.name = fx;
	fx_struct.tag = tag;
	
	if( !isDefined( ent.damage_fx ) )
	   ent.damage_fx = [];
	   
	ent.damage_fx[ self.damage_fx.size ] = fx_struct;
}

combat_street_wave_04()
{
	flag_wait( "flag_delete_spawners_wave_02" );
	
	spawners = getentarray( "enemy_street_wave_04", "script_noteworthy" );
	
	if(spawners.size > 0)
 	{
		maps\_spawner::flood_spawner_scripted( spawners );
	}

	level waittill( "street_cleanup" );
	
	spawners = ["enemy_street_wave_04"];
	delete_spawners(spawners);
}

combat_street_wave_rear()
{
	if (level.currentgen)
		flag_wait( "flag_mt_move_up_05" );
	spawners = getentarray( "enemy_street_wave_rear", "script_noteworthy" );
	
	if(spawners.size > 0)
 	{
		maps\_spawner::flood_spawner_scripted( spawners );
	}
	
	foreach(guy in GetEntArray("enemy_street_wave_rear", "script_noteworthy"))
	{
		if(IsAlive(guy))
		{
			guy deletable_magic_bullet_shield();	
		}	
	}
	
	foreach(guy in GetEntArray("enemy_street_wave_rear", "script_noteworthy"))
	{
		if(IsAlive(guy))
		{
			guy stop_magic_bullet_shield();	
		}	
	}
	
	if (level.currentgen)
		flag_wait( "flag_walker_destroyed" );
	else
		flag_wait( "flag_mt_move_up_05" );
	
	spawners = ["enemy_street_wave_rear"];
	delete_spawners(spawners);
}

combat_enemy_tank()
{
	flag_wait( "walker_trophy_1" );
	
	spawners = getentarray( "enemy_street_tank_stage_01", "script_noteworthy" );
	
	if(spawners.size > 0)
 	{
		maps\_spawner::flood_spawner_scripted( spawners );
	}
	
	flag_wait( "walker_trophy_2" );
	
	thread rpg_at_squad_01();
	
	spawners = getentarray( "enemy_street_tank_stage_02", "script_noteworthy" );
	
	if(spawners.size > 0)
 	{
		maps\_spawner::flood_spawner_scripted( spawners );
	}
	
	flag_wait( "walker_damaged" );
	
	gaz = spawn_vehicle_from_targetname_and_drive( "enemy_m_turret_03" );
	
	level waittill( "street_cleanup" );
	
	spawners = ["enemy_street_tank_stage_01", "enemy_street_tank_stage_02"];
	delete_spawners(spawners);
	
	if (level.currentgen)
		gaz Delete();
}

combat_enemy_trans_heli_wave_01()
{
	flag_wait( "flag_mt_move_up_05" );
//	spawn_vehicle_from_targetname_and_drive( "enemy_trans_street_01" );
//	spawn_vehicle_from_targetname_and_drive( "enemy_trans_street_02" );
}

combat_zip_rooftop()
{
	flag_wait( "flag_combat_zip_rooftop_start" );
	//flag_set( "flag_rooftop_combat_dialogue" );  Moving this flag_set to fusion_aud.gsc in order to time this VO with the rest of the intro_fligth VO.  Swenson 10/12/12
	
	repulsor = Missile_CreateRepulsorEnt( level.warbird_a, 5000, 1000 );
	
	spawners = getentarray( "enemy_street_zip_rooftop", "script_noteworthy" );
	
	foreach( spawner in spawners )
	{
		spawner spawn_ai(true);
	}
	
	spawn_metrics_waittill_deaths_reach(4, [ "enemy_street_zip_rooftop" ], true);
	flag_set( "flag_burke_zip" );
	
	spawn_metrics_waittill_deaths_reach(6, [ "enemy_street_zip_rooftop" ], true);
	
	spawners = getentarray( "enemy_street_zip_rooftop_strafe", "script_noteworthy" );
	
	foreach( spawner in spawners )
	{
		spawner spawn_ai(true);
	}
	
	waittillframeend;
	
	if( !flag( "flag_rooftop_strafe" ))
	{
		flag_set( "flag_player_cleared_rooftop" );
	}
	
	spawn_metrics_waittill_deaths_reach(9, [ "enemy_street_zip_rooftop", "enemy_street_zip_rooftop_strafe" ], true);
	
	flag_set( "flag_combat_zip_rooftop_complete" );
	
	snd_music_message( "mus_combat_zip_rooftop_complete" );
}

combat_street_initial()
{	
	if (level.currentgen)
		flag_wait( "flag_spawn_gaz_01" );
	spawners = getentarray( "enemy_street_reactor_entrance", "script_noteworthy" );
		
	foreach( spawner in spawners )
	{
		if(IsDefined(spawner))
			spawner spawn_ai(true);
	}
	
	if (level.nextgen)
		flag_wait( "flag_spawn_gaz_01" );
	gaz_1 = spawn_vehicle_from_targetname_and_drive( "enemy_m_turret_02" );
	gaz_2 = spawn_vehicle_from_targetname_and_drive( "enemy_m_turret_01" );
	
	flag_wait( "flag_obj_01_pos_update_02" );
	spawners = ["enemy_street_reactor_entrance"];
	delete_spawners(spawners);
	
	if (level.currentgen)
	{
		level waittill( "street_cleanup" );
		gaz_1 Delete();
		gaz_2 Delete();
	}
}

rpg_at_heli()
{	
	flag_wait( "flag_rpg_at_heli" );
	
	wait 2.5;
	spawn_vehicle_from_targetname_and_drive( "rpg_at_heli" );
}

rpg_at_squad_01()
{	
	spawn_vehicle_from_targetname_and_drive( "rpg_at_squad_01" );
	
	wait 1;
	
	spawn_vehicle_from_targetname_and_drive( "rpg_at_squad_02" );
}

wall_explosion_01()
{
	decals = GetEntArray( "street_wall_1_decal", "targetname" );
	foreach( decal in decals)
	{
		decal hide();
	}
	
	flag_wait( "flag_mt_wall_rpg_fire" );
	
	rpg = spawn_vehicle_from_targetname_and_drive( "rpg_at_wall_01" );
		
	flag_wait( "flag_mt_wall_rpg_impact" );
	
	blocker = getent( "blocker_wall_1_explode", "targetname" );
	blocker delete();
	
	foreach( decal in decals)
	{
		decal show();
	}
	
	activate_trigger_with_targetname( "street_wall_1_explode" );
	fx = getstruct( "vfx_street_wall_1_explode", "targetname" );
	thread maps\fusion_lighting::firelight_volume();
	thread maps\fusion_lighting::firelight_volume2();
	//PlayFx( getfx( "mortar_explosion" ), fx.origin );
	snd_message( "street_wall_1_explode", fx.origin );
	RadiusDamage( fx.origin, 200, 200, 100, undefined, "MOD_EXPLOSIVE" );
	PhysicsExplosionSphere( fx.origin, 200, 10, 1 );
}

building_explosion_01()
{
	flag_wait( "flag_mt_move_up_05" );
	
	activate_trigger_with_targetname( "street_building_top_1_explode" );
	fx = getstruct( "vfx_street_building_1_explode", "targetname" );
	//PlayFx( getfx( "mortar_explosion" ), fx.origin );
	snd_message( "building_explode", fx.origin );
	RadiusDamage( fx.origin, 200, 200, 100, undefined, "MOD_EXPLOSIVE" );
	PhysicsExplosionSphere( fx.origin, 200, 10, 1 );
}

spawn_player_anim_rig()
{
	return spawn_anim_model( "player_rig", (0,0,0) );
}

courtyard_ambient_explosions()
{
	level.player endon( "death" );
	level endon( "start_itiot" );
	level endon( "street_cleanup" );
	
	flag_wait( "flag_ambient_explosions_start" ); //set from radiant. good enough for now.
	childthread courtyard_ambient_bullet_impacts();
	
	//commenting out ambient explosion threads below as the function now is in to fusion_fx.gsc
	//childthread courtyard_ambient_mortar_explosions();
	//childthread courtyard_ambient_smaller_explosions();
}

/*
courtyard_ambient_mortar_explosions()
{
	while( true )
	{
		min_time = 0.5;
		max_time = 1.0;
		
		if( flag( "flag_slow_explosions_1" ) )
		{
			min_time = 2.0;
			max_time = 4.0;
		}
		if( flag( "flag_slow_explosions_2" ) )
		{
			min_time = 3.0;
			max_time = 4.5;
		}
		
		wait( RandomFloatRange( min_time, max_time ) );
		
		forward = VectorNormalize( AnglesToForward( level.player.angles ) );
		right = VectorNormalize( AnglesToRight( level.player.angles ) );
		
		dummy = spawn( "script_origin", (0, 0, 0) );
		forward *= RandomIntRange( 256, 1500 );
		right *= RandomIntRange( -800, 800 );
		
		dummy.origin = level.player.origin + forward + right;
		PlayFx( getfx( "mortar_explosion" ), dummy.origin );
		RadiusDamage( dummy.origin, 200, 200, 100, undefined, "MOD_EXPLOSIVE" );
		PhysicsExplosionSphere( dummy.origin, 200, 10, 1 );
		play_sound_in_space( "mortar_explosion", dummy.origin );
		
		dummy Delete();
	}
}

courtyard_ambient_smaller_explosions()
{
	while( true )
	{
		min_time = 1.25;
		max_time = 1.75;
		
		if( flag( "flag_slow_explosions_1" ) )
		{
			min_time = 2.25;
			max_time = 2.75;
		}
		if( flag( "flag_slow_explosions_2" ) )
		{
			min_time = 3.25;
			max_time = 3.75;
		}
		
		wait( RandomFloatRange( min_time, max_time ) );
		
		forward = VectorNormalize( AnglesToForward( level.player.angles ) );
		right = VectorNormalize( AnglesToRight( level.player.angles ) );
		
		dummy = spawn( "script_origin", (0, 0, 0) );
		forward *= RandomIntRange( 128, 1024 );
		right *= RandomIntRange( -512, 512 );
		
		dummy.origin = level.player.origin + forward + right;
		PlayFx( getfx( "small_vehicle_explosion_nofire" ), dummy.origin );
		RadiusDamage( dummy.origin, 80, 200, 100, undefined, "MOD_EXPLOSIVE" );
		PhysicsExplosionSphere( dummy.origin, 80, 10, 1 );
		play_sound_in_space( "mortar_explosion", dummy.origin );
		
		dummy Delete();
	}
}
*/

courtyard_ambient_bullet_impacts()
{
	orgs = getstructarray( "ambient_bullet_origins", "targetname" );
	fire_rate = 0.05;
	if (level.currentgen)
		fire_rate = 0.5;
	
	while( true )
	{
		min_time = 0.25;
		max_time = 0.5;
		
		if( flag( "flag_slow_explosions_1" ) )
		{
			min_time = 1.25;
			max_time = 1.5;
		}
		if( flag( "flag_slow_explosions_2" ) )
		{
			min_time = 2.25;
			max_time = 2.5;
		}
		if (level.currentgen)
		{
			min_time *= 2.0;
			max_time *= 2.0;
		}
		
		wait( RandomFloatRange( min_time, max_time ) );
		
		forward = AnglesToForward( level.player.angles );
		right = AnglesToRight( level.player.angles );
		
		dummy = spawn( "script_origin", (0, 0, 0) );
		forward *= RandomIntRange( 256, 512 );
		right *= RandomIntRange( -256, 256 );
		
		angle = RandomInt( 360 );
		dummy.angles = ( 0, angle, 0 );
		
		bullet_origin = orgs[ RandomInt( orgs.size ) ];
		
		count = 0;
		start = level.player.origin + forward + right;
		length_of_bullet_line = RandomIntRange( 64, 256 );
		
		if (level.currentgen)
			number_of_shots = RandomIntRange( 2, 8 );
		else
			number_of_shots = RandomIntRange( 4, 15 );
		end = start + ( AnglesToForward( dummy.angles ) * length_of_bullet_line  );
		bullet_line = end - start;
		shots = number_of_shots * fire_rate;
		
		while( count < shots )
		{
			misfire_chance = randomfloat(1);
			if(misfire_chance < 0.8)
			{
			dummy.origin = start + bullet_line * ( count / shots );
				random_x = RandomIntRange( -40, 40 );
				random_y = RandomIntRange( -40, 40 );
				random_z = RandomIntRange( -5, 5 );
				dummy.origin += ( random_x, random_y, random_z );
				
				if ( !shot_endangers_any_player( bullet_origin.origin, dummy.origin ) )
				{
			MagicBullet( "ak47", bullet_origin.origin, dummy.origin );
					snd_message( "courtyard_ambient_bullet_impact",  "ak47", bullet_origin.origin, dummy.origin );
			}
			}
			count += fire_rate;
			wait( fire_rate );
		}
		
		dummy Delete();
	}
}

rooftop_slide()
{
	flag_wait( "flag_player_zip_started" );
	
	guy1_spawner = getent( "rooftop_slide_guy_1", "targetname" );
	guy2_spawner = getent( "rooftop_slide_guy_2", "targetname" );
	guy1_spawner.count++;
	guy2_spawner.count++;
	guy1 = guy1_spawner spawn_ai(true);
	level.get_in_mobile_turret_guy = guy1;
	guy2 = guy2_spawner spawn_ai(true);
	guy1.animname = "guy1";
	guy2.animname = "guy2";
	guy1 deletable_magic_bullet_shield();
	guy2 deletable_magic_bullet_shield();
	
	tag_origin = getstruct("struct_rooftop_slide", "script_noteworthy");
	
	guys = [guy1, guy2 ];
	
	tag_origin anim_first_frame(guys, "fusion_rooftop_slide");
	tag_origin anim_single(guys, "fusion_rooftop_slide");
	
	guy2 stop_magic_bullet_shield();
		
	goal_node_guy1 = GetNode("node_cover_burke_after_zip", "targetname");
	guy1 goto_node(goal_node_guy1, true);
	
	goal_node_guy2 = GetNode("node_cover_joker_after_zip", "targetname");
	guy2 goto_node(goal_node_guy2, true);
	
	
	flag_wait( "player_fly_in_done" );
	
	wait 4.5;
	
	guy2 set_force_color("p");
}

hide_water()
{
	flag_wait( "player_fly_in_done" );
	brush = getent( "water_on", "targetname" );
	brush delete();
}

courtyard_burke_rally()
{
	flag_wait( "flag_player_zip_started" );
	flag_set( "flag_boots_on_ground_dialogue" );
	flag_wait( "burke_fastzip_done" );
	flag_wait( "player_fly_in_done" );
	
	waittillframeend;
	
	level.burke.animname = "burke";
	level.joker.animname = "joker";
	level.carter.animname = "carter";
	
	level.burke set_ignoreall( true );
	level.joker set_ignoreall( true );

	anim_ent = GetStruct( "struct_courtyard_burke_rally", "script_noteworthy" );
	
	
	delayThread( 6.0, ::color_activate_post_burk_rally );
	anim_ent anim_reach_solo(level.burke, "street_burke_rally");
	level.burke set_ignoreall( false );
	anim_ent thread anim_single_solo_run(level.burke, "street_burke_rally");
	level.burke enable_ai_color();
	
	flag_set( "flag_burke_rally_street_dialogue" );
	
	level.carter delayThread( 9, ::enable_ai_color );
	
	level.joker set_ignoreall( false );
	
	anim_ent anim_reach_solo(level.joker, "street_burke_rally_in");
	anim_ent anim_single_solo(level.joker, "street_burke_rally_in");
	anim_ent thread anim_loop_solo(level.joker, "street_burke_rally_idle", "ender_string" );
	
	wait 2.75;
	
	anim_ent notify( "ender_string" );
	
	anim_ent anim_single_solo_run(level.joker, "street_burke_rally_out");
	
	
//	anim_ent anim_single_solo(level.joker, "street_burke_rally");
	level.joker enable_ai_color();
}

color_activate_post_burk_rally()
{
	activate_trigger_with_targetname( "color_t_fastzip_landing" );
	
	level.carter disable_sprint();
	
	trigger = getent( "color_t_fastzip_landing", "targetname" );	
	trigger trigger_off();
}

courtyard_mobile_cover_guys()
{
	// hackety hack hack
	guy1_spawner = getent( "mobile_cover_guy_1", "targetname" );
	guy2_spawner = getent( "mobile_cover_guy_2", "targetname" );
	guy1_spawner.count++;
	guy2_spawner.count++;
	guy1 = guy1_spawner spawn_ai(true);
	guy2 = guy2_spawner spawn_ai(true);
	guy1.animname = "guy1";
	guy2.animname = "guy2";
	guy1 deletable_magic_bullet_shield();
	guy2 deletable_magic_bullet_shield();
	
	tag_origin = spawn_tag_origin();
	tag_origin.origin = (-960.107, -3213.48, -72);
	tag_origin.angles = (0, 11, 0);
		
	mobile_cover = Spawn("script_model", tag_origin.origin);
	mobile_cover SetModel("vehicle_mobile_cover");
	mobile_cover assign_animtree("mobile_cover");
	
	clip = getent( "mobile_cover_courtyard_clip", "targetname" );
	
	guys = [guy1, guy2];
	
	tag_origin thread anim_first_frame(guys, "fusion_mobile_cover");
	tag_origin thread anim_first_frame_solo(mobile_cover, "fusion_mobile_cover");
	
	clip linkto( mobile_cover );
	
	flag_wait("flag_ambient_explosions_start");
		
	mobile_cover thread mobile_cover_badplace();
	mobile_cover thread mobile_cover_courtyard_start( clip, tag_origin );
	tag_origin anim_single_run(guys, "fusion_mobile_cover");
	
	guy2 stop_magic_bullet_shield();
	guy2 Kill();
	guy2 StartRagdoll();	
	
	node = GetNode("node_mobile_cover_courtyard", "targetname");
	guy1 goto_node(node, true);
	
	guy1 set_force_color("y");
	guy1 stop_magic_bullet_shield();
	
	level waittill( "street_cleanup" );
	
	tag_origin delete();
	mobile_cover delete();
}

mobile_cover_courtyard_start( clip, tag_origin )
{
	self snd_message("cvrdrn_paired_anim_start");
	tag_origin anim_single_solo( self, "fusion_mobile_cover" );
	
	self snd_message("cvrdrn_paired_anim_explo");
	self mobile_cover_explosion ( clip );
}

mobile_cover_badplace()
{
	self endon( "stop_mobile_cover_badplace" );
	
	while( true )
	{
		BadPlace_Cylinder( "mobile_cover_badplace", 0.25, self.origin, 96, 96, "axis", "allies" );
		wait( 0.25 );
	}
}

street_mobile_cover_guys()
{
	level.player endon("death");
	
	flag_wait( "flag_mobile_cover_se_2" );
	
	tag_origin = getstruct("street_mobile_cover_guys_node", "script_noteworthy");
	
	while(Distance(level.player.origin, tag_origin.origin) < 39 * 5 || player_looking_at(tag_origin.origin, Cos(60), true))
		wait .5;
	
	guy1_spawner = getent( "mobile_cover_2_guy_1", "targetname" );
	guy2_spawner = getent( "mobile_cover_2_guy_2", "targetname" );	
	guy1_spawner.count++;
	guy2_spawner.count++;
	guy1 = guy1_spawner spawn_ai(true);
	guy2 = guy2_spawner spawn_ai(true);
	guy1.animname = "guy1";
	guy2.animname = "guy2";
	guy1 deletable_magic_bullet_shield();
	guy2 deletable_magic_bullet_shield();
		
	mobile_cover_spawner = GetEnt("street_mobile_cover_guys_cover", "script_noteworthy");
	mobile_cover = mobile_cover_spawner spawn_vehicle();
	mobile_cover assign_animtree("mobile_cover");
	
	mobile_cover vehicle_scripts\_cover_drone::cover_drone_disable();
	
	guys = [guy1, guy2, mobile_cover];
	
	tag_origin thread anim_first_frame(guys, "fusion_mobile_cover_2");

	tag_origin anim_single(guys, "fusion_mobile_cover_2");	
	mobile_cover StopAnimScripted();
	
	mobile_cover vehicle_scripts\_cover_drone::cover_drone_enable();
		
	guy1 disable_awareness();
	guy2 disable_awareness();
	
	guy2 goto_node( "node_cover_mb_guy_01", false );
	guy1 goto_node( "node_cover_mb_guy_02", false );
	
	guy1 enable_awareness();
	guy2 enable_awareness();
	
	
	guy1 stop_magic_bullet_shield();
	guy2 stop_magic_bullet_shield();
	
	guys = [guy1, guy2];
	
	flag_wait( "flag_walker_destroyed" );
	
	foreach( guy in guys )
	{
		if( IsAlive( guy  ) )
		{
			guy set_force_color("y");
}
	}
}

mobile_cover_explosion( clip )
{
	self notify( "stop_mobile_cover_badplace" );
	
	dummy = spawn( "script_origin", (0, 0, 0) );
	dummy.origin = self.origin;
	fxAngles = self.angles + (-90,90,0);
	
	clip Delete();
	
	self SetModel ( "vehicle_mobile_cover_dstrypv" );
	
	PlayFx( getfx( "fusion_vehicle_mobile_cover_explosion" ), dummy.origin, AnglesToForward(fxAngles), AnglesToUp(fxAngles) );//Explosion fireball is included in the fx file
	earthquake( 1, 1.6, dummy.origin, 625 );
	RadiusDamage( dummy.origin, 200, 200, 100, undefined, "MOD_EXPLOSIVE" );
	PhysicsExplosionSphere( dummy.origin, 200, 10, 1 );
	play_sound_in_space( "mortar_explosion", dummy.origin );
	
	dummy Delete();
}

mobile_turret_dropoff()
{
	level.player endon( "death" );
	
//	flag_wait( "flag_burke_rally_street_dialogue" );
	flag_wait( "flag_player_zip_started" );
	
	wait 4;
	flag_set ("cam_shake_start");	
	org = getstruct( "org_mobile_turret_warbird_deploy", "targetname" );
	
	warbird = spawn_vehicle_from_targetname( "warbird_mobile_turret_deploy" );
	warbird snd_message( "warbird_mobile_turret_dropoff" );
	warbird.animname = "warbird_deploy";
	warbird godon();
	warbird maps\_vehicle::vehicle_lights_on( "running" );
	warbird Vehicle_TurnEngineOff();  //Turning off default engine audio.
		
	walker_model = spawn_anim_model( "walker_deploy" );
	walker_model.animname = "walker_deploy";
	walker_model snd_message( "walker_mobile_turret_dropoff" );
	
	pulley = spawn_anim_model( "pulley_deploy" );
	pulley.animname = "pulley_deploy";
	
	warbird thread custom_dust_kickup();
	
	org anim_first_frame( [ warbird, pulley, walker_model ], "mobile_turret_deploy" );
	
	org thread play_warbird_mobile_turret_dropoff( warbird, pulley );
	
	org anim_single_solo( walker_model, "mobile_turret_deploy" );
	
	walker = spawn_vehicle_from_targetname( "walker_mobile_turret_deploy" );
	walker snd_message( "spawn_walker_mobile_turret_deploy" );
	walker.animname = "mobile_turret";
	walker godon();
	walker Vehicle_Teleport( walker_model.origin, walker_model.angles );
	
	walker_model Delete();
	flag_set ("cam_shake_stop");	
	thread guy_get_in_mobile_turret( walker );
	
	if (level.currentgen)
	{
		level waittill("street_cleanup");
		walker Delete();
	}
}

custom_dust_kickup()
{
	// stop default _aircraft_dust_kickup
	wait 0.05;
	self notify( "stop_kicking_up_dust" );
	
	warbird_nose = self spawn_tag_origin();
	warbird_nose LinkTo( self, "tag_origin", (0, -150, -100), (0,0,0) );
	
	self thread aircraft_wash( warbird_nose );
	
	self waittill( "death" );
	self notify( "stop_kicking_up_dust" );
	warbird_nose Delete();
}
	
play_warbird_mobile_turret_dropoff( warbird, pulley )
{
	self anim_single( [ warbird, pulley ], "mobile_turret_deploy" );
	pulley LinkTo( warbird );
	warbird vehicle_detachfrompath();
	warbird Vehicle_SetSpeed( 60, 15, 5 );
	node = getstruct( "warbird_path_after_turret_deploy", "targetname" );
	warbird thread vehicle_dynamicpath( node, false );
	
	flag_wait( "warbird_turret_deploy_delete" ); //set when warbird gets to end of path
	pulley Delete();
	warbird Delete();
}

guy_get_in_mobile_turret( walker )
{
	level.player endon( "death" );
	
	guy = level.get_in_mobile_turret_guy;
	friendly_suppression = GetDvarInt( "ai_friendlySuppression" );
	SetSavedDvar( "ai_friendlySuppression", 0 );
	guy disable_awareness();
	guy PushPlayer( true );
	
	guy delayThread(2, ::enable_sprint);
	
	walker anim_reach_solo( guy, "guy_enter_mobile_turret", "tag_guy" );
	walker thread anim_single_solo( guy, "guy_enter_mobile_turret", "tag_guy" );
	walker anim_single_solo( walker, "guy_enter_mobile_turret" );
	
	SetSavedDvar( "ai_friendlySuppression", friendly_suppression );
	walker thread maps\_vehicle_aianim::guy_enter( guy );
	
	level.get_in_mobile_turret_guy = undefined;
	
	node = GetVehicleNode( "deployed_turret_path", "targetname" );
	//walker AttachPath( node );
	//walker thread gopath();
	
	walker.target = "deployed_turret_path";
	walker thread maps\_vehicle_code::getonpath();
	walker thread mobile_turret_gopath();
	walker thread monitor_turret_2_death();
	walker thread kill_path_on_death();
	
	// as soon as the rpg fires, orient the turret forward so the anim will line up (and avoids deathmodel popping)
	flag_wait("flag_mt_wall_rpg_fire");
	walker notify("stop_vehicle_turret_ai");
	turret_target_ent = spawn_tag_origin();
	turret_target_ent linkto(walker, "tag_body", (10000, 0, 0), (0, 0, 0));
	walker SetTurretTargetEnt(turret_target_ent);
	
	flag_wait( "flag_mt_wall_rpg_impact" );
	
	wait .25;
	
	walker godoff();
	walker DoDamage( walker.health + 200, (0,0,0) );
	
	walker thread walker_guy_death( guy );
	
	turret_target_ent Delete();
}

#using_animtree("generic_human");
walker_guy_death( guy )
{
	death_anim = %x4walker_wheels_destructed_death_right_npc;
	
	guy = maps\_vehicle_aianim::convert_guy_to_drone( guy, false, false ); // note - this isn't a real drone, just a script model
		
    [[ level.global_kill_func ]]( "MOD_RIFLE_BULLET", "torso_upper", guy.origin );
       
    guy LinkTo( self, "tag_guy", ( 0, 0, 0 ), ( 0, 0, 0 ) );
   
    guy NotSolid();
    
    guy SetFlaggedAnim( "death", death_anim );
    guy thread maps\fusion_fx::set_guy_on_fire();
    
    anim_length = GetAnimLength( death_anim );
    ragdoll_times = GetNotetrackTimes(death_anim, "start_ragdoll");
    if(IsDefined(ragdoll_times) && ragdoll_times.size > 0)
    	anim_length *= ragdoll_times[0];
    else
    	anim_length -= .15;
    
    wait anim_length;
    
	guy Unlink();
	//disabled rag doll as it caused fire to misalign with guy's skeleton.  Fire seems to cover up intersection with ground.
	//guy StartRagdoll();
}

enemy_walker()
{
	flag_wait( "flag_enemy_walker" );
	
	level.walker = spawn_vehicle_from_targetname( "enemy_walker" );
	level.walker snd_message( "titan_init" );
	
	flag_set( "update_obj_pos_walker" );
	
	level.walker.mobile_turret_rocket_target = false;
	level.walker thread walker_anims();
	level.walker thread manage_walker_health();
	level.walker thread walker_trophy_system();
	//level.walker thread btr_turret_think();
	level.walker thread walker_badplace();
	thread walker_missile_barrage();
	level.walker thread enemy_walker_kill_player_if_too_close();
	
	if( IsAlive( level.walker ) )
		level.walker waittill("death");
	
	flag_set( "flag_walker_destroyed" );

	flag_set( "update_obj_pos_security_entrance" );
	
	thread spawn_more_allies();

	delayThread(2, ::autosave_now);
	
	trigger = getent( "color_t_street_end", "targetname" );	
	trigger trigger_on();
	
	wait 1;
	
	if( IsDefined( trigger ) )
		activate_trigger_with_targetname( "color_t_street_end" );
}

enemy_walker_kill_player_if_too_close()
{
	self endon( "death" );
	
	flag_wait( "player_too_close_to_walker" );
	
	self godon();
	
	level.player endon( "death" );
	level.player EnableHealthShield( false );
	
	foreach( turret in self.mgturret )
	{
		turret notify( "stop_vehicle_turret_ai" );
		turret thread walker_tank_turret_fire_at_player( level.player );
	}
	
	for ( ;; )
	{
		level.player DoDamage( 15 / level.player.damagemultiplier, self.origin, self );
		timer = RandomFloatRange( 0.1, 0.3 );
		wait( timer );
	}
}

walker_tank_turret_fire_at_player( target )
{	
	self endon( "death" );
	self endon( "stop_vehicle_turret_ai" );
	
	self SetTurretTeam( "axis" );
	self SetMode( "manual" );
	self SetTargetEntity( target );
	self TurretFireEnable();	
	self StartFiring();
}

spawn_more_allies()
{
	spawners = GetEntArray( "allies_street_end", "script_noteworthy" );
	
	foreach( spawner in spawners )
	{
		if(IsDefined(spawner))
			spawner spawn_ai(true);
	}
}

walker_badplace()
{
	while ( !flag( "flag_walker_tank_on_mount" ) )
	{
		BadPlace_Cylinder( "walker_tank_badplace", 0.5, self.origin, 280, 300, "axis", "team3", "allies" );
		wait 0.55;
	}
}

walker_missile_barrage()
{
	wait .25;
	missile01 = spawn_vehicle_from_targetname_and_drive( "tank_missile_01" ); //TODO: verify missiles are deleted when done
	playfxontag(getfx("walker_tank_rocket_wv"), missile01, "tag_origin");
	missile01 snd_message( "titan_missile" );
	wait 0.15;
	missile02 = spawn_vehicle_from_targetname_and_drive( "tank_missile_02" );
	playfxontag(getfx("walker_tank_rocket_wv"), missile02, "tag_origin");
	missile02 snd_message( "titan_missile" );
	wait 0.15;
	missile03 = spawn_vehicle_from_targetname_and_drive( "tank_missile_03" );
	playfxontag(getfx("walker_tank_rocket_wv"), missile03, "tag_origin");
	missile03 snd_message( "titan_missile" );
	wait 1.15;
	missile04 = spawn_vehicle_from_targetname_and_drive( "tank_missile_04" );
	playfxontag(getfx("walker_tank_rocket_wv"), missile04, "tag_origin");
	missile04 snd_message( "titan_missile" );
	wait 0.15;
	missile05 = spawn_vehicle_from_targetname_and_drive( "tank_missile_05" );
	playfxontag(getfx("walker_tank_rocket_wv"), missile05, "tag_origin");
	missile05 snd_message( "titan_missile" );
	wait 0.15;
	missile06 = spawn_vehicle_from_targetname_and_drive( "tank_missile_06" );
	playfxontag(getfx("walker_tank_rocket_wv"), missile06, "tag_origin");
	missile06 snd_message( "titan_missile" );
	wait 0.15;
	missile07 = spawn_vehicle_from_targetname_and_drive( "tank_missile_07" );
	playfxontag(getfx("walker_tank_rocket_wv"), missile07, "tag_origin");
	missile07 snd_message( "titan_missile" );
}
					   	
walker_anims()
{
	self endon( "stop_walker_tank_anims" );
	level.player endon( "death" );
	
	self.animname = "walker_tank";
	
	org = getstruct( "org_enemy_walker", "targetname" );
	
	self snd_message( "titan_enter");
	
	org anim_single_solo( self, "fusion_walker_tank_enter" );
	self.state = "forward";
	self.death_state = "forward";
	self.prev_state = "forward";
	
	flag_set( "flag_walker_tank_on_mount" );
	
	org thread anim_loop_solo( self, "fusion_walker_tank_fwd_idle", "walker_stop_idle" );
	
	self DisconnectPaths();
	
	while( true )
	{
		wait( RandomFloatRange( 5, 10 ) );
		
		valid_states = [];
		
		switch( self.state )
		{
			case "forward":
				valid_states = [ "left", "right" ];
				break;
			case "left":
				valid_states = [ "forward", "right" ];
				break;
			case "right":
				valid_states = [ "forward", "left" ];
				break;
		}
		
		self.prev_state = self.state;
		
		if( cointoss() )
		{
			self.state = valid_states[ 0 ];
		}
		else
		{
			self.state = valid_states[ 1 ];
		}
		
		org notify( "walker_stop_idle" );
		
		if( self.state == "left" )
		{
			if( self.prev_state == "right" )
			{
				self.death_state = "right";
				org anim_single_solo( self, "fusion_walker_tank_right_2_fwd" );
				self.death_state = "forward";
			}
			
			org anim_single_solo( self, "fusion_walker_tank_fwd_2_left" );
			self.death_state = "left";
			org thread anim_loop_solo( self, "fusion_walker_tank_left_idle", "walker_stop_idle" );
		}
		
		if( self.state == "right" )
		{
			if( self.prev_state == "left" )
			{
				self.death_state = "left";
				org anim_single_solo( self, "fusion_walker_tank_left_2_fwd" );
				self.death_state = "forward";
			}
			
			org anim_single_solo( self, "fusion_walker_tank_fwd_2_right" );
			self.death_state = "right";
			org thread anim_loop_solo( self, "fusion_walker_tank_right_idle", "walker_stop_idle" );
		}
		
		if( self.state == "forward" )
		{
			if( self.prev_state == "left" )
			{
				self.death_state = "left";
				org anim_single_solo( self, "fusion_walker_tank_left_2_fwd" );
			}
			
			if( self.prev_state == "right" )
			{
				self.death_state = "right";
				org anim_single_solo( self, "fusion_walker_tank_right_2_fwd" );
			}
			
			self.death_state = "forward";
			org thread anim_loop_solo( self, "fusion_walker_tank_fwd_idle", "walker_stop_idle" );
		}
	}
}

walker_trophy_system()
{
	self endon( "death" );
	level.player endon( "death" );
	
	self.trophy_count = 2;
	self.current_projectile = 1;
	
	while( self.trophy_count >= 0 )
	{
		level.player waittill( "missile_fire", missile );
		thread player_projectile_think( missile, self );
	}
}

player_projectile_think( missile, walker )
{
	level.player endon( "projectile_impact" );
	missile endon( "death" );
	walker endon( "death" );
	level.player endon( "death" );
	
	trophy_dist = 512;
	
	if( walker.trophy_count <= 0 )
		return;
	
	while( true )
	{
		dist = Distance( missile.origin, walker.origin );
		if( dist <= trophy_dist )
		{
			PlayFx( getfx( "trophy_ignition_smoke" ), walker.origin + ( 0, 0, 96 ) );
			//PlayFx( getfx( "trophy_flares" ), walker.origin + ( 0, 0, 96 ) );
			PlayFx( getfx( "trophy_explosion" ), missile.origin );
			snd_message( "trophy_system_explosion", missile.origin );
			walker.trophy_count--;
			flag_set( "walker_trophy_" + walker.current_projectile );
			walker.current_projectile++;
			missile Delete();
		}
		
		wait( 0.05 );
	}
}

manage_walker_health()
{
	self endon( "death" );
	level.player endon( "death" );
	
	self godon();
	self thread walker_damage_fx();
	self wait_for_walker_to_be_hit_by_smaw();
	flag_set( "walker_damaged" );
	wait( 1 );
	self wait_for_walker_to_be_hit_by_smaw();
	
	objective_state_nomessage( obj("use_smaw"), "done" );
	
	self notify( "stop_vehicle_turret_ai" );
	self notify( "stop_walker_tank_anims" );
	self walker_play_death_anim();
}

wait_for_walker_to_be_hit_by_smaw()
{
	level.player endon( "death" );
	
	while( true )
	{
		self waittill( "damage", amount, attacker, direction_vec, point, type, modelName, tagName, partName, dFlags, weaponName );
		
		if( IsPlayer( attacker ) && type == "MOD_PROJECTILE" && weaponName == "smaw_nolock_fusion" )
		{
			self snd_message( "titan_take_damage_from_smaw" );
			break;
		}
	}
}

walker_damage_fx()
{
	flag_wait( "walker_damaged" );
	playfxontag(getfx("vehicle_damaged_sparks_l"), self, "TAG_SPARKS1");
	thread play_sound_on_tag( "titan_take_smaw_dmg_sparks", "TAG_SPARKS1", true );
	waitframe();
	playfxontag(getfx("vehicle_damaged_sparks_l"), self, "TAG_SPARKS2");
	thread play_sound_on_tag( "titan_take_smaw_dmg_sparks", "TAG_SPARKS1", true );
	waitframe();
	playfxontag(getfx("vehicle_damaged_sparks_l"), self, "TAG_SPARKS3");
	thread play_sound_on_tag( "titan_take_smaw_dmg_sparks", "TAG_SPARKS1", true );
	waitframe();
	playfxontag(getfx("vehicle_damaged_sparks_l"), self, "TAG_SPARKS4");
	thread play_sound_on_tag( "titan_take_smaw_dmg_sparks", "TAG_SPARKS1", true );
	waitframe();
}

walker_play_death_anim()
{
	Assert( IsDefined( self.death_state ) );
	
	flag_set( "flag_walker_death_anim_start" );
	
	anime = "";
	
	switch( self.death_state )
	{
		case "forward":
			anime = "fusion_walker_tank_fwd_idle_death";
			break;
		case "left":
			anime = "fusion_walker_tank_left_idle_death";
			break;
		case "right":
			anime = "fusion_walker_tank_right_idle_death";
			break;
	}
	
	Assert( anime != "" );
	
	org = getstruct( "org_enemy_walker", "targetname" );
	
	//play dying fx
	self thread maps\fusion_fx::walker_dying_fx();
	self snd_message( "titan_death" );
	
	org anim_single_solo( self, anime );
}

destroy_walker_tank( ent )
{
	ent Vehicle_Teleport( ent.origin, ent.angles - ( 0, 28.225, 0 ) );
	ent SetModel( "vehicle_walker_tank_dstrypv" );
	playfxontag(getfx("walker_explosion"), ent, "TAG_DEATH_FX");
	fxorigin = ent.origin;
	
	//save tag info for destroyed fx
	fire_origin = ent gettagorigin("TAG_FIRE");
	fire_angles = ent gettagangles("TAG_FIRE");
	
	fire2_origin = ent gettagorigin("TAG_FIRE2");
	fire2_angles = ent gettagangles("TAG_FIRE2");
	
	sparks_origin = ent gettagorigin("TAG_SPARKS");
	sparks_angles = ent gettagorigin("TAG_SPARKS");
	
	ent kill();
	wait 0.1;
	earthquake( 1, 1.6, fxorigin, 1350 );
	RadiusDamage( fxorigin, 400, 200, 100, undefined, "MOD_EXPLOSIVE" );
	PhysicsExplosionSphere( fxorigin, 400, 10, 1 );
	
	wait 1;
	//start destroyed fx
	playfx(getfx("vehicle_destroyed_fire_m"), fire_origin, AnglesToForward(fire_angles), AnglesToUp(fire_angles));
	playfx(getfx("vehicle_destroyed_fire_m"), fire2_origin, AnglesToForward(fire2_angles), AnglesToUp(fire2_angles));
	playfx(getfx("electrical_sparks_runner"), sparks_origin, AnglesToForward(sparks_angles), AnglesToUp(sparks_angles));
	//playfx(getfx("vehicle_destroyed_smoke_white_m"), fire_rocket_origin, AnglesToForward(fire_rocket_angles), AnglesToUp(fire_rocket_angles));
}


add_to_javelin_targeting()
{
	target_set( self, ( 0, 0, 56 ) );
	Target_SetJavelinOnly( self, true );
	
	if( IsAlive( level.walker ) )
		{
		self waittill("death");
		}
	
	Target_Remove( self );
}

btr_turret_think()
{
	self endon("death");
	self endon( "kill_btr_turret_think" );
	
	self thread vehicle_turret_scan_on();
	
	while ( true )
	{
		wait RandomFloatRange(.3, .8);
		
		target = self btr_get_target();
		if(IsDefined(target))
		{
			self btr_fire_at_target( target );
			wait .3;
		}
	}
}

btr_fire_at_target( target )
{
	target endon("death");
	level endon("walker_death_anim_started");
	
	self SetTurretTargetEnt(target, (0, 0, 32));
	
	if ( CoinToss() )
	{
		// fire small turret
		if(IsDefined(self.mgturret))
		{
			foreach(turret in self.mgturret)
			{
				if(IsDefined(turret))
				{
					turret SetTurretTeam("axis");
					turret SetMode("manual");
					turret SetTargetEntity(target);
					turret StartFiring();
				}
			}
		}
		
		wait RandomFloatRange( 3, 5 );
		
		if(IsDefined(self.mgturret))
		{
			foreach(turret in self.mgturret)
			{
				if(IsDefined(turret))
				{
					turret ClearTargetEntity();
					turret StopFiring();
				}
			}
		}
	}
	else
	{
		// fire big gun
		for ( i = 0; i < RandomIntRange( 1, 3 ); i++ )
		{
			self burst_fire_weapon();
			wait 0.5;
		}
	}
}

burst_fire_weapon()
{
	for ( i = 0; i < RandomIntRange( 2,4 ); i++ )
	{
		self FireWeapon();
		wait 0.2;
	}
}

btr_get_target()
{
	player_extra_chance = 4;
	
	targets = GetAIArray("allies");
	for(i = 0; i < player_extra_chance; i++)
		targets[targets.size] = level.player;
		
	return random(targets);
}

reactor_entrance_rally()
{
	flag_wait( "flag_player_at_reactor_entrance" );
	
	anim_ent = getstruct("anim_ent_reactor_entrance_rally", "script_noteworthy");
	goal_node_carter = GetNode("node_cover_carter_reactor_entrance", "targetname");
	
	level.burke disable_awareness();
	level.joker disable_awareness();
	
	level.burke enable_sprint();
	level.joker enable_sprint();
	
	level.burke ent_flag_init( "flag_reactor_entrance_ready" );
	level.joker ent_flag_init( "flag_reactor_entrance_ready" );
	
	level.burke thread reactor_entrance_rally_anim(anim_ent);
	level.joker thread reactor_entrance_rally_anim(anim_ent);
	level.carter goto_node ( goal_node_carter, false );
	
	level.burke ent_flag_wait( "flag_reactor_entrance_ready" );
	level.joker ent_flag_wait( "flag_reactor_entrance_ready" );
	
	flag_wait( "flag_player_at_reactor_door" );
	
	level.carter disable_ai_color();
		
	flag_set( "start_itiot" );
}

reactor_entrance_rally_anim(anim_ent)
{
	self endon( "death" );
	ender_string = self.animname + "_ender";
	
	self disable_ai_color();
	
	anim_ent anim_reach_solo(self, "reactor_entrance_st");
	self ent_flag_set( "flag_reactor_entrance_ready" );
	
	anim_ent anim_single_solo(self, "reactor_entrance_st");
	anim_ent thread anim_loop_solo(self, "reactor_entrance_idle", ender_string);
	
	flag_wait( "interior_allies" );
	anim_ent notify( ender_string );
//	self ent_flag_set( "flag_reactor_entrance_ready" );
}
/*
roof_fx()
{
	org = getstruct( "org_roof_fx", "targetname" );
	PlayFX( getfx( "fireball_smk_S" ), org.origin );
}
*/

postspawn_rpg_vehicle()
{
	self SetModel( "projectile_rpg7" );

	fx = getfx( "rpg_trail" );
	PlayFXOnTag( fx, self, "tag_origin" );

	fx = getfx( "rpg_muzzle" );
	PlayFXOnTag( fx, self, "tag_origin" );

	self PlaySound( "weap_rpg_fire_npc" );

	if ( IsDefined( self.script_sound ) )
	{
		if ( IsDefined( self.script_wait ) )
		{
			self delaycall( self.script_wait, ::PlaySound, self.script_sound );
		}
		else
		{
			self PlaySound( self.script_sound );
		}
	}
	else
	{
		self PlayLoopSound( "weap_rpg_loop" );
	}

	self waittill( "reached_end_node" );
	self notify( "explode", self.origin );

	exploded = false;
	if ( IsDefined( self.script_exploder ) )
	{
		exploder( self.script_exploder );
		exploded = true;
	}
	else if ( IsDefined( self.currentnode ) )
	{
		// Be sure we have the last node
		lastnode = undefined;
		next = self.currentnode;
		while ( IsDefined( next ) )
		{
			lastnode = next;

			if ( !IsDefined( next.target ) )
			{
				break;
			}

			next = GetVehicleNode( next.target, "targetname" );
		}

		if ( IsDefined( lastnode.target ) )
		{
			struct = getstruct( lastnode.target, "targetname" );
			if ( IsDefined( struct ) )
			{
				level thread rpg_explosion( struct.origin, struct.angles );
				exploded = true;
			}
		}
	}

	if ( !exploded )
	{
		struct = SpawnStruct();
		struct.origin = self.origin;
		struct.angles = ( -90, 0, 0 );
		level thread rpg_explosion( struct.origin, struct.angles );
	}

	self Delete();
}

rpg_explosion( origin, angles )
{
	fx = getfx( "rpg_explode" );
	PlayFx( fx, origin, AnglesToForward( angles ), AnglesToUp( angles ) );
	RadiusDamage( origin, 200, 150, 50 );
	thread play_sound_in_space( "rocket_explode_rock", origin );
}

//////////////////////////////////////////////////
//////////////////// INTERIOR ////////////////////
//////////////////////////////////////////////////

interior_gameplay()
{
//	level.player EnableDeathShield( true );
	thread interior_allies();
	thread security_room();
	thread laboratory();
	thread reactor_room();
	thread turbine_room();
	thread control_room();
}

interior_allies()
{
	waittillframeend;
	flag_wait_any( "interior_allies", "flag_walker_destroyed" );
	level.burke set_force_color( "r" );
	level.joker set_force_color( "g" );
	level.carter set_force_color( "o" );
}

security_room()
{
	if ( level.start_point != "fly_in_animated" &&
	    level.start_point != "fly_in_animated_part2" &&
	    level.start_point != "courtyard" &&
	    level.start_point != "security_room" )
		return;
	
	flag_wait_any( "interior_allies", "flag_walker_destroyed" );
	
	anime = "security_room_check_corpse";
	anime_idle = "security_room_check_corpse_idle";
	idle_ender = "security_room_check_corpse_idle_stop";
	
	corpse = GetEnt( "fusion_security_room_corpse", "targetname" ) spawn_ai( true );
	corpse SetContents( 0 );
	corpse.animname = "generic";
	
	struct = getstruct( "fusion_security_room_corpse_fall_npc", "targetname" );
	org = spawn( "script_origin", struct.origin );
	angles = (0, 0, 0);
	if( isdefined( struct.angles ) )
	{
		angles = struct.angles;
		org.angles = struct.angles;
	}
	
	corpse ClearAnim( %body, 0.2 );
	corpse StopAnimScripted();
	
	org anim_first_frame_solo( corpse, anime );
	wait 0.05;
	corpse_gun = spawn( "script_model", corpse GetTagOrigin( "TAG_WEAPON_RIGHT" ) );
	corpse_gun.angles = corpse GetTagAngles( "TAG_WEAPON_RIGHT" );
	corpse_gun setmodel( "npc_m160" );
	corpse_gun LinkTo( corpse, "TAG_WEAPON_RIGHT" );
	
//	flag_wait( "security_room_check_corpse_prep" );
	
	elevator_doors = GetEnt( "security_room_elevator_doors", "targetname" );
	elevator_doors assign_animtree("security_room_elevator_doors");
	org anim_first_frame_solo( elevator_doors, "security_room_open_elevator" );
	
	security_elevator_door_left = getent( "security_elevator_door_left", "targetname" );
	security_elevator_door_right = getent( "security_elevator_door_right", "targetname" );
	
	security_elevator_door_left linkto( elevator_doors, "elevator_back_left_jnt" );
	security_elevator_door_right linkto( elevator_doors, "elevator_back_right_jnt" );
	
	flag_wait( "security_room_check_corpse" );
	
	level.burke thread start_cqb_when_near( GetStartOrigin( org.origin, angles, level.scr_anim[ "burke" ][ anime ] ) );

	org anim_reach_solo( level.burke, anime );
//	org anim_ssecurity_room_check_corpse_idle
	delayThread( 3, ::flag_set, "vo_security_room_elevator_access" );
	
	thread security_elevator_open();
	
	//animate burke and corpse
	snd_message("start_dead_guy_foley", corpse);
	org thread anim_generic( corpse, anime );
	org anim_single_solo( level.burke, anime );
	
	if( !flag( "elevator_door_open" ) )
	{
		org thread anim_loop_solo( level.burke, anime_idle, idle_ender );
//	org delete();
		flag_wait( "elevator_door_open" );
		org notify( idle_ender );
	}
	
	turn_to_elevator_anime = "security_room_turn_to_elevator";
	facing_elevator_idle = "elevator_descent_start_idle";
	
	org anim_single_solo( level.burke, turn_to_elevator_anime );
	flag_set( "burke_facing_elevator" );
//	if( !flag( "elevator_descent" ) )
//	{
		org thread anim_loop_solo( level.burke, facing_elevator_idle, facing_elevator_idle );
//	org delete();
		wait 2;
		flag_wait( "elevator_descent" );
		org notify( facing_elevator_idle );
//	}
	org delete();
	if ( level.currentgen )
	{
		level waittill("street_cleanup");
		security_elevator_door_left Delete();
		security_elevator_door_right Delete();
		corpse_gun Delete();
		corpse Delete();
	}
}

start_cqb_when_near( coords )
{
	dist = 200 * 200;
	while( DistanceSquared( self.origin, coords ) > dist )
		wait 0.1;
	
	self enable_cqbwalk();
}

security_elevator_open()
{
//	wait 4;
	
	struct = getstruct( "fusion_security_room_corpse_fall_npc", "targetname" );
	org = spawn( "script_origin", struct.origin );
	if( IsDefined( struct.angles ) )
		org.angles = struct.angles;
	
	approach_anime = "security_room_approach_elevator";
	approach_idle = "security_room_open_elevator_idle";
	
	ender = "end_approach_idle";
	
	
	open_anime = "security_room_open_elevator";
	opened_idle = "security_room_elevator_opened_idle";
	snd_message("start_elevator_zone_audio");
	
	guys = [];
	guys[guys.size] = level.joker;
	guys[guys.size] = level.carter;
	array_thread( guys, ::security_elevator_approach, org, approach_anime, approach_idle, ender );
	
	level waittill( "elevator_open_guy_ready" );
	level waittill( "elevator_open_guy_ready" );
	
	
	
	flag_wait( "elevator_door_open" );
	org notify( ender );
	exploder ("elevator_door_open_fx");
	
	elevator_doors = GetEnt( "security_room_elevator_doors", "targetname" );
	elevator_doors assign_animtree("security_room_elevator_doors");
	
	level.joker thread security_elevator_open_anim( org, true, open_anime, opened_idle );
	level.carter thread security_elevator_open_anim( org, false, open_anime, opened_idle );
	org thread anim_single_solo( elevator_doors, open_anime );
	
	snd_message("Sec_Room_Elevator_Open");
	
//	org anim_single( guys, open_anime);
//	
//	org thread anim_loop( guys, opened_idle );
//		
//	
////	wait 2.5;
//	
//	security_elevator_door_right = getent( "security_elevator_door_right", "targetname" );
//	security_elevator_door_left = getent( "security_elevator_door_left", "targetname" );
//	
//	moveTime = 3;
//	
//	security_elevator_door_right MoveTo( getstruct( security_elevator_door_right.target, "targetname" ).origin, moveTime );
//	security_elevator_door_left MoveTo( getstruct( security_elevator_door_left.target, "targetname" ).origin, moveTime );
	
//	level waittill( "burke_facing_elevator" );
	
//	flag_wait( "elevator_descent" );
	
	security_elevator_descent( org );
	org delete();
}

security_elevator_approach( org, approach_anime, approach_idle, ender )
{
	if( self == level.joker )
		wait 4;
	
	org anim_reach_solo( self, approach_anime );
	if(self == level.Joker)
		snd_message("Sec_Room_Move_To_Elevator");
	org anim_single_solo( self, approach_anime );
	if(self == level.Joker)
		snd_message("Sec_Room_Attach_To_Elevator");	
	org thread anim_loop_solo( self, approach_idle, ender );
	level notify( "elevator_open_guy_ready" );
}

security_elevator_open_anim( animnode, isJoker, open_anime, opened_idle )
{
	ender = "stop_opened_idle";
	org = spawn( "script_origin", animnode.origin );
	org anim_single_solo( self, open_anime);
//	door = undefined;
//	if( isJoker )
//	{
//		level waittill( "elevator_attach_joker" );
//
//		door = getent( "security_elevator_door_right", "targetname" );
//	}
//	else
//	{
//		level waittill( "elevator_attach_carter" );
//		door = getent( "security_elevator_door_left", "targetname" );
//	}
//		
//	door LinkTo( self, "tag_inhand" );
//		
//	if( isJoker )
//	{
//		level waittill( "elevator_detach_joker" );
//	}
//	else
//	{
//		level waittill( "elevator_detach_carter" );
//	}
//	
//	door Unlink();

//	org waittill( open_anime );
		
	if( !flag( "elevator_descent_player" ) )
	{
		org thread anim_loop_solo( self, opened_idle, ender );
		flag_wait( "elevator_descent_player" );
		org notify( ender );
	}
}

security_elevator_descent( org )
{
	thread security_elevator_descent_player();
	
	flag_wait( "burke_facing_elevator" );
	wait 2;
	flag_wait( "elevator_descent" );
	
	flag_set( "vo_security_room_elevator_open" );
	
	level.guys_down_elevator = 0;
	
	level.burke thread security_elevator_descent_ai( org );
	
	flag_wait( "elevator_descent_player" );
	
	level.joker thread security_elevator_descent_ai( org );
	level.carter security_elevator_descent_ai( org );
}

security_elevator_descent_player()
{
	flag_wait( "elevator_descent_player" );
	
	level.player blend_MoveSpeedscale_Percent( 0 );
	snd_message("start_player_elevator_slide");
	
	flag_set( "update_obj_pos_elevator_descent" );
	
	player_org = getstruct( "elevator_descent_org", "targetname" );
	player_rig = spawn_anim_model( "player_rig", level.player.origin );
	player_rig hide();
	level.player DisableWeapons();
	
	blendTime = 0.5;
	level.player PlayerLinkToBlend( player_rig, "tag_player", blendTime );
	level.player delayCall( blendTime, ::PlayerLinkToDelta, player_rig, "tag_player", 0, 20, 20, 20, 20 );
	level.player delayCall( 3.25, ::EnableWeapons );
	
//	/#
		//give player max ammo
		level.player delayCall( 1.5, ::GiveMaxAmmo, "iw5_m160_sp_deam160_variablereddot" );
//	#/
	
	player_rig delayCall( 0.5, ::show);
	noself_delayCall( 1.0, ::PlayFxOnTag, getfx( "elevator_player_slide_dust" ), player_rig, "J_MainRoot" );
	player_org anim_single_solo( player_rig, "elevator_descent" );
	
	
	//wait 2.25;
	level.player Unlink();
	player_rig delete();
	level.player EnableWeapons();
	flag_set( "lab_cqb" );
	flag_set( "vo_lab_elevator_slide_complete" );
	
	thread street_cleanup();
	
	autosave_by_name( "elevator_slide_complete" );
}

corpse_trigger_think()
{
	self waittill( "trigger" );
	
	t = self get_target_ent();
	structs = getstructarray_delete( t.script_noteworthy, "script_noteworthy" );
	
	foreach ( s in structs )
	{
		guy = t spawn_ai();
		guy.origin = s.origin;
		guy.angles = s.angles;
		guy SetCanDamage( false );
		
		anime = level.scr_anim[ "generic" ][ s.animation ];
		if ( IsArray( anime ) )
			anime = anime[ 0 ];
			
		guy AnimScripted( "endanim", s.origin, s.angles, anime );
		if ( isdefined( s.script_parameters ) )
		{
			if ( s.script_parameters == "notsolid" )
			{
				guy NotSolid();
			}
			if ( s.script_parameters == "ripples" )
			{
				guy thread ripples_on_body( s );
			}
		}
		
		if ( issubstr( s.animation, "death" ) )
			guy delayCall( 0.05, ::setAnimTime, anime, 1.0 );
	}
	
	//cleanup when flag set
	if( IsDefined( self.script_flag ) )
	{
		flag_wait( self.script_flag );
		array_call( GetEntArray( t.script_noteworthy, "script_noteworthy" ), ::delete );
	}
}

ripples_on_body( struct )
{
	self endon( "death" );
	wait( 0.1 );
	n = get_target_ent( struct.target );
	org = ( self.origin[ 0 ], self.origin[ 1 ], n.origin[ 2 ]-1 );
	while( 1 )
	{
		PlayFX( getfx( "water_movement" ), org );
		wait( RandomFloatRange( 0.5, 1 ) );
	}
}

street_cleanup()
{
	level notify( "street_cleanup" );
	waittillframeend;
	ai = GetAIArray();
	ai = array_remove( ai, level.burke );
	ai = array_remove( ai, level.joker );
	ai = array_remove( ai, level.carter );
	array_call( ai, ::delete ); //remove all ai
	
	array_call( GetEntArray( "script_vehicle_x4walker_wheels_turret", "classname" ), ::delete ); //remove mobile turrets
	if(IsDefined(level.player.linked_to_cover))
		level.player.linked_to_cover vehicle_scripts\_cover_drone::player_unlink_from_cover();
	array_call( GetEntArray( "script_vehicle_cover_drone", "classname" ), ::delete ); //remove mobile cover
	array_call( GetEntArray( "mobile_turret", "targetname" ), ::delete ); //remove mobile turrets
	array_call( GetEntArray( "script_vehicle_pdrone", "classname" ), ::delete ); //remove ally personal drones
	//array_call( GetEntArray( "script_vehicle_xh9_warbird", "classname" ), ::delete ); //remove warbirds  //this deletes too much
	
	if( IsDefined( level.walker ) )
	{
		level.walker connectpaths();
	}
	
	if (level.currentgen)
	{
		UnloadTransient("fusion_intro_tr");
		LoadTransient("fusion_middle_tr");
	}
}

security_elevator_descent_ai( start )
{
	anime = "elevator_descent";
	
	if( self == level.burke )
	{
		snd_message("start_burke_elevator_slide");
		start thread anim_single_solo( self, anime );
		delaythread( 3, ::flag_set, "update_obj_pos_security_elevator" ); //after burke jumps, switch objective dot to the elevator instead of following him
		waittill_any_ents( start, anime, level, "burke_elevator_landing" );
		anime = "elevator_descent_exit";
		start anim_single_solo( self, anime );
	}
	else
	{
		start anim_single_solo( self, anime );
	}
		
	self laboratory_start_idle();
}

laboratory_start_idle()
{
	anime_idle = "elevator_descent_end_idle";
	anime_out = "elevator_descent_end_idle_2_cqb";
	idle_ender = "elevator_descent_end_idle_stop";

	struct = getstruct( "fusion_security_room_corpse_fall_npc", "targetname" );
	org = spawn( "script_origin", struct.origin );
	if( isdefined( struct.angles ) )
		org.angles = struct.angles;
	
	org thread anim_loop_solo( self, anime_idle, idle_ender );
	
	if( !IsDefined(level.guys_down_elevator) )
		level.guys_down_elevator = 0;
	level.guys_down_elevator++;
	level notify( "guy_down_elevator" );
	while( level.guys_down_elevator < 3 )
	{
		level waittill( "guy_down_elevator" );
	}
	
	flag_wait( "negotiation_elevator_to_hall" );
	
	if( self == level.burke )
		wait 4;
	else if( self == level.carter )
		wait 1;
	
	org notify( idle_ender );
	
	self enable_cqbwalk();
	self enable_ai_color();
	self.moveplaybackrate = 1.1;
	
	if( self == level.joker )
	{
		flag_set( "start_lab_traversals" );
	}
	else
	{
		org anim_single_solo_run( self, anime_out );
	}
	org delete();
}

laboratory()
{
	thread laboratory_cqb();
	
	flag_wait( "start_lab_traversals" );
	thread lab_doorway_dyn_path();
	thread color_group_enter_lab_trigger();
	//traversals
	laboratory_traversal( "negotiation_elevator_to_hall", level.joker );
	laboratory_traversal( "negotiation_hall_to_lab", level.burke, "negotiation_curved_hall" );
	laboratory_traversal( "negotiation_curved_hall", level.burke, "negotiation_locker_room_entrance" );
	laboratory_traversal( "negotiation_locker_room_entrance", level.carter, "airlock_scene_prep" );
}

color_group_enter_lab_trigger()
{
	trig = getent( "color_group_enter_lab", "targetname" );
	if( IsDefined( trig ) )
		trig waittill( "trigger" );
	
//	old_trig = getent( "negotiation_hall_to_lab_exit", "targetname" );
//	old_trig delete();
	
	negotiation_hall_to_lab_carter = getent( "negotiation_hall_to_lab_carter", "targetname" );
	negotiation_hall_to_lab_carter delete();
	
	negotiation_hall_to_lab_joker = getent( "negotiation_hall_to_lab_joker", "targetname" );
	negotiation_hall_to_lab_joker delete();
}

lab_doorway_dyn_path()
{
	col = GetEnt( "lab_doorway_dyn_path", "targetname" );
	col DisconnectPaths();
	
	level waittill( "negotiation_hall_to_lab_dyn_path" );
	
	wait 5;
	col ConnectPaths();
	col delete();
}

laboratory_traversal( negotiation, actor, end_on )
{
	if( isdefined( end_on ) )
		level endon( end_on );
	flag_wait( negotiation );
	
	anime = negotiation;
	switch ( negotiation )
	{
		case "negotiation_elevator_to_hall":
			thread laboratory_elevator_to_hall( negotiation, end_on );
			anime = "elevator_descent_end_idle_2_cqb";
			flag_set( "update_obj_pos_lab_follow_joker" ); //follow joker
			break;
	
		case "negotiation_hall_to_lab":
			thread negotiation_hall_to_lab( negotiation, end_on );
			delayThread( 3, ::flag_set, "update_obj_pos_lab_follow_burke" );  //follow burke
			break;
			
		case "negotiation_curved_hall":
			//follow burke
			break;
			
		case "negotiation_locker_room_entrance":
			delayThread( 3, ::flag_set, "update_obj_pos_lab_follow_carter" );  //follow carter
			break;
			
		default:
			break;
	}
	
	org = getstruct( negotiation, "targetname" );
	actor notify( "stop_color_move" );
	if( negotiation != "negotiation_elevator_to_hall" )
	{
		org anim_reach_solo( actor, anime );
		
		if( negotiation == "negotiation_hall_to_lab" )
			level notify( "negotiation_hall_to_lab_dyn_path" );
	}
	else
	{
		org = getstruct( "fusion_security_room_corpse_fall_npc", "targetname" );
	}
	triggername = negotiation + "_exit";
	trigger = getent( triggername, "targetname" );
	if( isdefined( trigger ) )
	   activate_trigger_with_targetname( negotiation + "_exit" );
	org anim_single_solo_run( actor, anime );
	
}

laboratory_elevator_to_hall( negotiation, end_on )
{
//	level endon( end_on );
	wait 1;
	activate_trigger_with_targetname( negotiation + "_carter" );
	if( isdefined( level.carter.node ) )
		level.carter.node.script_delay = undefined;
	
	wait 1;
	if( !flag( "negotiation_hall_to_lab" ) )
	{
		activate_trigger_with_targetname( negotiation + "_burke" );
	}
	if( isdefined( level.burke.node ) )
		level.burke.node.script_delay = undefined;
}

negotiation_hall_to_lab( negotiation, end_on )
{
	level endon( end_on );
	wait 1;
	if( isdefined( getent( negotiation + "_carter", "targetname" ) ) )
	{
		activate_trigger_with_targetname( negotiation + "_carter" );
	}
	if( isdefined( level.carter.node ) )
		level.carter.node.script_delay = undefined;
	
	wait 3;
	if( isdefined( getent( negotiation + "_carter", "targetname" ) ) )
	{
		activate_trigger_with_targetname( negotiation + "_joker" );
	}
	if( isdefined( level.joker.node ) )
		level.joker.node.script_delay = undefined;
	
}

laboratory_cqb()
{
	flag_wait( "lab_cqb" );
	level.player blend_MoveSpeedscale_Percent( 75 );
	setsaveddvar( "ai_friendlyFireBlockDuration", 0 );
	
	flag_wait( "reactor_room_reveal_scene" );
	level.player blend_MoveSpeedscale_Percent( 100, 5 );
	
	flag_wait( "reactor_room_reveal_allies_advance" );
	setsaveddvar( "ai_friendlyFireBlockDuration", 2000 );
}

reactor_room()
{
	thread reactor_room_reveal_scene();
	thread reactor_room_drones();
	thread reactor_room_crane();
	thread reactor_room_robots();
}

reactor_room_reveal_scene()
{	
	flag_wait( "airlock_scene_prep" );
	
	snd_message("start_airlock_anim_notetracks");
	anime = "fusion_airlock_opening_approach";
	anime_idle = "fusion_airlock_opening_idle";
	anim_node = getstruct( "airlock_anim_node", "targetname" );
	ender = "reactor_room_reveal_scene";
	
	thread reactor_room_reveal_door( anim_node, "fusion_airlock_opening" );
	
	delayThread( 4, ::flag_set, "vo_reactor_open_airlock" );
	
	guys = [];
	guys[guys.size] = level.burke;
	guys[guys.size] = level.carter;
	
	level.reactor_room_reveal_scene_guys_ready = 0;
	
	array_thread( guys, ::reactor_room_reveal_scene_approach, anim_node, anime, anime_idle, ender );
	
	level waittill( "reactor_room_reveal_scene_prepped" );
	
	anime = "fusion_airlock_opening";
	flag_wait( "reactor_room_reveal_scene" );
	
	level notify( "reactor_room_reveal_scene_started" );
	anim_node notify( ender );
	
	array_notify( guys, "reactor_room_reveal_scene" );
	
	array_thread( GetEntArray( "reactor_redshirts", "script_noteworthy" ), ::reactor_room_redshirts );
	thread reactor_room_redshirt_cleanup();
	
	badguy = getent( "reactor_room_airlock_enemy", "targetname" ) spawn_ai( true );
	badguy SetContents( 0 );
	badguy.animname = "generic";
	guys[guys.size] = badguy;
	badguy SetContents( 0 );
	anim_node thread anim_single_run( guys, anime );
	
	MUS_play( "rescue_2_assault", 0 );
	
	level.burke disable_cqbwalk();
	level.joker disable_cqbwalk();
	level.carter disable_cqbwalk();
	
	level.burke enable_careful();
	level.joker enable_careful();
	level.carter enable_careful();
	
	level.burke.moveplaybackrate = 1;
	level.joker.moveplaybackrate = 1;
	level.carter.moveplaybackrate = 1;
	
	battlechatter_off( "allies" );
	battlechatter_off( "axis" );
	
	delayThread( 15, ::battlechatter_on, "allies" );
	delayThread( 15, ::battlechatter_on, "axis" );
	
	level.burke thread reactor_room_reveal_scene_ally_think();
	level.joker thread reactor_room_reveal_scene_ally_think();
	level.carter thread reactor_room_reveal_scene_ally_think();
	
//	delayThread( 13, ::flag_set, "vo_reactor_entrance" );
	flag_set( "vo_reactor_entrance" );
	delayThread( 12, ::activate_trigger_with_noteworthy, "reactor_room_first_spawn_trigger" );
	
	array_thread( GetEntArray( "reactor_room_robot_grid_safeguard", "targetname" ), ::reactor_room_robot_grid_ally_safeguard );
//	thread reactor_room_robot_grid_ally_safeguard();
//	thread reactor_room_bad_places();
	
	//these guys should be unaware until player raises commotion or timer
//	array_spawn_function_targetname( "reactor_room_enemies_initial", ::reactor_room_reveal_enemies_think );
//	array_spawn_targetname( "reactor_room_enemies_initial", true );
	
	delayThread( 12, ::activate_trigger_with_targetname, "reactor_room_door_open_color_trigger" );
	
	flag_wait( "reactor_room_reveal_allies_advance" );
	level.burke enable_ai_color();
	level.carter enable_ai_color();
	if( !flag( "reactor_redshirts_enable" ) )
	{
		activate_trigger_with_targetname( "reactor_room_door_open_color_trigger" );
	}
	
	flag_set( "update_obj_pos_reactor_1" );
	
	autosave_by_name();
	thread reactor_room_combat();
	thread reactor_room_catwalk_death();
}

reactor_room_reveal_scene_approach( anim_node, anime, anime_idle, ender )
{
	anim_node anim_reach_solo( self, anime );
	anim_node anim_single_solo( self, anime );
	
	anim_node thread anim_loop_solo( self, anime_idle, ender );
	
	//wait until both guys are ready before starting the scene
	level.reactor_room_reveal_scene_guys_ready++;
	if( level.reactor_room_reveal_scene_guys_ready >= 2 )
	{
		level notify( "reactor_room_reveal_scene_prepped" );
	}
}

reactor_room_reveal_scene_ally_think()
{
	old_grenade_awareness = self.grenadeawareness;
	self.grenadeawareness = 0;
	self.ignoreall = true;
	flag_wait( "reactor_room_reveal_allies_advance" );
	
//	self.ignoreall = true;
	self.disableBulletWhizbyReaction = true;
	self.nogrenadereturnthrow = true;
	old_radius = self.goalradius;
	self.goalradius = 64;
	waittillframeend;
	
	self waittill_notify_or_timeout( "goal", 5 );
	self.ignoreall = false;
	self.grenadeawareness = old_grenade_awareness;
	self.disableBulletWhizbyReaction = false;
	self.nogrenadereturnthrow = false;
	self.goalradius = old_radius;
}

reactor_room_reveal_enemies_think()
{
	self endon( "death" );
	self.grenadeAmmo = 0;
	if( IsDefined( self.target ) )
		self.goalradius = 16;
	
	dist = 200 * 200;
	
	while( DistanceSquared( self.origin, level.burke.origin ) > dist )
		wait 0.1;
	
//	MagicBullet( 
}

reactor_room_reveal_door( anim_node, anime )
{
	door = getent( "reactor_airlock_door_1", "targetname" );
//	doorModel = getent( door.target, "targetname" );
//	doorModel linkto( door );
	doorCol = getent( door.target, "targetname" );
	doorCol DisconnectPaths();
	door.animname = "fusion_airlock_door";
	door SetAnimTree();
	
	anim_node thread anim_first_frame_solo( door, anime );
	
	level waittill( "reactor_room_reveal_scene_prepped" );
	
	doorCol linkto( door, "door" );
	
	flag_wait( "reactor_room_reveal_scene" );
	
	snd_message("start_reactor_airlock_open", door);
	snd_message("start_reactor_zone_audio");
	snd_message("start_reactor_burke_attack");
	
	//thread reactor_room_reveal_squibs();
	
	dur = 45;
//	acc = 0.1;
//	dec = 0.1;
	
	Earthquake( 0.1, dur, door.origin, 1000 ); //rumble
	exploder (3301); //falling dust vfx when door opens
	exploder (3302); //light ray vfx when door opens
	exploder (3303); //light ray vfx when door opens
	exploder (3304); //light ray vfx when door opens
	exploder (3201); //falling dust vfx earthquake triggers
	exploder (3202); //falling dust vfx earthquake triggers
	
//	door RotateTo( door.angles + (0, 135, 0), dur, acc, dec );
	
	anim_node thread anim_single_solo( door, anime );
	
	
	
//	delaythread( 1, ::reactor_room_reveal_squibs, 15 );
//	delaythread( .5, ::reactor_room_reveal_squibs, 12 );
//	delaythread( 1.3, ::reactor_room_reveal_squibs, 15 );
//	delaythread( 3.05, ::reactor_room_reveal_squibs, 25 );
//	delaythread( 5.1, ::reactor_room_reveal_squibs, 19 );
//	delaythread( 8.05, ::reactor_room_reveal_squibs, 14 );
//	delaythread( 11, ::reactor_room_reveal_squibs, 13 );
//	delaythread( 13.6, ::reactor_room_reveal_squibs, 16 );
//	delaythread( 14.85, ::reactor_room_reveal_squibs, 12 );
//	delaythread( 16.5, ::reactor_room_reveal_squibs, 17 );
//	delaythread( 19, ::reactor_room_reveal_squibs, 16 );
	
//	src = getstruct( "reactor_reveal_grenade_source", "targetname" );
//	dest = getstruct( "reactor_reveal_grenade_dest", "targetname" );
//	noself_delayCall( 5, ::MagicGrenade, "fraggrenade", src.origin, dest.origin, 5 );
	
	wait 15.5;
	flag_set( "reactor_room_reveal_allies_advance" );
	doorCol ConnectPaths();
	waittillframeend;
	doorCol DisconnectPaths();
	
	flag_set( "vo_reactor_gogogo" );
}

reactor_room_reveal_squibs( bullets, delay )
{
	level endon( "intro_truck_left" );
	
	source = getstruct( "reactor_reveal_bullet_org", "targetname" );
	targets = getstructarray( source.target, "targetname" );
	
	targets = array_randomize( targets );
	
	//sourceOrg = org.origin;
	//source = spawn( "script_origin", sourceOrg );
	//source.origin = (sourceOrg[0], sourceOrg[1] + randomintrange(-36, 36), sourceOrg[2] + randomintrange(-32, 32) );
	
	randMin = -5;
	randMax = 5;
	
	ind = 0;
	for( i = 0; i < bullets; i++ )
	{
		
		//source.origin = source.origin + (0, randomintrange(-15, 15), randomintrange(-15, 15) );
		MagicBullet( "ak47", source.origin, targets[ind].origin + ( randomfloatrange(randMin, randMax), randomfloatrange(randMin, randMax), randomfloatrange(randMin, randMax) ) );
		//MagicBullet( "ak47", source.origin, source.origin + (1, randomfloatrange(-0.5, 0.5), randomfloatrange(-0.5, 0.5) ) );
		
		//10% chance to play rumble
		if( randomint(100) < 10 )
			level.player PlayRumbleOnEntity( "damage_light" );
		
		ind++;
		if( ind >= targets.size )
		{
			targets = array_randomize( targets );
			ind = 0;
		}
		
		wait 0.1;
	}
	
	//source delete();
}

reactor_room_robot_grid_ally_safeguard()
{
	level endon( "elevator_ascend" );
	
	volume = getent( self.target, "targetname" );
	dest = getstruct( volume.target, "targetname" );
	
	while( 1 )
	{
		self waittill( "trigger", ent );
		
		allies = GetAIArray( "allies" );
		
		foreach( ally in allies )
		{
			if( ally IsTouching( volume ) && !player_can_see_ai( ally ) && !player_looking_at( dest.origin, undefined, true ) )
				ally ForceTeleport( dest.origin, dest.angles );
		}
	}
}

//reactor_room_bad_places()
//{
//	volumes = GetEntArray( "reactor_room_bad_place_allies", "targetname" );
//	
//	foreach( i, vol in volumes )
//	{
//		BadPlace_Brush( "reactor_room_bad_place_allies" + i, 0, vol, "allies" );
//	}
//	
//	flag_wait( "elevator_ascend" );
//	
//	foreach( i, vol in volumes )
//	{
//		BadPlace_Delete( "reactor_room_bad_place_allies" + i );
//	}
//}

reactor_room_drones()
{
	flag_wait( "reactor_drones_1" );
	
	flying_attack_drone_system_init();
	
	reactor_drones_1 = [];
	reactor_drones_1[reactor_drones_1.size] = thread start_flying_attack_drone( "reactor_drone_1" );
	reactor_drones_1[reactor_drones_1.size] = thread start_flying_attack_drone( "reactor_drone_2" );
	
//	reactor_drones_1 = spawn_vehicles_from_targetname_and_drive ( "reactor_drones_1" );
	foreach( drone in reactor_drones_1 )
	{
//		drone thread use_phantom_drone_model();
		drone thread maps\_shg_utility::make_emp_vulnerable();
		drone LaserForceOn();
		drone thread reactor_room_drone_cleanup();
	}
	
	flag_wait( "reactor_drones_2" );
	
	reactor_drones_2 = [];
	reactor_drones_2[reactor_drones_2.size] = thread start_flying_attack_drone( "reactor_drone_3" );
	reactor_drones_2[reactor_drones_2.size] = thread start_flying_attack_drone( "reactor_drone_4" );
//	reactor_drones_2 = spawn_vehicles_from_targetname_and_drive ( "reactor_drones_2" );
	foreach( drone in reactor_drones_2 )
	{
//		drone thread use_phantom_drone_model();
		drone thread maps\_shg_utility::make_emp_vulnerable();
		drone LaserForceOn();
		drone thread reactor_room_drone_cleanup();
	}
}

reactor_room_drone_cleanup()
{
	self endon( "death" );
	
	flag_wait( "reactor_room_end_combat" );
	
	wait RandomFloatRange( 1, 3 );
	
	self kill();
}

reactor_room_crane()
{
//	wait 10;
	
	level waittill( "reactor_room_reveal_scene_started" );
	
//	level endon( "elevator_ascend" );
	
//	crane_pivot = getent( "reactor_crane_track", "targetname" );
	
	crane_tracks = getentarray( "reactor_crane_track", "targetname" );
	
	crane_params = [];
	
	reactor_crane_track_inner = getstruct( "reactor_crane_track_inner", "targetname" );
	reactor_crane_track_outer = getstruct( reactor_crane_track_inner.target, "targetname" );
	crane_params["min_dist"] = int( Distance( crane_tracks[0].origin, reactor_crane_track_inner.origin ) );
	crane_params["max_dist"] = int( Distance( crane_tracks[0].origin, reactor_crane_track_outer.origin ) );
	
	crane_height_top = getstruct( "reactor_crane_height_top", "targetname" );
	crane_height_bottom = getstruct( crane_height_top.target, "targetname" );
	crane_params["crane_height_delta"] = Distance( crane_height_top.origin, crane_height_bottom.origin );
	
	crane_params["rot_speed"] = 30;
	crane_params["rot_delay"] = 0.1;
	crane_params["crane_housing_move_speed"] = 75;
	
	crane_params["crane_housing_move_delay"] = 1;
	
	crane_params["height_time"] = 2.5;
	crane_params["height_acc"] = 0.5;
	crane_params["height_dec"] = 1.5;
	crane_params["lower_delay"] = 1;
	crane_params["raise_delay"] = 1;
	
	crane_params["crate_height"] = 72;
	
	crane_params["cable_height"] = 40;
	
	level.reactor_room_crate_tracking = [];
	level.reactor_room_crate_tracking[ "scripted_crate" ] = 0;
	level.reactor_room_crate_tracking[ "near_player" ] = 0;
	level.reactor_room_crate_tracking[ "near_enemies" ] = 0;
	
	crates = GetEntArray( "reactor_cover_crate", "script_noteworthy" );
	array_thread( crates, ::reactor_room_crate_think );
	
	crane_tracks = getentarray( "reactor_crane_track", "targetname" );
	
	crane_tracks[0] thread reactor_room_crane_think( crane_params, "north", crates );
	crane_tracks[1] thread reactor_room_crane_think( crane_params, "south", crates );
	
}

crane_cable( crane, crane_params )
{
	cable = self;

	while ( IsDefined( cable.target ) )
	{
		cable = GetEnt( cable.target, "targetname" );
		cable Hide();
	}

	cable_length = crane_params[ "cable_height" ];
	
//	crane 	 = self.elevator;
//	elevator.cable = self;
//	cable 		 = self;
//	housing 	 = self.elevator_model;
//	cable.wheels 	 = self.wheels;

//	level.velF = ( 0, 0, 200 );
//	level.velR = ( 0, 0, -200 );
//	level.ELEV_CABLE_HEIGHT = CONST_ELEV_CABLE_HEIGHT;
	
	while ( 1 )
	{
		crane reactor_room_link_cables( self, true );
		//start at the top
		//moving down
		crane waittill( "crane_moving" );
			crane reactor_room_link_cables( self, false );
			snd_message("crane_claw_drop_start", crane);
			crane crane_animated_down( self, crane, crane_params );
		//stopped	
		crane waittill( "crane_stopped" );
			snd_message("crane_claw_drop_stop", crane);
		//moving back up
		crane waittill( "crane_moving" );
			snd_message("crane_claw_rise_start", crane);
			crane crane_animated_up( self, crane, crane_params );
		//stopped	
		crane waittill( "crane_stopped" );
			snd_message("crane_claw_rise_stop", crane);
		
	}
}

crane_animated_down( cable, crane, crane_params )
{
//	wheels = cable.wheels;
	cable thread crane_cable_down( crane, crane_params );
//	wheels[ "top" ] RotateVelocity( level.velF, moveTime, 1, 1 );
//	wheels[ "bottom" ] RotateVelocity( level.velR, moveTime, 1, 1 );
}

crane_animated_up( cable, crane, crane_params )
{
//	wheels = cable.wheels;
	crane.last_cable thread crane_cable_up( crane );
//	wheels[ "top" ] RotateVelocity( level.velR, moveTime, 1, 1 );
//	wheels[ "bottom" ] RotateVelocity( level.velF, moveTime, 1, 1 );
}

crane_cable_down( crane, crane_params )
{
	self attach_housing( crane );

	crane endon( "crane_stopped" );

	while ( DistanceSquared( self.og, self GetOrigin() ) < squared( crane_params[ "cable_height" ] ) )
		wait .05;

	if ( !isdefined( self.target ) )
		return;

	next_cable = GetEnt( self.target, "targetname" );
	next_cable thread crane_cable_down( crane, crane_params );
}

attach_housing( crane )
{
	self.og = self GetOrigin();
	self LinkTo( crane );
	crane.last_cable = self;

	if ( !isdefined( self.target ) )
		return;

	next_cable = GetEnt( self.target, "targetname" );
	next_cable Show();
}

crane_cable_up( crane )
{
	crane endon( "crane_stopped" );

	while ( DistanceSquared( self.og, self GetOrigin() ) > squared( 10 ) )
		wait .05;

	self thread detach_housing( crane );

	if( IsDefined( self.script_noteworthy) && self.script_noteworthy == "crane_cable" )
		return;

	prev_cable = GetEnt( self.targetname, "target" );
	prev_cable thread crane_cable_up( crane );
}

detach_housing( crane )
{
	if( IsDefined( self.script_noteworthy) && self.script_noteworthy == "crane_cable" )
		return;
	self Unlink();
	time = .5;
	self MoveTo( self.og, time );
	wait time;
	self Hide();
}

reactor_room_crane_think( crane_params, crane_id, crates )
{	
	level endon( "elevator_ascend" );
	
	crane_track = self;
	crane_housing = GetEnt( crane_track.target, "targetname" );
	crane_parts = GetEntArray( crane_housing.target, "targetname" );
	crane = undefined;
	crane_trigger = undefined;
	foreach( part in crane_parts )
	{
		if( part.classname == "script_model" )
			crane = part;
		else
			crane_trigger = part;
	}
	
	crane.animname = "reactor_crane";
	crane SetAnimTree();
	crane thread anim_first_frame_solo( crane, "crane_opened" );
	
	cable = GetEnt( crane.target, "targetname" );
	
	cable thread crane_cable( crane, crane_params );
	
	crane LinkTo( crane_housing );
	crane_housing LinkTo( crane_track );
	
	crane_track.track_inner = spawn_tag_origin();
    crane_track.track_inner.origin = crane_track.origin + (742, 0, 0);
    crane_track.track_inner LinkTo( crane_track );
    crane_track.track_inner thread delete_on_notify( "reactor_room_cleanup" );
    
    crane_track.track_outer = spawn_tag_origin();
    crane_track.track_outer.origin = crane_track.origin + (1354, 0, 0);
    crane_track.track_outer LinkTo( crane_track );
    crane_track.track_outer thread delete_on_notify( "reactor_room_cleanup" );
    
    crane_housing_org = spawn_tag_origin();
   	crane_housing_org.origin = crane_housing.origin;
   	crane_housing_org linkto( crane_housing );
   	crane_housing_org thread delete_on_notify( "reactor_room_cleanup" );
   	
   	crane_org = spawn_tag_origin();
   	crane_org.origin = crane.origin;
   	crane_org linkto( crane );
   	crane_org thread delete_on_notify( "reactor_room_cleanup" );
  
   	crane_trigger EnableLinkTo();
   	crane_trigger LinkTo( crane );
   	
    crane thread reactor_room_crane_light();

//	crane_track LinkTo( crane_pivot );
	
//	index = 0;
	
//	foreach( crate in crates )
//	{
//		thread print3dUntilNotify( crate.origin, VectorToAngles( crate.origin - crane_track.origin )[1] + 160, (1, 1, 1), 1, 2, "forever" );
//	}
	
	//determine valid crates for each crane
	validCrates = [];
	foreach( crate in crates )
	{
		rot_angle = VectorToAngles( crate.origin - crane_track.origin )[1];
		
		if( rot_angle < 20 )
			rot_angle+= 360;
		
		if( rot_angle < 200 && crane_id == "south" )
			continue;
		if( rot_angle >= 200 && crane_id == "north" )
			continue;
		
		validCrates[validCrates.size] = crate;
	}
	
	drop_off_angle = 175;
	if( crane_id == "south" )
	{
		drop_off_angle = 200;
		reactor_room_crane_rotate_to_angle( crane_track, 200, crane_params["rot_speed"], crane_params["rot_delay"] );
		flag_wait( "reactor_room_crane_south_start" );
	}
	else
	{
		wait 15;
	}
		
//	crane reactor_room_link_cables( cable );
		
	while( 1 )
	{
		//don't overlap drop off locations
		if( crane_id == "north" && flag( "reactor_room_crane_south_start" ) )
			break;
		if( validCrates.size == 0 )
			break;
		
		crate = reactor_room_get_best_crate( validCrates, crane_id );
		
		validCrates = array_remove( validCrates, crate );
		
		rot_angle = VectorToAngles( crate.origin - crane_track.origin )[1];
		
//		crane reactor_room_link_cables( cable, true );
		
		
   		
		reactor_room_crane_rotate_to_angle( crane_track, rot_angle, crane_params["rot_speed"], crane_params["rot_delay"] );
		
		//adjust housing location
		dist = Distance2D( crane_track.origin, crate.origin );
		crane_housing unlink();
		
		//play vfx on crane as it moves from one housing location to another in an area that it will actually pick up a crate
   		PlayFXOnTag(getfx( "fus_crane_housing_dust_fall" ), crane_housing_org, "tag_origin" );
		
		reactor_room_crane_adjust_housing( crane_track, crane_housing, rot_angle, dist, crane_params["crane_housing_move_speed"], crane_params["crane_housing_move_delay"] );
		crane_housing LinkTo( crane_track );
		
		//lower crane
		crane unlink();
		original_pos = crane.origin;
		crane notify( "crane_moving" );
		
		//play vfx on crane as it releases from housing to go down
		PlayFXOnTag(getfx( "fus_crane_housing_dust" ), crane_org, "tag_origin" );
		
		crane MoveTo( crate.origin + (0, 0, crane_params["crate_height"]), crane_params["height_time"], crane_params["height_acc"], crane_params["height_dec"] );
		wait crane_params["height_time"];
		
		crane notify( "crane_stopped" );
//		wait crane_params["lower_delay"];
		
		thread reactor_room_crane_grab_crate( crane, crate, crane_params );
		crane waittill ( "crate_grabbed" );
		
		
		
		//play vfx from actual crate as it is lifted
		crate_org = spawn_tag_origin();
   		crate_org.origin = crate.origin; //add an offset here if you want (e.g. at the top of the crate)
   		crate_org linkto( crate );
   		PlayFXOnTag (getfx( "fus_crate_dust_lift" ), crate_org, "tag_origin" );
   		
		crate notify( "crate_raised" );
		
		level notify( "crate_raising" );
		
		//raise crane
		crane notify( "crane_moving" );
		crane MoveTo( original_pos, crane_params["height_time"], crane_params["height_acc"], crane_params["height_dec"] );
		wait crane_params["height_time"];
		crane notify( "crane_stopped" );
		wait crane_params["raise_delay"];
		crane LinkTo( crane_housing );
		
		//move to drop-off location
		rot_angle = drop_off_angle;
		
		
		reactor_room_crane_rotate_to_angle( crane_track, rot_angle, crane_params["rot_speed"], crane_params["rot_delay"] );
		dist = RandomIntRange( crane_params["min_dist"], crane_params["max_dist"] );
		
		
		crane_housing unlink();
		
		
		reactor_room_crane_adjust_housing( crane_track, crane_housing, rot_angle, dist, crane_params["crane_housing_move_speed"], crane_params["crane_housing_move_delay"] );
		crane_housing LinkTo( crane_track );
		
		//lower crane
		crane notify( "crane_moving" );
		crane unlink();
		crane MoveTo( crane.origin - (0, 0, crane_params["crane_height_delta"]), crane_params["height_time"], crane_params["height_acc"], crane_params["height_dec"] );
		wait crane_params["height_time"];
		crane notify( "crane_stopped" );
		wait crane_params["lower_delay"];
		crane notify ( "crate_release" );
		crate_org delete();
		wait 0.05;
		//raise crane
		crane notify( "crane_moving" );
		crane MoveTo( crane.origin + (0, 0, crane_params["crane_height_delta"]), crane_params["height_time"], crane_params["height_acc"], crane_params["height_dec"] );
		wait crane_params["height_time"];
		crane notify( "crane_stopped" );
		wait crane_params["raise_delay"];
		crane LinkTo( crane_housing );
		
	}
	
	//random crane movement
	while( 1 )
	{
		switch ( crane_id )
		{
			case "north":
				rot_angle = RandomIntRange( 25, 180);
				break;
		
			case "south":
			default:
				rot_angle = RandomIntRange( 180, 360 );
				break;
		}
		
//		rot_angle = RandomInt(360);
		dist = RandomIntRange( crane_params["min_dist"], crane_params["max_dist"] );
		
		reactor_room_crane_rotate_to_angle( crane_track, rot_angle, crane_params["rot_speed"], crane_params["rot_delay"] );
		
   
   		
		//adjust housing location
		crane_housing unlink();
		
		//play dust vfx on crane housing as it adjusts its positio
   		PlayFXOnTag(getfx( "fus_crane_housing_dust_fall" ), crane_housing_org, "tag_origin" );
		
		reactor_room_crane_adjust_housing( crane_track, crane_housing, rot_angle, dist, crane_params["crane_housing_move_speed"], crane_params["crane_housing_move_delay"] );
		crane_housing LinkTo( crane_track );
		
		//lower crane
//		crane unlink();
//		crane MoveTo( crane.origin - (0, 0, crane_params["crane_height_delta"]), crane_params["height_time"], crane_params["height_acc"], crane_params["height_dec"] );
//		wait crane_params["height_time"] + crane_params["lower_delay"];
//		
//		//raise crane
//		crane MoveTo( crane.origin + (0, 0, crane_params["crane_height_delta"]), crane_params["height_time"], crane_params["height_acc"], crane_params["height_dec"] );
//		wait crane_params["height_time"] + crane_params["raise_delay"];
//		crane LinkTo( crane_housing );
		
		wait RandomFloatRange( 3, 7 );
	}
	
}

reactor_room_crane_grab_crate( crane, crate, crane_params )
{
	crane anim_single_solo( crane, "crane_grab" );
	crane thread anim_first_frame_solo( crane, "crane_closed" );
	snd_message("crane_claw_crate_grab", crane);
	crate LinkTo( crane );
	wait 0.05;
	crane notify ( "crate_grabbed" );
		
	crane waittill ( "crate_release" );
	crane thread anim_first_frame_solo( crane, "crane_opened" );
	snd_message("crane_claw_crate_release", crane);
	crate delete();
	
}

reactor_room_crane_light()
{
	level endon( "elevator_ascend" );
	crane_org = spawn_tag_origin();
   	crane_org.origin = self.origin;
   	crane_org.angles = self.angles;
   	crane_org linkto( self );
   	crane_org thread delete_on_notify( "reactor_room_cleanup" );
   	
   	while( !flag( "elevator_ascend" ) )
   	{
	   	PlayFXOnTag(getfx( "fus_crane_light_red" ), crane_org, "tag_origin" );
	   	self waittill( "crate_grabbed" );
	   	StopFXOnTag(getfx( "fus_crane_light_red" ), crane_org, "tag_origin" );
	   	PlayFXOnTag(getfx( "fus_crane_light_green" ), crane_org, "tag_origin" );
	   	self waittill( "crate_release" );
	   	StopFXOnTag(getfx( "fus_crane_light_green" ), crane_org, "tag_origin" );
   	}
}

reactor_room_link_cables( cable, link )
{
	current_cable = cable;
	if( link )
		current_cable linkto( self );
	else
		current_cable unlink();
//	current_cable = GetEnt( current_cable.target, "targetname" );
	
	
	while( IsDefined( current_cable.target ) )
	{
		current_cable = GetEnt( current_cable.target, "targetname" );
		if( link )
			current_cable linkto( self );
		else
			current_cable unlink();
	}
}

reactor_room_get_best_crate( crates, crane_id )
{
	assertex( crates.size > 0, "No valid crates to find." );
	
	player_dist_sq = 100*100;
	enemy_dist_sq = 100*100;
	
	player_view_dist_sq = 1000*1000;
	
	crate_offset = (0, 0, 32 );
	fov = 65;
	
	if( level.reactor_room_crate_tracking[ "scripted_crate" ] < 1 )
	{
		level.reactor_room_crate_tracking[ "scripted_crate" ]++;
		thread reactor_room_allies_run_from_crate();
		return getClosest( (3290, 3676, -601), crates, 200 );
	}
	
	//check crates near player
	if( level.reactor_room_crate_tracking[ "near_player" ] < 1 )
	{
		foreach( crate in crates )
		{
//			if( !IsDefined( crate ) )
//				continue;
			
	//		if( crate.reserved )
	//			continue;
			
			if( (DistanceSquared( crate.origin, level.player.origin ) < player_dist_sq) )
			{
				level.reactor_room_crate_tracking[ "near_player" ]++;
				return crate;
			}
		}
	}
	
	if( level.reactor_room_crate_tracking[ "near_enemies" ] < 3 )
	{
		foreach( crate in crates )
		{
			foreach( ai in GetAIArray( "axis" ) )
			{
				if( DistanceSquared( crate.origin, ai.origin ) < enemy_dist_sq )
				{
					//make sure it's within a good range
					if( DistanceSquared( level.player.origin, crate.origin ) < player_view_dist_sq )
					{
						level.reactor_room_crate_tracking[ "near_enemies" ]++;
						return crate;
					}
				}
			}
		}
	}
	
	foreach( crate in crates )
	{
		//check that it's in the FOV
		if( level.player WorldPointInReticle_Circle( crate.origin + crate_offset, fov, 500 ) )
		{
			//make sure it's within a good range (outside too near, inside good view
			if( DistanceSquared( level.player.origin, crate.origin ) > player_dist_sq )
			{
				if( DistanceSquared( level.player.origin, crate.origin ) < player_view_dist_sq )
					return crate;
			}
		}
	}
	
	// smart logic failed, grab any crate
	return crates[RandomInt( crates.size )];
}

reactor_room_crane_rotate_to_angle( crane_track, angle, speed, delay )
{
	if( angle >= 360 )
		angle = angle - 360;
	time = abs( crane_track.angles[1] - angle ) / speed;
	
	acc = 2;
	dec = 2;
	
	if( time < 2 )
		time = 2;
	
	if( time < 4 )
	{
		acc = time / 2;
		dec = time / 2;
	}
	
	if( time > 0 )
	{
   		PlayFXOnTag(getfx( "fus_crane_track_sparks" ), crane_track.track_inner, "tag_origin" );
   		PlayFXOnTag(getfx( "fus_crane_track_sparks" ), crane_track.track_outer, "tag_origin" );
   		snd_message("crane_mach_mvmnt_start",crane_track.track_inner, crane_track.track_outer);
   		
		crane_track RotateTo( (0, angle, 0), time, acc, dec );
		wait time;
		StopFXOnTag(getfx( "fus_crane_track_sparks" ), crane_track.track_inner, "tag_origin" );
		StopFXOnTag(getfx( "fus_crane_track_sparks" ), crane_track.track_outer, "tag_origin" );
   		snd_message("crane_mach_mvmnt_stop",crane_track.track_inner, crane_track.track_outer);

	}
	wait delay;
}

reactor_room_crane_adjust_housing( crane_track, crane_housing, angle, dist, speed, delay )
{
	x = cos( angle ) * dist;
	y = sin( angle ) * dist;
	pos = ( crane_track.origin[0] + x, crane_track.origin[1] + y, crane_housing.origin[2] );
	
	crane_housing_move_time = Distance( pos, crane_housing.origin ) / speed;
	if( crane_housing_move_time > 0 )
	{
		snd_message("crane_claw_mvmnt_start", crane_housing);
		crane_housing MoveTo( pos, crane_housing_move_time, crane_housing_move_time / 2, crane_housing_move_time / 2 );
		wait crane_housing_move_time;
		snd_message("crane_claw_mvmnt_stop", crane_housing);
	}
	wait delay;
}

reactor_room_crate_think()
{
	self DisconnectPaths();
	
//	self.reserved = false;
	
	crateModel = get_target_ent();
	crateModel linkto( self );
	
	self waittill( "crate_raised" );
	
	org = self.origin;
	BadPlace_Cylinder( "", 3, org, 80, 64, "axis", "allies" );
	nodes = GetNodesInRadius( org, 80, 0, 128, "Cover" );
	foreach( node in nodes )
	{
//		BadPlace_Cylinder( "", 3, node.origin, 32, 64, "axis", "allies" );
		node DisconnectNode();
	}

//	waitframe();
//	
//	guys = GetAIArray( "axis" );
//	foreach( guy in guys )
//	{
//		if( DistanceSquared( guy.origin, org ) < 80*80 )
//		{
//			guy SetGoalNode( guy FindBestCoverNode() ); 
//			guy flashBangStart( 0.05 );
//		}
//	}
	
	wait 3;
	
	self ConnectPaths();
	
	//
//	foreach( node in nodes )
//	{
//	//	BadPlace_Cylinder( "crate_removed", 3, node.origin, 100, 64, "axis", "allies" );
//		node DisconnectNode();
//	}
	
	self waittill( "death" );
	crateModel delete();
}

get_angle_from_center( origin, point )
{
	return VectorToAngles( point - origin )[1];
}

reactor_room_robots()
{
	flag_wait( "reactor_room_reveal_scene" );
	
	robots = getentarray( "reactor_bot", "targetname" );
	
	array_thread( getentarray( "reactor_bot", "targetname" ), ::reactor_room_robot_think );
	
	array_thread( GetEntArray( "reactor_bot_scripted", "targetname" ), ::reactor_room_robot_scripted_think );
}

reactor_room_robot_think()
{	
	level endon( "elevator_ascend" );
	self endon( "death" );
	self endon( "stop_movement" );
	
	self.health = 100;
	self SetCanDamage( true );
//	self thread reactor_room_robot();
	self thread reactor_room_robot_monitor_death();
	
	self thread maps\_shg_utility::make_emp_vulnerable();
	self.emp_death_function = ::reactor_room_robot_emp_death;
	
	self.facing = 1;
//	self.facing_original = self.angles
	
	track_start = getstruct( self.target, "targetname" );
	track_corner = getstruct( track_start.target, "targetname" );
	track_end = getstruct( track_corner.target, "targetname" );
	self.collision = getent( self.target, "targetname" );
	self.collision linkto( self );
	
	track_grid_size = 32;
	shelf_raise_height = (0, 0, 0.5);
	
	track_width = Distance( track_start.origin, track_corner.origin ) / track_grid_size + 1;
	track_length = Distance( track_corner.origin, track_end.origin ) / track_grid_size + 1;
	if( (track_width - int( track_width )) > .5 ) //fix rounding errors
	{
		track_width = int( track_width );
		track_width++;
	}
	else
	{
		track_width = int( track_width );
	}
	if( (track_length - int( track_length )) > .5 ) //fix rounding errors
	{
		track_length = int( track_length );
		track_length++;
	}
	else
	{
		track_length = int( track_length );
	}
	
	right = VectorToAngles( track_corner.origin - track_start.origin );
	up = VectorToAngles( track_end.origin - track_corner.origin );
	
//	iprintln( "track_width = " + track_width );
//	iprintln( "track_length = " + track_length );
	
	reactor_shelves = GetEntArray( track_end.target, "targetname" );
	//reactor_bots = GetEntArray( "reactor_bot", "targetname" );
	
	self.collision thread reactor_robots_badplace_think();
	array_thread( reactor_shelves, ::reactor_robots_shelf_think );
	
	track = [];
	
	//build track
	for( i = 0; i < track_width; i++ )
	{
		for( j = 0; j < track_length; j++ )
		{
			track[i][j] = SpawnStruct();//"(" + i + "," + j + ")";
			x = track_grid_size * i * cos( right[1] ) + track_grid_size * j * sin( -1 * right[1] );
			y = -1 * track_grid_size * i * cos( up[1] ) + track_grid_size * j * sin( up[1] );
			track[i][j].origin = (x, y, 0 ) + track_start.origin;
			
			shelf_present = false;
			foreach( shelf in reactor_shelves )
			{
				track_coords = track[i][j].origin;
				
				if( Distance( track[i][j].origin, shelf.origin ) < 16 )
				{
					track[i][j].shelf = true;
					shelf.x = i;
					shelf.y = j;
				}
			}
			
			if( Distance( track[i][j].origin, self.origin ) < 10 )
			{
				track[i][j].robot = true;
				self.x = i;
				self.y = j;
			}
			
//			foreach( bot in reactor_bots )
//			{
//				if( Distance( track[i][j].origin, bot.origin ) < 10 )
//				{
//					track[i][j].robot = true;
//					bot.x = i;
//					bot.y = j;
//				}
//			}
		}
	}
	
//	foreach( shelf in reactor_shelves )
//	{
//		thread print3dUntilNotify( shelf.origin, "(" + shelf.origin[0] + "," + shelf.origin[1] + ")", (1, 1, 1), 1, 1, "forever" );
//	}
	
	//wait 10000;
	
	//robot = reactor_bots[0];
	
	while( 1 )
	{
		foreach( shelf in reactor_shelves )
		{
			track = clear_path_weights( track );
			//determine path to specified shelf
			track = add_path_weights( track, shelf.x, shelf.y, 0, false );
			
			self notify( "update_path_weights" );
//			for( i = 0; i < track_width; i++ )
//			{
//				for( j = 0; j < track_length; j++ )
//				{
//					if( IsDefined( track[i][j].path_weight ) )
//						self thread print3dUntilNotify( track[i][j].origin, track[i][j].path_weight, (1, 1, 1), 1, 1, "update_path_weights" );
//				}
//			}
			
			//determine shelf destination
//			dest_x = 5;
//			dest_y = 1;
			
			
			//move to shelf
			self move_to_dest( track, shelf.x, shelf.y );
			
			//move shelf to new location
			track = clear_path_weights( track );
			
			attempt = 0;
			max_attempts = 10;
			
			//determine shelf path
			//if no path to any destination, continue
			dest_x = 0;
			dest_y = 0;
			
			while( (attempt <= max_attempts) &&
				  !( IsDefined( track[dest_x][dest_y].path_weight) && IsDefined( track[self.x][self.y].path_weight ) && (dest_x != self.x || dest_y != self.y) ) )
		    {
				dest_x = RandomInt(track_width);
				dest_y = RandomInt(track_length);
				track = clear_path_weights( track );
				track = add_path_weights( track, dest_x, dest_y, 0, true );
				attempt++;
				wait 0.05;
		    }
			
			if( attempt > max_attempts )
			{
				//iprintln( "no path to dest: " + dest_x + ", " + dest_y );
				wait 2;
				continue;
			}
			
			snd_message( "reactor_bot_shelf_pickup", self );
			shelf MoveTo( shelf.origin + shelf_raise_height, 0.2, 0.1, 0.1 );
			wait 0.2;
			
			//attach to shelf
			shelf LinkTo( self );
			self.shelf = shelf;
			
			self notify( "update_path_weights" );
//			for( i = 0; i < track_width; i++ )
//			{
//				for( j = 0; j < track_length; j++ )
//				{
//					if( IsDefined( track[i][j].path_weight ) )
//						self thread print3dUntilNotify( track[i][j].origin, track[i][j].path_weight, (1, 1, 1), 1, 1, "update_path_weights" );
//				}
//			}
			self move_to_dest( track, dest_x, dest_y );
			shelf.x = dest_x;
			shelf.y = dest_y;
			//unlink shelf
			shelf Unlink();
			self.shelf = undefined;
			
			snd_message( "reactor_bot_shelf_drop", self );
			shelf MoveTo( shelf.origin - shelf_raise_height, 0.2, 0.1, 0.1 );
			wait 0.2;
			//wait 120;
		}
	}
}

reactor_room_robot_emp_death()
{
	self endon( "death" );
	self notify( "stop_movement" );
	self notify( "emp" );
	
	PlayFXOnTag( getfx( "emp_reactor_robot_damage" ), self, "tag_origin" );
	self MoveTo( self.origin, 0.05 );
	self Rotateto( self.angles, 0.05 );
	wait RandomFloatRange( 0.5, 1.5 );
	StopFXOnTag( getfx( "emp_reactor_robot_damage" ), self, "tag_origin" );
	self notify( "death" );
}

reactor_room_robot_monitor_death()
{
	self endon( "emp" ); //if emp'd, don't do bullet death
	self endon( "robot_lowered" );
	
	self waittill( "death" );
	self notify( "stop_movement" );
	PlayFX( getfx( "reactor_robot_death" ), self.origin );
}

move_to_dest( track, x, y )
{
	self endon( "stop_movement" );
	move_time = 1;
	rot_time = 1;
	
	delay = 0.05;
	
	robot_shelf = IsDefined( self.shelf );
	
	while( !(self.x == x && self.y == y) )
	{
		dest = self get_next_grid_position( track, self.x, self.y );
		
		if( robot_shelf )
		{
			track[self.x][self.y].shelf = undefined;
		}
		
		//rotate without shelf
		if( self.facing_goal != self.facing )
		{
			if( robot_shelf )
				self.shelf Unlink();
				
			self.collision unlink();
			
			self RotateTo( self.angles + (0, 90 * (self.facing_goal - self.facing), 0), rot_time );
			self.facing = self.facing_goal;
			if( robot_shelf )
				snd_message( "reactor_bot_turn_shelf", self );
			else
				snd_message( "reactor_bot_turn_self", self );
			wait rot_time + delay;
			
			if( robot_shelf )
				self.shelf LinkTo( self );
			self.collision LinkTo( self );
		}
		
		//make sure npcs and player isn't in the way
		self wait_until_path_safe();
		
		if( robot_shelf )
			snd_message( "reactor_bot_drive_shelf_start", self );
		else
			snd_message( "reactor_bot_drive_self_start", self );
		self MoveTo( track[dest[0]][dest[1]].origin, move_time );
		wait move_time + delay;
		if( robot_shelf )
			snd_message( "reactor_bot_drive_shelf_stop", self );
		else
			snd_message( "reactor_bot_drive_self_stop", self );
		
		//update shelf positions
		if( robot_shelf )
		{
			track[dest[0]][dest[1]].shelf = true;
		}
		self.x = dest[0];
		self.y = dest[1];
	}
}

wait_until_path_safe()
{
	pathsafe = false;
	while( !pathsafe )
	{
		pathsafe = true;
		
		if( DistanceSquared( self.origin, level.player.origin ) < ROBOT_SAFE_PLAYER_RADIUS )
		{
			pathsafe = false;
			wait 0.5;
			continue;
		}
		
		foreach( guy in GetAIArray() )
		{
			if( DistanceSquared( self.origin, guy.origin ) < ROBOT_SAFE_AI_RADIUS )
			{
				pathsafe = false;
				wait 0.5;
				break;
			}
		}
	}
}

get_next_grid_position( track, x, y )
{
	current_weight = track[x][y].path_weight;
	track_max_x = track.size;
	track_max_y = track[0].size;
	
	cheapest = 999;
	dir = undefined;
	
	if( x > 0 )
	{
		new_weight = track[x-1][y].path_weight;
		if( IsDefined( new_weight ) )
		{
			if( new_weight < cheapest )
			{
				cheapest = new_weight;
				dir = "left";
			}
		}
	}
	if( x < (track_max_x-1) )
	{
		new_weight = track[x+1][y].path_weight;
		if( IsDefined( new_weight ) )
		{
			if( new_weight < cheapest )
			{
				cheapest = new_weight;
				dir = "right";
			}
		}
	}
	if( y > 0 )
	{
		new_weight = track[x][y-1].path_weight;
		if( IsDefined( new_weight ) )
		{
			if( new_weight < cheapest )
			{
				cheapest = new_weight;
				dir = "down";
			}
		}
	}
	if( y < (track_max_y-1) )
	{
		new_weight = track[x][y+1].path_weight;
		if( IsDefined( new_weight ) )
		{
			if( new_weight < cheapest )
			{
				cheapest = new_weight;
				dir = "up";
			}
		}
	}
	
	value = [];
	
	switch ( dir )
	{
		case "left":
			value = [x-1,y];
			self.facing_goal = 1;
			break;
		case "right":
			value = [x+1,y];
			self.facing_goal = 3;
			break;
		case "down":
			value = [x,y-1];
			self.facing_goal = 2;
			break;
		case "up":
			value = [x,y+1];
			self.facing_goal = 0;
			break;
		default:
			AssertMsg( "No cheapest value for path." );
			break;
	}
	
	return value;
}

clear_path_weights( track )
{
	for( i = 0; i < track.size; i++ )
	{
		for( j = 0; j < track[i].size; j++ )
		{
			track[i][j].path_weight = undefined;
		}
	}
	return track;
}

add_path_weights( track, x, y, new_dist, check_for_obstacles )
{
	if( check_for_obstacles && IsDefined(track[x][y].shelf) && track[x][y].shelf && !(self.x == x && self.y == y) )
	{
		track[x][y].path_weight = undefined;
		return track;
	}
	path_weight = track[x][y].path_weight;
	track_max_x = track.size;
	track_max_y = track[0].size;
	
	if( new_dist > 25 ) //too long for current recursion depth
		return track;
	
	if( !IsDefined( path_weight ) || path_weight > new_dist )
	{
		track[x][y].path_weight = new_dist;
		
		new_dist++;
		
		if( x > 0 )
			track = add_path_weights( track, x-1, y, new_dist, check_for_obstacles );
		if( x < (track_max_x-1) )
			track = add_path_weights( track, x+1, y, new_dist, check_for_obstacles );
		if( y > 0 )
			track = add_path_weights( track, x, y-1, new_dist, check_for_obstacles );
		if( y < (track_max_y-1) )
			track = add_path_weights( track, x, y+1, new_dist, check_for_obstacles );
	}
	
	return track;
}

reactor_robots_shelf_think()
{
	ents = GetEntArray( self.target, "targetname" );
	
	foreach( ent in ents )
	{
		ent linkto( self );
	}
	
	self reactor_robots_badplace_think();
}

reactor_robots_badplace_think()
{
	duration = 0.1;
	radius = 31;
	height = 128;
	
	//break out when player leaves area
	while( !flag( "elevator_ascend" ) )
	{
		self ConnectPaths();
//		BadPlace_Cylinder( "", duration, self.origin, radius, height, "axis", "allies" );
		self DisconnectPaths();
		wait duration;
	}
	
	self ConnectPaths();
}

reactor_room_robot_scripted_think()
{
	level endon( "elevator_ascend" );
	
	
	//set up entities
//	structs = getstructarray( self.target, "targetname" );
	ents = GetEntArray( self.target, "targetname" );
	ents = array_combine( ents, getstructarray( self.target, "targetname" ) );
	start_node = undefined;
	initial_gate = undefined;
	initial_lift = undefined;
	final_lift = undefined;
	final_gate = undefined;
	shelf = undefined;
	
	rot_time = 1;
	
	shelf_height = [];
	shelf_height[shelf_height.size] = 18;
	shelf_height[shelf_height.size] = 36;
	shelf_height[shelf_height.size] = 54;
	
	foreach( ent in ents )
	{
		switch ( ent.script_parameters )
		{
			case "start_node":
				start_node = ent;
				break;
				
//			case "initial_gate":
//				initial_gate = ent;
//				break;
			
			case "initial_lift":
				lifts = getentarray( "reactor_robot_lift", "script_noteworthy" );
				foreach( lift in lifts )
				{
					if( distance( lift.origin, ent.origin ) < 10 )
					{
						initial_lift = lift;
						break;
					}
				}
//				final_lift = ent;
				break;
			case "initial_lift_gate":
				initial_gates = GetEntArray( "bot_lift_gate", "script_noteworthy" );
				foreach( gate in initial_gates )
				{
					if( distance( gate.origin, ent.origin ) < 10 )
					{
						initial_gate = gate;
						break;
					}
				}
//				final_gate = ent;
				break;
				
			case "final_lift":
				lifts = getentarray( "reactor_robot_lift", "script_noteworthy" );
				foreach( lift in lifts )
				{
					if( distance( lift.origin, ent.origin ) < 10 )
					{
						final_lift = lift;
						break;
					}
				}
//				final_lift = ent;
				break;
				
			case "final_gate":
				gates = getentarray( "reactor_robot_final_gate", "script_noteworthy" );
				foreach( gate in gates )
				{
					if( distance( gate.origin, ent.origin ) < 10 )
					{
						final_gate = gate;
						break;
					}
				}
//				final_gate = ent;
				break;
				
			case "shelf":
				shelf = ent;
				shelf thread reactor_robots_badplace_think();
//				shelf.models = [];
//				shelf.itemContents = [];
				//link collision and shelf contents
//				ents = getentarray( shelf.target, "targetname" );
//				foreach( ent in ents )
//				{
//					if( ent.classname == "script_brushmodel" )
//						ent thread reactor_robots_badplace_think();
////					else
////						shelf.items[shelf.items.size] = ent;
//					ent linkto( shelf );
//				}
				break;
				
			default:
				break;
		}
	}
	
	if( !IsDefined( start_node ) )
	{
		AssertMsg( "Start node not defined for reactor room robot lift at " + self.origin );
		return;
	}
//	if( !IsDefined( initial_gate ) )
//	{
//		AssertMsg( "Initial gate not defined for reactor room robot lift at " + self.origin );
//		return;
//	}
	if( !IsDefined( initial_lift ) )
	{
		AssertMsg( "Initial lift not defined for reactor room robot lift at " + self.origin );
		return;
	}
	if( !IsDefined( initial_gate ) )
	{
		AssertMsg( "Initial gate not defined for reactor room robot lift at " + self.origin );
		return;
	}
	if( !IsDefined( final_lift ) )
	{
		AssertMsg( "Final lift not defined for reactor room robot lift at " + self.origin );
		return;
	}
	if( !IsDefined( final_gate ) )
	{
		AssertMsg( "Final gate not defined for reactor room robot lift at " + self.origin );
		return;
	}
	if( !IsDefined( shelf ) )
	{
		AssertMsg( "Shelf not defined for reactor room robot lift at " + self.origin );
		return;
	}
	
	botMoveSpeed = 1;
	botWidth = 32;
	
	finalLiftDescentTime = 4;
	
	initialGateRaiseHeight = 64;
	initialGateMoveTime = 3;
	initialGateAcc = 1;
	initialGateDec = 1;
	
//	initialLiftRaiseHeight = 64;
	initialLiftMoveTime = 3;
	initialLiftAcc = 1;
	initialLiftDec = 1;
	initialLiftRaiseDelay = 1;
	
	initialGateRaiseHeight = 44;
	initialGateDelay = initialLiftMoveTime;
	initialGateMoveTime = initialLiftMoveTime / 2;
	initialGateAcc = initialGateMoveTime / 2;
	initialGateDec = initialGateMoveTime / 2;
	
//	initialGateRaiseHeight = 128;
	finalGateMoveTime = 1;
	finalGateAcc = 0.5;
	finalGateDec = 0.5;
	final_gate_closed_position = getstruct( final_gate.target, "targetname" ).origin;
	final_gate_open_position = final_gate.origin;
	
	finalLiftRaiseHeight = 128;
	finalLiftMoveTime = 3;
	finalLiftAcc = 1;
	finalLiftDec = 1;
	
//	shelf linkto( self );
	
	initial_lift.bars = [];
	final_lift.bars = [];
	roll_bars = getstructarray( "lift_bars", "targetname" );
	foreach( struct in roll_bars )
	{
//		pivot = bar get_target_ent();
//		bar LinkTo( pivot );
			
		if( distance( struct.origin, initial_lift.origin ) < 64 )
		{
			initial_lift.bars[initial_lift.bars.size] = struct;
			bars = GetEntArray( struct.target, "targetname" );
			foreach( bar in bars )
			{
				bar linkto( initial_lift );
//				pivot linkto( initial_lift );
			}
		}
		else if( distance( struct.origin, final_lift.origin ) < 64 )
		{
			final_lift.bars[final_lift.bars.size] = struct;
			bars = GetEntArray( struct.target, "targetname" );
			foreach( bar in bars )
			{
				bar linkto( final_lift );
//				pivot linkto( final_lift );
			}
		}
	}
	
//	start_bars = undefined;
//	roll_bars = getstructarray( "lift_start", "targetname" );
//	foreach( bar in roll_bars )
//	{
//		if( distance( bar.origin, initial_lift.origin ) < 64 )
//		{
//			start_bars = bar;
//			break;
//		}
//	}
//	
//	end_bars = undefined;
//	roll_bars = getstructarray( "lift_dest", "targetname" );
//	foreach( bar in roll_bars )
//	{
//		if( distance( bar.origin, final_lift.origin ) < 64 )
//		{
//			end_bars = bar;
//			break;
//		}
//	}
	
	while( 1 )
	{
		//lower start bars
		reactor_room_robots_lift_adjust_bars( initial_lift, "lower", "initial" );
		
		wait RandomFloatRange( 1, 10 );
		
		//open start door
//		initial_gate MoveTo( initial_gate.origin + (0, 0, initialGateRaiseHeight), initialGateMoveTime, initialGateAcc, initialGateDec );
//		wait initialGateMoveTime;
		

		
//		//move out
		//populate shelf
		
//		self SetModel( "tag_origin" );
//		wait 0.05;
//		self SetModel( "fus_shelving_robot_01" );
		shelf linkto( self );
//		next_node = getstruct( start_node.target, "targetname" );
//		moveTime = botMoveSpeed * Distance( self.origin, next_node.origin ) / botWidth;
//		
		wait 0.05;
		currentAngle = start_node.angles; //VectorToAngles( next_node.origin - start_node.origin );
		startAngle = currentAngle;
		
		if( self.angles != start_node.angles )
		{
			self RotateTo( start_node.angles, 0.05 );
			wait 0.1;
		}
		
		botModel = spawn( "script_model", self.origin );
		botModel SetModel( "fus_shelving_robot_01" );
		botModel.angles = self.angles;
		botModel linkto( self );
		
//		botModel endon( "death" );
		botModel endon( "stop_movement" );
	
		botModel.health = 100;
		botModel SetCanDamage( true );
		botModel thread maps\_shg_utility::make_emp_vulnerable();
		botModel.emp_death_function = ::reactor_room_robot_emp_death;
		botModel thread reactor_room_robot_monitor_death();
		
		shelfModel = spawn( "script_model", self.origin );
		shelfModel SetModel( "fus_shelving_unit_cage_01" );
		shelfModel.angles = self.angles;
		shelfModel LinkTo( shelf );
		
		shelf.models = [];
		shelf.models[shelf.models.size] = botModel;
		shelf.models[shelf.models.size] = shelfModel;
		
		for( i = 0; i < 3; i++ )
		{
			if( cointoss() )
			{
				shelfItem = spawn( "script_model", self.origin + (0, 0, shelf_height[i]) );
				shelfItem SetModel( "fus_shelving_unit_item_01" );
				shelfItem.angles = self.angles + (0, 90, 0);
				shelfItem LinkTo( shelf );
				shelf.models[shelf.models.size] = shelfItem;
			}
		}
		
//		self MoveTo( next_node.origin, moveTime );
//		
//		wait moveTime;
//		
//		//close start door
//		initial_gate MoveTo( initial_gate.origin - (0, 0, initialGateRaiseHeight), initialGateMoveTime, initialGateAcc, initialGateDec );
		
		//lower lift
		self LinkTo( initial_lift );
		next_node = getstruct( start_node.target, "targetname" );
//		moveTime = botMoveSpeed * Distance( self.origin, next_node.origin ) / botWidth;
		initialLiftRaiseHeight = self.origin[2] - next_node.origin[2];
		snd_message( "reactor_bot_elevator_start_lp", initial_lift );
		initial_lift MoveTo( initial_lift.origin - (0, 0, initialLiftRaiseHeight), initialLiftMoveTime, initialLiftAcc, initialLiftDec);
		initial_gate delayCall( initialGateDelay, ::MoveTo, initial_gate.origin - (0, 0, initialGateRaiseHeight), initialGateMoveTime, initialGateAcc, initialGateDec );
		wait initialLiftMoveTime;
		snd_message( "reactor_bot_initial_elevator_stop", initial_lift );
		snd_message( "reactor_bot_elevator_stop_lp", initial_lift );
		
		//raise start bars
		reactor_room_robots_lift_adjust_bars( initial_lift, "raise", "initial" );
		
		//initial angle correction after descending
		self Unlink();
		exit_node = getstruct( next_node.target, "targetname" );
		newAngle = VectorToAngles( exit_node.origin - self.origin );
		if( abs( newAngle[1] - currentAngle[1]) > 2 )
		{
//			shelf unlink();
			wait 0.1;
			self RotateTo( newAngle, rot_time );
			snd_message( "reactor_bot_turn_self", self );
			wait rot_time + 0.1;
			currentAngle = newAngle;
			
//			shelf linkto( self );
			wait 0.1;
		}
		
		//raise lift
//		shelf LinkTo( self );
//		initial_lift delayCall( initialLiftRaiseDelay, ::MoveTo, initial_lift.origin + (0, 0, initialLiftRaiseHeight), initialLiftMoveTime, initialLiftAcc, initialLiftDec);
		//move off lift
		
		moveCount = 0;
		//move to end
		while( IsDefined( next_node.target ) )
		{
			next_node = getstruct( next_node.target, "targetname" );
			newAngle = VectorToAngles( next_node.origin - self.origin );
			
			if( abs( newAngle[1] - currentAngle[1]) > 2 )
			{
				shelf unlink();
				wait 0.1;
				self RotateTo( newAngle, rot_time );
				snd_message( "reactor_bot_turn_shelf", self );
				wait rot_time + 0.1;
				currentAngle = newAngle;
				
				shelf linkto( self );
				wait 0.1;
			}
			
			while( distance( self.origin, next_node.origin ) > (botWidth + 4) )
			{
				
				
				self wait_until_path_safe();
				
				snd_message( "reactor_bot_drive_shelf_start", self );
				self moveTo( VectorNormalize( next_node.origin - self.origin ) * 32 + self.origin, botMoveSpeed);
				moveCount++;
				wait botMoveSpeed;
				snd_message( "reactor_bot_drive_shelf_stop", self );
				if( moveCount == 2 )
				{
					snd_message( "reactor_bot_initial_elevator_start", initial_lift, initialLiftRaiseDelay );
					initial_lift delayCall( initialLiftRaiseDelay, ::MoveTo, initial_lift.origin + (0, 0, initialLiftRaiseHeight), initialLiftMoveTime, initialLiftAcc, initialLiftDec);
					initial_gate MoveTo( initial_gate.origin + (0, 0, initialGateRaiseHeight), initialGateMoveTime, initialGateAcc, initialGateDec );
				}
			}
			
			self wait_until_path_safe();
			
			snd_message( "reactor_bot_drive_shelf_start", self );
			moveTime = botMoveSpeed * Distance( self.origin, next_node.origin ) / botWidth;
			self MoveTo( next_node.origin, movetime );
			wait moveTime;
			snd_message( "reactor_bot_drive_shelf_stop", self );
		}
		
		//lower final bars
		reactor_room_robots_lift_adjust_bars( final_lift, "lower", "final" );
		
		//lower lift
		self linkto( final_lift );
		snd_message( "reactor_bot_final_elevator_start", final_lift );
		final_lift MoveTo( final_lift.origin - (0, 0, finalLiftRaiseHeight), finalLiftMoveTime, finalLiftAcc, finalLiftDec );
		
		//close lift door
		final_gate delayCall( 2, ::moveTo, final_gate_closed_position, finalGateMoveTime, finalGateAcc, finalGateDec );
		
		//teleport to start_node
		wait finalLiftMoveTime;
		self unlink();
//		shelf unlink();
		contents = self SetContents( 0 );
//		shelfContents = shelf SetContents( 0 );
//		for( i = 0; i < shelf.items.size; i++ )
//		{
//			shelf.items[i] hide();
//			shelf.itemContents[i] = shelf.items[i] SetContents( 0 );
//		}
		
		botModel notify( "robot_lowered" );
		
		foreach( model in shelf.models )
		{
			model delete();
		}
		
		self hide();
//		shelf hide();
		wait 0.5;
		self.origin = start_node.origin;
//		shelf.origin = start_node.origin;
		wait 0.5;
		self SetContents( contents );
//		shelf SetContents( shelfContents );
//		for( i = 0; i < shelf.items.size; i++ )
//		{
//			shelf.items[i] show();
//			shelf.items[i] SetContents( shelf.itemContents[i] );
//		}
		self show();
//		shelf show();
		//
//		shelf LinkTo( self );
		
		//raise final bars
		reactor_room_robots_lift_adjust_bars( final_lift, "raise", "final" );
		//raise lift
		snd_message( "reactor_bot_elevator_start_lp", final_lift );
		final_lift MoveTo( final_lift.origin + (0, 0, finalLiftRaiseHeight), finalLiftMoveTime, finalLiftAcc, finalLiftDec );
		snd_message( "reactor_bot_final_elevator_stop", final_lift, finalLiftMoveTime );
		snd_message( "reactor_bot_elevator_stop_lp", final_lift, finalLiftMoveTime );
		
		//open lift door
		final_gate moveTo( final_gate_open_position, finalGateMoveTime, finalGateAcc, finalGateDec );
		snd_message( "reactor_bot_elevator_open", final_gate );
	}
}

reactor_room_robots_lift_adjust_bars( lift, direction, bar_position )
{
	if( bar_position == "initial" )
		noteworthy = "start_bars";
	else
		noteworthy = "end_bars";
	
	source = undefined;
	
	bars = undefined;
	foreach( struct in lift.bars )
	{
		if( struct.script_noteworthy == noteworthy )
		{
			bars = struct;
		}
	}
	
	/#
		assertex( IsDefined( bars ), "Roll bars not defined for lift at " + lift.origin );
	#/
	
	delta = 45;
	dur = 1;
	acc = 0.5;
	dec = 0.5;
	
	if( direction == "raise" )
	{
		delta = delta * -1;
	}
	
	bars = GetEntArray( bars.target, "targetname" );
	
	roll_down_bar_left = undefined;
	roll_down_bar_right = undefined;
	foreach( bar in bars )
	{
		if( bar.script_noteworthy == "roll_down_bar_left" )
			roll_down_bar_left = bar;
		else
			roll_down_bar_right = bar;
		bar unlink();
	}
	
//	roll_down_bar_right_pivot = roll_down_bar_right get_target_ent();
//	roll_down_bar_right_pivot.origin = roll_down_bar_right.origin;
//	roll_down_bar_right linkto( roll_down_bar_right_pivot );
	roll_down_bar_right RotateRoll( delta, dur, acc, dec );
	
//	roll_down_bar_left_pivot = roll_down_bar_left get_target_ent();
//	roll_down_bar_left_pivot.origin = roll_down_bar_left.origin;
//	roll_down_bar_left linkto( roll_down_bar_left_pivot );
	roll_down_bar_left RotateRoll( delta, dur, acc, dec );
	wait dur;
	
	foreach( bar in bars )
	{
		bar unlink();
		bar linkto( lift );
	}
	wait 0.05;
}

reactor_room_allies_run_from_crate()
{
	level waittill( "crate_raising" );
	trigger = getent( "reveal_crate_color_trigger", "targetname" );
	if( isdefined( trigger ) )
		trigger activate_trigger();
}

reactor_room_redshirts()
{
	level endon( "turbine_elevator_reached_top" );
	while( 1 )
	{
		flag_wait( "reactor_redshirts_enable" );
		
		self.count++;
		
		guy = self spawn_ai();
		guy waittill( "death" );
		wait RandomFloatRange( 1, 5 );
	}
}

reactor_room_redshirt_cleanup()
{
	level waittill( "turbine_elevator_reached_top" );
	waittillframeend;
	array_call( GetEntArray( "reactor_redshirts", "script_noteworthy" ), ::delete );
}

reactor_room_combat()
{
	thread reactor_room_catwalk_combat();
	
	flag_wait( "reactor_room_end_combat" );
	
	level.burke disable_careful();
	level.joker disable_careful();
	level.carter disable_careful();
	
	wait 0.5;
	array_thread( GetAIArray( "axis" ), ::bloody_death, 5 );
}

reactor_room_catwalk_death()
{
	level endon( "elevator_ascend" );
	
	flag_wait( "reactor_room_catwalk_death" );
	
	struct = getstruct( "reactor_room_catwalk_death", "targetname" );
	
	//make sure player can't see the spawner
	fov = GetDvarInt( "cg_fov" );
	if( !level.player WorldPointInReticle_Circle( struct.origin, fov, 250 ) )
	{
//		IPrintLn( "didn't see spawner, go ahead" );
		guy = struct get_target_ent() spawn_ai();
//		guy SetContents( 0 );
//		struct thread anim_generic( guy, "reactor_room_catwalk_death" );
		guy.deathfunction = undefined;
//		guy.allowDeath = true;
//		guy.a.nodeath = true;
		guy.animname = "generic";
		guy set_deathanim( "reactor_room_catwalk_death" );
//		guy set_battlechatter( false );
		guy kill();

//		if( IsDefined( guy ) && IsAlive( guy ) )
//			guy kill();
		
//		wait 1.5;
//		if( IsDefined( guy ) )
//			guy startragdoll();
	}
}

reactor_room_catwalk_combat()
{
	level endon( "elevator_ascend" );
	
	trig = GetEnt( "reactor_room_below_catwalk", "targetname" );
	catwalk_struct = getstruct( "reactor_room_catwalk_struct", "targetname" );
	
	spawn_triggers = GetEntArray( "reactor_catwalk_spawner_test", "script_noteworthy" );
	array_thread( spawn_triggers, ::reactor_catwalk_spawner_trigger_think );
	
	while( 1 )
	{
		level waittill( "reactor_catwalk_spawner_trigger_hit" );
		
		//check if player is under the catwalk, then don't spawn guys above
		if( level.player IsTouching( trig ) )
		{
			wait 0.1;
			guys = GetAIArray( "axis" );
			foreach( guy in guys )
			{
				if( IsAlive( guy ) && (guy.origin[2] >= catwalk_struct.origin[2] ) && (Distance2DSquared( guy.origin, catwalk_struct.origin ) < (catwalk_struct.radius * catwalk_struct.radius)) )
				{
					guy thread bloody_death();
				}
			}
		}
	}
	
}

reactor_catwalk_spawner_trigger_think()
{
	self waittill( "trigger" );
	
	level notify( "reactor_catwalk_spawner_trigger_hit" );
}

turbine_room()
{
	thread turbine_room_elevator();
	//thread turbine_room_fx();
	thread turbine_room_explosion();
	thread turbine_room_entrance_steam();
	thread turbine_room_turbines();
	thread turbine_room_atmosphere();
	thread turbine_room_combat();
	thread turbine_room_pre_explosion();
}

turbine_room_elevator()
{
	turbine_elevator_badplace = getent( "turbine_elevator_badplace", "targetname" );
	BadPlace_Brush( "turbine_elevator_badplace", 0, turbine_elevator_badplace, "axis" );
	
	elevator_ascend_use_trigger = getent( "elevator_ascend_use_trigger", "targetname" );
	elevator_ascend_use_trigger setHintString( &"FUSION_OPERATE_ELEVATOR" );
	
//	elevator_cover = getent( "elevator_cover", "targetname" );
	elevator_cover_col = getent( "elevator_cover_col", "targetname" );
	
//	elevator_cover hide();
//	elevator_cover.contents = elevator_cover SetContents( 0 );
	elevator_cover_col NotSolid();
	
	deployable_cover_final_model = GetEnt( "deployable_cover_final_model", "targetname" );
	deployable_cover_final_model.contents = deployable_cover_final_model SetContents( 0 );
	deployable_cover_final_model hide();
	
	flag_wait( "turbine_elevator_enter" );	
	
	elevator_control = getent( "elevator_control", "targetname" );
	elevator_button = getent( "elevator_button", "targetname" );
	door_move_time = 6;
	inner_door_move_time = 4;
	
	animnode = getent( "turbine_elevator_animnode", "targetname" );
	animnode linkto( elevator_control );
	
	deployable_cover_final_model linkto( elevator_control );
	
	if( !IsDefined( level.turbine_room_elevator_ascent_time ) )
	{
		flag_set( "vo_turbine_elevator_near" );
		
//		animnode = spawn( "script_origin", struct.origin );
//		animnode.angles = struct.angles;
		ender = "stop_elevator_idle";
		
		level.burke thread turbine_room_elevator_think( animnode, ender );
		level.carter thread turbine_room_elevator_think( animnode, ender );
			
		old_radius = level.joker.goalradius;
		level.joker.goalradius = 16;
		
//		level.carter thread notify_delay( "goal", 1 );
		
		waittill_multiple_ents( level.burke, "goal", level.joker, "goal", level.carter, "goal" );
		
		flag_set( "update_obj_pos_turbine_elevator_button" );
	
		flag_set( "vo_turbine_elevator_ready" );
		
		level.joker.goalradius = old_radius;
		
		flag_set( "elevator_ascend_ready" );
		
		flag_wait( "elevator_ascend" );
		
		if ( level.currentgen )
		{
			UnloadTransient("fusion_middle_tr");
			LoadTransient("fusion_outro_tr");
		}

		flag_set( "update_obj_pos_turbine_elevator_ascent" );
		
		elevator_ascend_use_trigger delete();
		elevator_button SetModel( "fus_elevator_button_02" );
		
		level.joker thread turbine_room_elevator_think( animnode, ender, deployable_cover_final_model );
		
		snd_message("start_turbine_elevator");
			
		level.turbine_room_elevator_ascent_time = 10;
//		thread turbine_room_elevator_allies( elevator_control );
		elevator_door_bottom_1 = getent( "elevator_door_bottom_1", "script_noteworthy" ); //drop 51
		elevator_door_bottom_2 = getent( "elevator_door_bottom_2", "script_noteworthy" ); //drop 93
		elevator_door_bottom_3 = getent( "elevator_door_bottom_3", "script_noteworthy" ); //drop 140
		elevator_door_bottom_4 = getent( "elevator_door_bottom_4", "script_noteworthy" ); //raise 10
		if( IsDefined( elevator_door_bottom_1 ) )
		{
			elevator_door_bottom_1 moveto( elevator_door_bottom_1.origin + (0, 0, -51 ), door_move_time/2, door_move_time/6, door_move_time/6 );
			elevator_door_bottom_2 moveto( elevator_door_bottom_2.origin + (0, 0, -93 ), door_move_time*2/3, door_move_time/12, door_move_time/12 );
			elevator_door_bottom_3 moveto( elevator_door_bottom_3.origin + (0, 0, -140 ), door_move_time, door_move_time/18, door_move_time/18 );
			elevator_door_bottom_4 delayCall( door_move_time * 3/4, ::moveto, elevator_door_bottom_4.origin + (0, 0, 8 ), door_move_time/4, door_move_time/8, door_move_time/8 );
		
			elevator_inner_door_upper = GetEntArray( "elevator_inner_door_upper", "targetname" );
			elevator_inner_door_lower = GetEntArray( "elevator_inner_door_lower", "targetname" );
			
			foreach( part in elevator_inner_door_upper )
			{
				part moveto( part.origin + (0, 0, -80 ), inner_door_move_time, inner_door_move_time/6, inner_door_move_time/6 );
			}
			
			foreach( part in elevator_inner_door_lower )
			{
				part moveto( part.origin + (0, 0, 48 ), inner_door_move_time, inner_door_move_time/6, inner_door_move_time/6 );
			}
			delayThread( 0.5, ::flag_set, "vo_turbine_elevator" );
			
			elevator_cover_col Solid();
			elevator_cover_col linkto( elevator_control );
			
			wait door_move_time;
		}
	}
	else
	{
		elevator_cover_col Solid();
		elevator_cover_col linkto( elevator_control );
		flag_set( "update_obj_pos_turbine_elevator_button" );
	}
	
	level notify( "reactor_room_cleanup" );
	
	snd_message( "disable_turbine_elevator_trigger" );
	
	array_call( GetEntArray( "reactor_room_enemies", "script_noteworthy" ), ::delete );
	
	elevator_parts = GetEntArray( "turbine_room_elevator", "script_noteworthy" );
	foreach( part in elevator_parts )
	{
		part linkto( elevator_control );
	}
	
//	elevator_cover SetContents( elevator_cover.contents );
//	elevator_cover show();
	
	elevator_destination = getent( "elevator_destination", "targetname" );
	
	elevator_door_top_1 = getent( "elevator_door_top_1", "script_noteworthy" ); //drop 51
	elevator_door_top_2 = getent( "elevator_door_top_2", "script_noteworthy" ); //drop 93
	elevator_door_top_3 = getent( "elevator_door_top_3", "script_noteworthy" ); //drop 140
	elevator_door_top_4 = getent( "elevator_door_top_4", "script_noteworthy" ); //raise 10
	
//	elevator_door_top_1 DisconnectPaths();
	elevator_door_top_2 DisconnectPaths();
	elevator_door_top_3 DisconnectPaths();
	
	//duration = 10;
	if( level.turbine_room_elevator_ascent_time )
	{
		flag_wait( "joker_placing_turbine_elevator_cover" );

		elevator_control moveto( elevator_destination.origin, level.turbine_room_elevator_ascent_time, 2, 2 );
		wait level.turbine_room_elevator_ascent_time;
	}
	else
	{
		delta = elevator_destination.origin - elevator_control.origin;
		elevator_control.origin = elevator_control.origin + delta;
//		elevator_cover.origin = elevator_cover.origin + delta;
		elevator_cover_col.origin = elevator_cover_col.origin + delta;
	
//		animnode = getent( "turbine_elevator_animnode", "targetname" );
		animnode.origin += delta;
		
		anime = "turbine_elevator_exit";
		anime_idle = "turbine_elevator_idle";
		ender = "stop_elevator_idle";
		animnode thread anim_single_solo_run( level.burke, anime );
		animnode thread anim_single_solo_run( level.carter, anime );
		animnode thread anim_loop_solo( level.joker, anime_idle, ender );
		animnode thread notify_delay( ender, 5.5 );
		animnode delaythread( 5.5, ::anim_single_solo_run, level.joker, anime );
		
//		deployable_cover = spawn( "script_model", (0, 0, 0) );
//		deployable_cover.animname = "deployable_cover";
//		deployable_cover SetModel( "deployable_cover" );
//		deployable_cover SetAnimTree();
//		
//		animnode thread anim_first_frame_solo( deployable_cover, "deployable_cover_open_idle" );
		

	}
	
//	elevator_button SetModel( "prague_elevator_button" );
	
	elevator_cover_col DisconnectPaths();
	
//	elevator_door_top = getent( "elevator_door_top", "targetname" );
//	elevator_door_top moveto( elevator_door_top.origin + (0, 0, 128 ), 3 );
	
	elevator_inner_exit_door_upper = GetEntArray( "elevator_inner_exit_door_upper", "targetname" );
	elevator_inner_exit_door_lower = GetEntArray( "elevator_inner_exit_door_lower", "targetname" );
	
	if( IsDefined( elevator_door_top_1 ) )
	{
		
		elevator_door_top_1 moveto( elevator_door_top_1.origin + (0, 0, 51 ), door_move_time/2, door_move_time/6, door_move_time/6 );
		elevator_door_top_2 moveto( elevator_door_top_2.origin + (0, 0, 93 ), door_move_time*2/3, door_move_time/12, door_move_time/12 );
		elevator_door_top_3 moveto( elevator_door_top_3.origin + (0, 0, 140 ), door_move_time, door_move_time/18, door_move_time/18 );
		elevator_door_top_4 delayCall( door_move_time * 3/4, ::moveto, elevator_door_top_4.origin + (0, 0, -8 ), door_move_time/4, door_move_time/8, door_move_time/8 );
	
		elevator_inner_door_upper = GetEntArray( "elevator_inner_door_upper", "targetname" );
		elevator_inner_door_lower = GetEntArray( "elevator_inner_door_lower", "targetname" );
		
		foreach( part in elevator_inner_door_upper )
		{
			part moveto( part.origin + (0, 0, -80 ), inner_door_move_time, inner_door_move_time/6, inner_door_move_time/6 );
		}
		
		foreach( part in elevator_inner_door_lower )
		{
			part moveto( part.origin + (0, 0, 48 ), inner_door_move_time, inner_door_move_time/6, inner_door_move_time/6 );
		}
//		wait door_move_time;
	}
	
	foreach( part in elevator_inner_exit_door_upper )
	{
		part Unlink();
		part moveto( part.origin + (0, 0, 80 ), inner_door_move_time, inner_door_move_time/6, inner_door_move_time/6 );
	}
	
	foreach( part in elevator_inner_exit_door_lower )
	{
		part Unlink();
		part moveto( part.origin + (0, 0, -48 ), inner_door_move_time, inner_door_move_time/6, inner_door_move_time/6 );
	}
	
	//dust and steam fx that play when the turbine room door opens
	exploder (3501);
	exploder (3502);
	//exploder ( "fx_cover_deploy_impact" );
	
//	elevator_cover Unlink();
//	elevator_cover RotateTo( elevator_cover.angles + (0, 0, 90), 1, 0.25, 0 );
	
	level notify( "turbine_elevator_reached_top" );
	
	snd_message("stop_turbine_elevator");
	
	flag_set( "control_room_run_prep" );
	
	snd_message( "start_turbine_loop" );
	
	MUS_play( "paris_ac130_bridge" );
	
	flag_set( "update_obj_pos_turbine_room_1" );
	flag_set( "turbine_room_combat_start" );
	
	delayThread( 2, ::flag_set, "vo_turbine_room_entrance" );
	
	autosave_by_name( "turbine_elevator_complete" );
	
	wait 1;
//	elevator_door_top_1 ConnectPaths();
	elevator_door_top_2 ConnectPaths();
	elevator_door_top_3 ConnectPaths();
}

turbine_room_elevator_think( animnode, ender, deployable_cover_final_model )
{
	anime_enter = "turbine_elevator_enter";
	anime_idle = "turbine_elevator_idle";
	anime_exit = "turbine_elevator_exit";
	
	if( self == level.joker )
		level waittill( "joker_place_elevator_cover" );
	
	if( self == level.burke )
		wait 2;
	
	animnode anim_reach_solo( self, anime_enter );
	if( self == level.joker )
	{
		flag_set( "joker_placing_turbine_elevator_cover" );
		
		deployable_cover = spawn( "script_model", (0, 0, 0) );
		deployable_cover.animname = "deployable_cover";
		deployable_cover SetModel( "deployable_cover" );
		deployable_cover SetAnimTree();
		
		deployable_cover linkto( animnode );
		
		animnode thread anim_single_solo( deployable_cover, "deployable_cover_deploy" );
		delaythread ( 2.1, ::exploder, "fx_cover_deploy_impact" );
		delaythread ( 5.0, ::exploder, "fx_cover_deploy_impact_delay" );
		
		placement_delay = 5.4;
		
		deployable_cover_final_model delayCall( placement_delay, ::SetContents, deployable_cover_final_model.contents );
		deployable_cover_final_model delayCall( placement_delay, ::show );
		deployable_cover delayCall( placement_delay, ::delete );
	}
	self LinkTo( animnode );
	animnode anim_single_solo( self, anime_enter );
	animnode thread anim_loop_solo( self, anime_idle, ender );
	
	if( self == level.joker )
		wait 5.5;
	else
		level waittill( "turbine_elevator_reached_top" );
	
	self unlink();
	
	animnode notify( ender );
	animnode thread anim_single_solo_run( self, anime_exit );
	self disable_surprise();
	self disable_bulletwhizbyreaction();
	wait 10;
	self enable_surprise();
	self enable_bulletwhizbyreaction();
}

//turbine_room_elevator_allies( elevator_control )
//{
//	struct = getstruct( "turbine_elevator_burke_position", "targetname" );
//	level.burke ForceTeleport( struct.origin, struct.angles );
//	level.burke SetGoalPos( struct.origin );
//	//level.burke linkto( elevator_control );
//	
//	struct = getstruct( "turbine_elevator_joker_position", "targetname" );
//	level.joker ForceTeleport( struct.origin, struct.angles );
//	level.joker SetGoalPos( struct.origin );
//	//level.joker linkto( elevator_control );
//	
//	struct = getstruct( "turbine_elevator_carter_position", "targetname" );
//	level.carter ForceTeleport( struct.origin, struct.angles );
//	level.carter SetGoalPos( struct.origin );
//	//level.carter linkto( elevator_control );
//	
//	level waittill( "turbine_elevator_reached_top" );
//	
//	level.burke Unlink();
//	level.joker Unlink();
//	level.carter Unlink();
//}

turbine_room_combat()
{
	flag_wait( "player_in_turbine_room" );
	
	level.burke enable_careful();
	level.joker enable_careful();
	level.carter enable_careful();
	
	level.turbine_room_goal_volume = getent( "turbine_room_initial_goal", "script_noteworthy" );
	
	array_thread( GetEntArray( "turbine_room_goal_volume_trigger", "targetname" ), ::turbine_room_goal_volume_trigger_think );
	
	flag_wait( "turbine_room_stop_combat" );
	
//	level.burke disable_careful();
//	level.joker disable_careful();
//	level.carter disable_careful();
	
	foreach( enemy in getaiarray( "axis" ) )
	{
		enemy thread bloody_death( RandomFloatRange( 0, 3 ) );
	}
}

turbine_room_goal_volume_trigger_think()
{
	goal = self get_target_ent();
	
	level endon( "turbine_room_stop_combat" );
	
	while( 1 )
	{
		self waittill( "trigger" );
		if( goal != level.turbine_room_goal_volume )
		{
			level.turbine_room_goal_volume = goal;
			level notify( "turbine_room_update_goal" );
		}
		wait 0.5;
	}
}

turbine_room_enemy_think()
{
	self endon( "death" );
	
	//wait until goal volume is defined
	while( !IsDefined( level.turbine_room_goal_volume ) )
	{
		wait 1;
	}
	
	while( 1 )
	{
		level waittill( "turbine_room_update_goal" );
//		self ClearGoalVolume();
		self SetGoalVolumeAuto( level.turbine_room_goal_volume );
		wait 1;
	}
}

turbine_room_turbines()
{
	flag_wait( "elevator_ascend" );
	
	array_thread( GetEntArray( "turbine_fan", "targetname" ), ::turbine_fan_think );
}

turbine_fan_think()
{
//	level endon( "flag_shut_down_reactor_failed" );
	
	duration = 10;
	degrees = 360;
	if( IsDefined( self.script_parameters ) )
	{
		if( self.script_parameters == "ccw" )
		{
			degrees = -1 * degrees;
		}
	}
	
	while(1)
	{
		self rotateroll( degrees * duration, duration, 0, 0 );
		wait(duration);
	}
}

turbine_room_entrance_steam()
{

	
	flag_wait( "turbine_room_entrance_steam" );
	
	exploder( "turbine_looping_steam_fx" );


}

turbine_room_pre_explosion()
{

	flag_wait( "turbine_room_pre_explosion" );
	
	pauseExploder( "turbine_looping_steam_fx" );
	
	wait 2.2;
	exploder( "turbine_room_spark_steam" );
	snd_message ("turbine_pre_explo" );
	
	wait 0.4;
	exploder( "turbine_room_spark_steam_2" );
	exploder( "turbine_looping_steam_fx_2" );
	exploder( "turbine_looping_steam_fx" );


}

turbine_room_explosion()
{
	floor = getent( "turbine_floor_grate_destroyed", "targetname" );
	floor hide();
	
	turbine_explosion_volume = getent( "turbine_explosion_volume", "targetname" );
	BadPlace_Brush( "turbine_explosion_volume", 0, turbine_explosion_volume, "allies" );
	
	turbine_damaged = GetEntArray( "turbine_damaged", "targetname" );
	array_call( turbine_damaged, ::hide );
	
	turbine_fan_damaged = GetEntArray( "turbine_fan_damaged", "targetname" );
	array_call( turbine_fan_damaged, ::hide );
	
	flag_wait( "turbine_room_explosion" );
	
	snd_message ("turbine_explo_audio");
	wait (.2);
	
	damage_sources = getstructarray( "turbine_explosion_damage_source", "targetname" );
	foreach( source in damage_sources )
	{
	    RadiusDamage( source.origin, source.radius, 200, 100 );
	}
	
	pauseExploder( "turbine_looping_steam_fx" );
	pauseExploder( "turbine_looping_steam_fx_2" );
	
	thread turbine_room_explosion_flying_blades();
//	wait .5;
	exploder( "turbine_explosion_fx" );
	
	floor PlaySound( "detpack_explo_metal");
	earthquake( .5, .5, floor.origin, 3000 );
	
	floor show();
	
	BadPlace_Delete( "turbine_explosion_volume" );
	BadPlace_Brush( "turbine_explosion_volume", 0, turbine_explosion_volume, "axis", "allies" );
	
	turbine_intact = GetEntArray( "turbine_intact", "targetname" );
	array_call( turbine_intact, ::Delete );
	array_call( turbine_damaged, ::show );
	array_call( turbine_fan_damaged, ::show );
	
	array_thread( turbine_fan_damaged, ::turbine_fan_think );
	
	wait 1.5;
	exploder( "turbine_explosion_steam_fx" );
	exploder( "turbine_damage_sparks" );
	
//	floor PlaySound( "detpack_explo_metal");
//	earthquake( 1, 1, floor.origin, 1000 );
	
	flag_set( "vo_turbine_explosion" );
	
	snd_message( "start_pa_emergency_turbine" );
	
	if ( level.currentgen )
	{
		level waittill( "notify_out_of_control_room" );
		stop_exploder("turbine_explosion_fx");
	}
}

turbine_room_explosion_flying_blades()
{
	sources = getstructarray( "turbine_blade_flying_start", "targetname" );

	foreach( source in sources )
	{
		thread turbine_room_explosion_launch_blade( source );
	}
	
}

turbine_room_explosion_launch_blade( source )
{
	if( IsDefined( source.script_delay ) )
	{
		wait source.script_delay;
	}
	
	dest = getstruct( source.target, "targetname" );
	
	dist = Distance( source.origin, dest.origin );
	
	vel = 3000;
	
	dur = dist / vel;
	
	blade = spawn( "script_model", source.origin );
	blade SetModel( "vehicle_v22_osprey_damaged_static_bladepiece_left" );
	blade.angles = source.angles;
	
//	dur = 0.5;
	
	blade MoveTo( dest.origin, dur, 0, 0 );
	blade RotatePitch( 1080, dur, 0, 0 );
	wait dur;
	
	blade.angles = dest.angles;
	
	blade thread delete_on_notify( "turbine_room_cleanup" );
}

turbine_room_atmosphere()
{
	level endon( "flag_shut_down_reactor_failed" );
	level.player endon( "death" );
	
	sources = getstructarray( "turbine_center", "script_noteworthy" );
	
	intensity_min = 0.07;
	intensity_max = 0.12;
	intensity_range = intensity_max - intensity_min;
	
	quake_min = 0.08;
	quake_max = 0.12;
	quake_range = quake_max - quake_min;
	
	while(1)
	{
		flag_wait( "player_in_turbine_room" );
		//thread turbine_room_steam_player();
		ent = get_rumble_ent( "steady_rumble" );
		ent.intensity = 0.08;
		
		dur = 1;
		while( flag( "player_in_turbine_room" ) )
		{
//			closest = level.player get_closest_struct( sources );
			closest = getClosest( level.player.origin, sources );
			shake = get_turbine_shake_value( closest );
			ent.intensity = intensity_min + shake*intensity_range;
			Earthquake( quake_min + shake*quake_range, dur, level.player.origin, 1000 );
			wait RandomFloatRange( (dur / 4), (dur / 2) );
		}
		
		stopallrumbles();
	}
}

get_turbine_shake_value( source )
{
	min_dist = 300;
	max_dist = 600;
	dist_range = max_dist - min_dist;
	
	dist = Distance( level.player.origin, source.origin );
	
	if( dist < min_dist )
		return 1;
	
	if( dist > max_dist )
		return 0;
	
	return (1 - ((dist - min_dist) / dist_range));
}

turbine_room_steam_player()
{
	level endon( "flag_shut_down_reactor_failed" );
	
	while( flag( "player_in_turbine_room" ) )
	{
		PlayFX( getfx( "steam_player" ), level.player.origin + (0, 0, 0) );
		wait 0.3;
	}
}

/*
turbine_room_fx()
{
	turbine_room_fx_triggers = GetEntArray( "turbine_room_fx_trigger", "script_noteworthy" );
	
	array_thread( turbine_room_fx_triggers, ::turbine_room_fx_triggers_think );
}

turbine_room_fx_triggers_think()
{
	if( isdefined( self.script_flag ) )
		thread maps\_load::flag_set_trigger( self );
	
	self waittill( "trigger" );
	
	structs = getstructarray( self.target, "targetname" );
	ents = GetEntArray( self.target, "targetname" );
	
	foreach( struct in structs )
	{
		//cover structs that aren't rotated
		if( !IsDefined( struct.angles ) )
			struct.angles = (0, 0, 0);
		
		PlayFX( getfx( struct.script_noteworthy ), struct.origin, AnglesToForward( struct.angles + (0, -90, 0) ) , AnglesToUp( struct.angles ) + (0, 0, 0) );
		if( IsDefined( self.script_flag ) && self.script_flag == "turbine_explosion" )
		{
			PlayFX( getfx( "turbine_explosion" ), struct.origin );
		}
	}
	if( structs.size )
	{
		org = spawn( "script_origin", structs[0].origin );
		org PlaySound( "detpack_explo_metal");
		earthquake( 1, 1, org.origin, 1000 );
	}
	
	foreach( ent in ents )
	{
		if( ent.classname == "info_volume" )
		{
			BadPlace_Brush( "turbine_room_badplace", 0, ent, "allies", "axis" );
		}
	}
	
	if( IsDefined( self.script_flag ) && self.script_flag == "turbine_explosion" )
	{
		org = spawn( "script_origin", structs[0].origin );
		
		wait 1;
		org PlaySound( "detpack_explo_metal");
		earthquake( 1, 1, org.origin, 1000 );
		
		foreach( struct in structs )
		{
			//cover structs that aren't rotated
			if( !IsDefined( struct.angles ) )
				struct.angles = (0, 0, 0);
			
			PlayFX( getfx( "turbine_explosion" ), struct.origin );
		}
		
		wait 0.1;
		org PlaySound( "detpack_explo_metal");
		earthquake( 1, 1, org.origin, 1000 );
	}
}
*/
control_room()
{
	thread control_room_run();
	thread control_room_explosion();
//	thread control_room_scene();
}

control_room_run()
{	
	flag_wait( "control_room_run_prep" );
	
	anim_struct = getstruct( "control_room_burke_position", "targetname" );
	explosion_anime = "fusion_door_explosion";
	postup_doors = getent( "fusion_door_open_postup_doors", "targetname" ); //spawn_anim_model( "fusion_door_open_postup_doors", (0, 0, 0) );
	postup_doors.animname = "fusion_door_open_postup_doors";
	postup_doors SetAnimTree();
	
	anim_struct anim_first_frame_solo( postup_doors, explosion_anime );
	
	fusion_door_open_postup_door_right = getent( "fusion_door_open_postup_door_left", "targetname" );
	fusion_door_open_postup_door_right linkto( postup_doors, "door_R" );
	fusion_door_open_postup_door_left = getent( "fusion_door_open_postup_door_right", "targetname" );
	fusion_door_open_postup_door_left linkto( postup_doors, "door_L" );
	
	flag_wait( "control_room_run_approach" );
	
	level.burke disable_careful();
	level.joker disable_careful();
	level.carter disable_careful();
	
	waitframe();
	
	guys = [];
	guys[guys.size] = level.burke;
	guys[guys.size] = level.carter;
	
	anime_postup = "fusion_door_explosion_postup";
	anime_postup_loop = "fusion_door_explosion_postup_loop";
	
	org = spawn( "script_origin", anim_struct.origin );
	org.angles = anim_struct.angles;
	ender = "control_room_run";
	level.burke thread start_cqb_when_near( GetStartOrigin( org.origin, org.angles, level.scr_anim[ "burke" ][ anime_postup ] ) );
	level.carter thread start_cqb_when_near( GetStartOrigin( org.origin, org.angles, level.scr_anim[ "carter" ][ anime_postup ] ) );
	
	guys = [];
	guys[guys.size] = level.burke;
	guys[guys.size] = level.carter;
	array_thread( guys, ::control_room_run_approach, org, anime_postup, anime_postup_loop, ender );
	
	level waittill( "control_room_run_guy_ready" );
	level waittill( "control_room_run_guy_ready" );
	
	flag_wait( "control_room_run" );
	
	thread control_room_run_player();
	thread control_room_screens();
	
	level.burke disable_cqbwalk();
	level.carter disable_cqbwalk();
	
	org notify( "control_room_run" );
	thread control_room_run_joker();
	
	delayThread( 2.5, ::flag_set, "update_obj_pos_control_room_door" );
	guys[guys.size] = postup_doors;
	
	array_call( GetEntArray( "control_room_doors", "targetname" ), ::delete );
	
	fusion_door_explosion_door_a = spawn_anim_model( "fusion_door_explosion_door_a", (0, 0, 0) );
	fusion_door_explosion_door_b = spawn_anim_model( "fusion_door_explosion_door_b", (0, 0, 0) );
	
	doors = [];
	doors[doors.size] = fusion_door_explosion_door_a;
	doors[doors.size] = fusion_door_explosion_door_b;
	
	snd_message( "start_turbine_door_breach" );
	snd_message( "start_turbine_door_impt", fusion_door_open_postup_door_right, fusion_door_open_postup_door_left );
	
//	anim_struct thread anim_first_frame( doors, anime );
	
	thread control_room_scene_player( anim_struct );
	
	delayThread( 5, ::flag_set, "vo_control_hall_door_stack" );
	delayThread( 6, ::flag_set, "vo_control_hall_door_kicked" );
	
	
	
	guys[guys.size] = fusion_door_explosion_door_a;
	guys[guys.size] = fusion_door_explosion_door_b;
	
	anim_duration = GetAnimLength( level.burke getanim( explosion_anime ) );
	
	anim_struct thread anim_single( guys, explosion_anime );
	
	readyTime = 24;
	delayThread( readyTime, ::control_room_scene, anim_duration - readyTime );
	
	wait anim_duration;
	
	org delete();
	
}

control_room_run_approach( org, approach_anime, approach_idle, ender )
{
	org anim_reach_solo( self, approach_anime );
	org anim_single_solo( self, approach_anime );
	org thread anim_loop_solo( self, approach_idle, ender );
	level notify( "control_room_run_guy_ready" );
}

control_room_run_player()
{
	org = getstruct( "control_room_door_explosion_dmg_org", "targetname" );
	radius = org.radius;
	
//	thread draw_circle_until_notify( org.origin, org.radius, 1, 1, 1, level, "forever" );
	
	flag_wait( "control_room_explosion" );
	
	control_room_door_clip = getent( "control_room_door_clip", "targetname" );
	if( IsDefined( control_room_door_clip ) )
		control_room_door_clip delete();
	
	dist = Distance2D( org.origin, level.player.origin );
	if( dist < radius )
	{
		dmg = dist / radius * level.player.health;
		if( dmg < level.player.health / 2 )
			dmg = level.player.health / 2;
		level.player DoDamage( dmg, org.origin );
		
		dest_points = getstructarray( "control_room_door_explosion_dmg_dest", "targetname" );
		
		vect_lengths = [];
		foreach( point in dest_points )
		{
			vect_lengths[ vect_lengths.size ] = length( VectorFromLineToPoint( org.origin, point.origin, level.player.origin ) );
		}
		
		shortest_index = 0;
		shortest_dist = 1000;
		for( i = 0; i < vect_lengths.size; i++ )
		{
			if( vect_lengths[i] < shortest_dist )
			{
				shortest_index = i;
				shortest_dist = vect_lengths[i];
			}
		}
		
		dest = dest_points[ shortest_index ];
		
		control_point = spawn_tag_origin();
		control_point.origin = level.player.origin;
		control_point.angles = level.player.angles;
		
		movetime = 0.5;
		level.player PlayerLinkToBlend( control_point, "tag_origin", moveTime );
		
		control_point MoveTo( dest.origin, moveTime, 0.05, 0.05 );
		
		view_org = getstruct( "control_room_door_explosion_view_org", "targetname" );
		
		control_point RotateTo( (0, VectorToAngles( view_org.origin - dest.origin )[1], 0), moveTime, 0.05, 0.05 );
		
		level.player PlayRumbleOnEntity( "damage_heavy" );
		
		wait moveTime;
		level.player unlink();
		control_point delete();
	}
	else
	{
		level.player PlayRumbleOnEntity( "damage_light" );
	}
}

control_room_run_joker()
{
	wait 6;
	getent( "fusion_door_open_postup_door_left", "targetname" ) ConnectPaths();
	
	getent( "fusion_door_open_postup_door_right", "targetname" ) ConnectPaths();
	
	wait 1;
	control_room_joker_position = getstruct( "control_room_joker_position", "targetname" );
	
	rad = level.joker.goalradius;
	level.joker.goalradius = 64;
	level.joker enable_cqbwalk();
	level.joker SetGoalPos( control_room_joker_position.origin );
	
	level.joker waittill( "goal" );
	
	level.joker AllowedStances( "crouch" );
	
	level waittill( "control_room_scene_complete" );
	level.joker AllowedStances( "prone", "crouch", "stand" );
	
	level.joker disable_cqbwalk();
	level.joker.goalradius = rad;
}

control_room_explosion()
{
	control_room_hall_intact = GetEntArray( "control_room_hall_intact", "targetname" );
	control_room_hall_destroyed = GetEntArray( "control_room_hall_destroyed", "targetname" );
	
	foreach( part in control_room_hall_destroyed )
	{
		part hide();
	}
	
	level waittill( "doors_explode" );
	
	foreach( part in control_room_hall_destroyed )
	{
		part show();
	}
	
	foreach( part in control_room_hall_intact )
	{
		part delete();
	}
	
	flag_set( "control_room_explosion" );
	
	flag_set( "update_obj_pos_control_room_explosion" );
	
	flag_set( "vo_control_room_explosion" );
	
	MUS_play( "control_room_tension", 0 );
	
	//blow up door
//	iprintln( "boom" );
	
level thread maps\fusion_fx::vfx_control_room_explo();
snd_message( "start_control_room_explo" );
	
	
//	explosion_org = getstruct( "control_room_door_explosion_fx_org", "targetname" );
//	playfx( getfx( "door_explosion" ), explosion_org.origin );
//	Earthquake( 1, 0.5, explosion_org.origin, 500 );
	
	
}

control_room_scene_player( anim_struct )
{
	flag_wait( "control_room_console_enable" );
	
	control_room_console_use_trigger = getent( "control_room_console_use_trigger", "targetname" );
	control_room_console_use_trigger setHintString( &"FUSION_USE_CONSOLE" );
	
	flag_wait( "control_room_console_used" );
	
	control_room_console_use_trigger delete();
	
	flag_set( "update_obj_pos_control_room_using_console" );
	
	flag_set( "control_room_scene" );
	
//	struct = getstruct( "control_room_console_player_location", "targetname" );
	
	player_rig = spawn_anim_model( "player_rig", level.player.origin );
	player_rig hide();
	level.player DisableWeapons();
	
	blendTime = 1;
	
	level.player PlayerLinkToBlend( player_rig, "tag_player", blendTime );
	
	player_rig delayCall( blendTime, ::show);
	
	
	
	//wait 2.25;
	
//	dest_origin = org.origin;
//	dest_angles = org.angles;
//	
//	org.origin = level.player.origin;
//	org.angles = level.player.angles;
	
	
	
//	level.player PlayerLinkToBlend( org, undefined, blendTime );
	level.player delayCall( blendTime, ::PlayerLinkToDelta, player_rig, "tag_player", 0, 30, 30, 30, 30 );
	
	level.player AllowCrouch( false );
	level.player AllowProne( false );
	level.player DisableWeapons();
	
//	wait blendTime;
//	
//	level.player PlayerLinkToDelta( org, undefined, 0, 70, 70, 70, 70 );
	
//	level.player FreezeControls( true );
	
	level.player blend_MoveSpeedscale_Percent( 0 );
	
//	level waittill( "control_room_scene_complete" );
	anim_struct thread anim_first_frame_solo( player_rig, "control_room_scene" );
	flag_wait( "control_room_scene_ready" );
	level.player PlayerLinkToDelta( player_rig, "tag_player", 0, 60, 60, 70, 65 );
	anim_struct thread anim_single_solo( player_rig, "control_room_scene" );
	
	anim_duration = GetAnimLength( player_rig getanim( "control_room_scene" ) );
	
	wait anim_duration - 1;
//	level.player FreezeControls( false );
	
	
	
	level.player AllowCrouch( true );
	level.player AllowProne( true );
	level.player EnableWeapons();
	
	wait 1;
	player_rig delete();
	level.player Unlink();
	level.player blend_MoveSpeedscale_Percent( 100, 2 );
//	org delete();
}

control_room_scene( delay )
{
	flag_set( "control_room_scene_ready" );
	thread control_room_scene_actors( delay );
	
	level waittill( "control_room_event_1" );
	thread maps\fusion_aud::do_inside_bombshake();
	
	level waittill( "control_room_event_2" );
	thread maps\fusion_aud::do_inside_bombshake();
	
	level waittill( "control_room_event_3" );
	thread maps\fusion_aud::do_inside_bombshake();
}

control_room_scene_actors( delay )
{
	//npcs idle
	anim_struct = getstruct( "control_room_burke_position", "targetname" );
	anim_node_burke = spawn( "script_origin", anim_struct.origin );
	anim_node_burke.angles = anim_struct.angles;
	anim_node_joker = spawn( "script_origin", anim_struct.origin );
	anim_node_joker.angles = anim_struct.angles;
	anim_node_carter= spawn( "script_origin", anim_struct.origin );
	anim_node_carter.angles = anim_struct.angles;
	
	anime = "control_room_idle";
	
	guys = [];
	guys[guys.size] = level.burke;
//	guys[guys.size] = level.joker;
	guys[guys.size] = level.carter;
	
	if( isdefined( delay ) )
		flag_wait_or_timeout( "control_room_scene", delay );
	anim_node_burke thread anim_loop_solo( level.burke, anime, "control_room_scene" );
	anim_node_carter thread anim_loop_solo( level.carter, anime, "control_room_scene" );
	
	anime = "control_room_scene";
	
//	anim_struct thread anim_reach_solo( level.joker, anime );
	
	guys[guys.size] = level.joker;
	
	flag_wait( "control_room_scene" );
	
	
	level notify( "turbine_room_cleanup" );
	
//	level.joker notify( "goal" );
	
	
	anim_node_burke notify( "control_room_scene" );
	anim_node_carter notify( "control_room_scene" );
	anim_node_carter delete();
//	anim_struct anim_reach( guys, anime );
//	burke_struct thread anim_loop_solo( level.burke, "control_room_scene", "shutdown_reactor_failed" );
	
	level.burke enable_ai_color();
	level.joker enable_ai_color();
	level.carter enable_ai_color();
	
	level.joker set_force_color( "o" );
	level.carter set_force_color( "o" );
	
	delayThread( 1, ::activate_trigger_with_targetname, "control_room_scene_complete_color_trigger" );
	
	flag_set( "vo_control_room_scene" );
	
	anim_node_burke anim_single_run( guys, anime );
	anim_node_burke delete();
	
	//wait 10;
	
//	flag_wait( "shutdown_reactor_failed" );
//	anim_struct notify( "control_room_scene" );
	
//	anim_struct waittill( anime );
	
//	level notify( "control_room_scene_complete" );
	
//	struct = getstruct( "hangar_entrance", "targetname" );
	
	flag_set( "flag_shut_down_reactor_failed" );
	
	flag_set( "evacuation_started" );
	
	flag_set( "update_obj_pos_control_room_exit_1" );
	control_room_scene_exit();
}

control_room_screens()
{
	level notify("stop_evacuation_kiosk_movie");
	SetSavedDvar( "cg_cinematicFullScreen", "0" );
//	prep_cinematic( "fusion_control_room_loop" );
//	wait 2.5;
//	thread play_cinematic( "fusion_control_room_loop" );
	
//	SetSavedDvar("cg_cinematicFullScreen", "0");
	
	CinematicInGameLoop("fusion_control_room_loop");
	
	flag_wait( "control_room_scene" );
	
	wait 12;
	
//	prep_cinematic( "fusion_control_room_loop_red" );
//	wait 2.5;
//	console = getent( "fus_control_monitor_02_static", "targetname" );
//	console SetModel( "fus_control_monitor_02_cinematic" );
	
//	thread play_cinematic( "fusion_control_room_loop_red" );
	CinematicInGameLoop("fusion_control_room_loop_red");
	
	flag_wait( "evacuation_started" );
	thread evacuation_kiosk_movie();
}

control_room_scene_exit()
{
	wait 0.45;
	control_room_exit_door = getent( "control_room_exit_door", "targetname" );
	getent( control_room_exit_door.target, "targetname" ) linkto( control_room_exit_door );
//	control_room_door_emergency_exit = GetEnt( "control_room_door_emergency_exit", "targetname" );
	
	door_open_time = 0.5;
	control_room_exit_door RotateTo( control_room_exit_door.angles - (0, 120, 0), door_open_time, 0, 0 );
	wait door_open_time + 0.05;
	
	control_room_exit_door RotateTo( control_room_exit_door.angles - (0, -10, 0), 1, 0, 1 );
	
	flag_wait( "raise_control_room_emergency_exit_door" );
	
//	control_room_door_emergency_exit MoveTo( getstruct(control_room_door_emergency_exit.target, "targetname").origin, 3, 0, 0.5);
	
	flag_set( "update_obj_pos_control_room_exit_2" );
}

/////////////////////////// CONTROL ROOM ///////////////////////
burke_moment()
{
	if( !IsDefined( level.burke ) )
	{
		spawner = getent( "burke", "targetname" );
		level.burke = spawner spawn_ai( true, true );
		level.burke.animname = "burke";
//		level.burke thread magic_bullet_shield();
	}
	
	if( !IsDefined( level.carter ) )
	{
		spawner = getent( "carter", "targetname" );
		level.carter = spawner spawn_ai( true, true );
		level.carter.animname = "carter";
//		level.carter thread magic_bullet_shield();
	}
	
//	if( !IsDefined( level.thompson ) )
//	{
//		spawner = getent( "thompson", "targetname" );
//		level.thompson = spawner spawn_ai( true );
//		level.thompson.animname = "thompson";
////		level.thompson thread magic_bullet_shield();
//	}
	
	if( !IsDefined( level.joker ) )
	{
		spawner = getent( "joker", "targetname" );
		level.joker = spawner spawn_ai( true, true );
		level.joker.animname = "joker";
//		level.joker thread magic_bullet_shield();
	}
	
	thread scene_control_room();

}

scene_control_room()
{
//	thread scene_control_room_fade_up();
	
//	level.joker set_force_color("g");
	
//	org = getent ( "org_pre_hangar", "targetname" );
//	
//	guys = [];
//	guys [ guys.size ] = level.joker;
//	guys [ guys.size ] = level.carter;
//	
//	guys2 = [];
//	guys2 [ guys2.size ] = level.burke;
//	guys2 [ guys2.size ] = level.thompson;
//	
//	array_thread( guys, ::scene_control_room_ai );
//	array_thread( guys2, ::scene_control_room_ai );
//	
//	org thread anim_single_solo_run( guys2[0], "reactor_talk" );
//	org thread anim_single_solo_run( guys2[1], "reactor_talk" );
//	
//	org anim_first_frame ( guys, "fus_control_room_in" );
//	org anim_single ( guys, "fus_control_room_in" );
//	org thread anim_loop ( guys, "fus_control_room_loop", "stop_loop" );
	
	flag_wait ( "flag_obj_02_pos_update_02" );
	
//	org thread anim_single_solo_run ( level.carter, "fus_control_room_out" );
//	org anim_single_solo ( level.joker, "fus_control_room_out" );
	
	wait 5;
//	level.joker set_force_color("o");
	
//	level notify( "control_room_scene_complete" );
}

scene_control_room_ai()
{
	self disable_surprise();
	self disable_bulletwhizbyreaction();
	self disable_pain();
	
	level waittill( "control_room_scene_complete" );
	
	self enable_surprise();
	self enable_bulletwhizbyreaction();
	self enable_pain();
}

scene_control_room_fade_up()
{
	if( !IsDefined( level.overlay ) )
	{
		level.overlay = create_client_overlay( "black", 1, level.player );
		level.overlay.sort = -1;
		level.overlay.foreground = true;
		level.overlay.color = (0, 0, 0);
	}
	
	wait 1;
	
	delay = 1;
	level.overlay fadeOverTime( delay );
	level.overlay.alpha = 0;
	
	wait delay;
	level.overlay destroy();
}
evacuation_setup()
{
	flag_wait( "evacuation_started" );
	thread evacuation_corpses();
	thread evacuation_balcony_death();
}

dialog_meltdown()
{
	thread dialog_collapse();
	
	level endon( "collapse_start" );
	
//	maps\fusion_vo::radio_dialogue_queue_global ( "fusion_hqr_level7event" );
	
	// PCap and other scene lines now being handled in fusion_aud.gsc:  
//	level.burke maps\fusion_vo::dialogue_queue_global ( "fusion_brk_gocritical" );
//	
//	wait 1;
//	
//	level.joker maps\fusion_vo::dialogue_queue_global ( "fusion_jkr_bailinout" );
//	level.burke maps\fusion_vo::dialogue_queue_global ( "fusion_brk_keepmoving" );
	
	flag_wait ( "hangar_enemies" );
	
	//level.burke maps\fusion_vo::dialogue_queue_global ( "fusion_brk_contactloadingbay" ); // dv: Removing this as it's problematic (sometimes jumps in between a conversaion). 
	level.joker maps\fusion_vo::dialogue_queue_global ( "fusion_jkr_lotofsmoke" );
	level.burke maps\fusion_vo::dialogue_queue_global ( "fusion_brk_switchmmgs" );
	
	flag_wait ( "hangar_combat_retreat" );
	
	level.carter maps\fusion_vo::dialogue_queue_global ( "fusion_ctr_geigerreading" );
	level.joker maps\fusion_vo::dialogue_queue_global ( "fusion_jkr_justkeepshooting" );	
	
	flag_wait ( "hangar_combat_retreat_02" );
	
	level.burke maps\fusion_vo::dialogue_queue_global ( "fusion_brk_kvanorthtowers" );
	maps\fusion_vo::radio_dialogue_queue_global ( "fusion_hqr_onthetracker" );
	
	flag_wait( "hangar_exit_retreat" );
	level.joker maps\fusion_vo::dialogue_queue_global ( "fusion_jkr_usingdrones" );
	level.burke maps\fusion_vo::dialogue_queue_global ( "fusion_brk_useyouremps" );
	thread dialog_monitor_drones_down();
	
	level.burke maps\fusion_vo::dialogue_queue_global ( "fusion_brk_needimmediateevac" );
	maps\fusion_vo::radio_dialogue_queue_global ( "fusion_plt1_inboundinthirty" );
	//wait 1;
	maps\fusion_vo::radio_dialogue_queue_global ( "fusion_hqr_readingscritical" );
	snd_music_message("mus_fusion_pressure_readings_critical");
	level.joker maps\fusion_vo::dialogue_queue_global ( "fusion_jkr_heardkeepmoving" );
	
	flag_wait ( "reaction_explo01a" );
	
	wait 0.75;
	level.joker maps\fusion_vo::dialogue_queue_global ( "fusion_jkr_goddamn" );
	level.carter maps\fusion_vo::dialogue_queue_global ( "fusion_ctr_whatthehell" );
	level.burke maps\fusion_vo::dialogue_queue_global ( "fusion_brk_pressureexplosions" );
	
	flag_wait( "ct_combat_retreat" );
	wait 2;
	level.burke maps\fusion_vo::dialogue_queue_global ( "fusion_brk_moredronesincoming" );
	
	//wait 1;
	flag_wait ( "reaction_explo01" );
	
	wait 2;
	maps\fusion_vo::radio_dialogue_queue_global ( "fusion_plt1_gunrun" );
	level.burke maps\fusion_vo::dialogue_queue_global ( "fusion_brk_welcomesight" );
	
	flag_wait ( "reaction_explo02" );

	wait 4;
	
	flag_set( "extraction_chopper_move_from_explosion" );
	maps\fusion_vo::radio_dialogue_queue_global ( "fusion_plt1_southeasttower" );
	level.burke maps\fusion_vo::dialogue_queue_global ( "fusion_brk_copythattwothree" );
	level.joker maps\fusion_vo::dialogue_queue_global ( "fusion_jkr_comeon" );
	level.carter maps\fusion_vo::dialogue_queue_global ( "fusion_ctr_gogo" );
	
	flag_wait( "ct_final_retreat" );
	level.joker maps\fusion_vo::dialogue_queue_global ( "fusion_jkr_exfil" );
}

dialog_monitor_drones_down()
{
	flag_wait( "evacuation_first_drones_down" );
	level.joker maps\fusion_vo::dialogue_queue_global( "fusion_jkr_dronesdown" );
}

dialog_collapse()
{
	//////////////////////////////////////////////////
	/// Moving the triggering of all collapse dialog to tower_collapse_dialog() in fusion_aud.gsc.
	/// Purpose of move is to coordinate the timing of each dialog alias with the collapse SFX.  
	/// Also, applying DSP filters on dialog that needs to be timed with the collapse SFX.
	/// -Swenson 11/05/12
	/////////////////////////////////////////////////

//	flag_wait ( "collapse_start" );
//	level.joker maps\fusion_vo::dialogue_queue_global ( "fusion_jkr_ohshit" );
//	
//	flag_wait ( "tower_knockback" );
//	
//	wait 2;
//	
//	maps\fusion_vo::radio_dialogue_queue_global ( "fusion_plt1_doyoucopy" );
//	maps\fusion_vo::radio_dialogue_queue_global ( "fusion_jkr_wherescarter" );
//	
//	maps\fusion_vo::radio_dialogue_queue_global ( "fusion_hqr_massiveexplosionnorth" );
//	level.burke maps\fusion_vo::dialogue_queue_global ( "fusion_brk_keepmovingkeepmoving" );
//	maps\fusion_vo::radio_dialogue_queue_global ( "fusion_jkr_itscomingdown" );
//	maps\fusion_vo::radio_dialogue_queue_global ( "fusion_plt1_bravotakecover" );
	
	flag_wait ( "tower_debris" );
	
	thread tower_debris_radio_chatter();
	//thread outro_newscast();
	
	//wait 7;
	
	//Per Bret, line removed from fusion. -jgavazza
	//level.burke maps\fusion_vo::dialogue_queue_global ( "fusion_brk_mandown" );	
}

tower_debris_radio_chatter()
{
	level.player delayCall( 4, ::playsound, "fusion_aldr_casualtiesandwounded" );
	
	level.player delayCall( 10, ::playsound, "fusion_plt1_wraithtwofourdown" );

	level.player delayCall( 14, ::playsound, "fusion_hqr_getthosemenout" );
	
	level.player delayCall( 20, ::playsound, "fusion_jkr_cartersdead" );
	
	level.player delayCall( 25, ::playsound, "fusion_aldr_goddamnairsupport" );
	
	level.player delayCall( 28, ::playsound, "fusion_aldr_lostcontactbravo" );
	
	level.player delayCall( 31, ::playsound, "fusion_plt1_needcasevaccourtyard" );
}

outro_newscast()
{
	wait 32;
	level.player playsound( "fusion_nws1_nationalemergency", "outro_newscast_line_complete" );
	level.player waittill( "outro_newscast_line_complete" );
	
	level.player playsound( "fusion_nws2_thousandsdead", "outro_newscast_line_complete" );
	level.player waittill( "outro_newscast_line_complete" );
	
	level.player playsound( "fusion_nws3_worstterrorist", "outro_newscast_line_complete" );
	level.player waittill( "outro_newscast_line_complete" );
	
	level.player playsound( "fusion_nws1_radiationspreading", "outro_newscast_line_complete" );
	level.player waittill( "outro_newscast_line_complete" );
	
	level.player playsound( "fusion_nws3_damageintrillions", "outro_newscast_line_complete" );
	level.player waittill( "outro_newscast_line_complete" );
	
	level.player playsound( "fusion_nws2_britainandgermany", "outro_newscast_line_complete" );
	level.player waittill( "outro_newscast_line_complete" );
	
	level.player playsound( "fusion_nws1_easternseaboard", "outro_newscast_line_complete" );
	level.player waittill( "outro_newscast_line_complete" );
	
	level.player playsound( "fusion_nws2_deathtoll", "outro_newscast_line_complete" );
	level.player waittill( "outro_newscast_line_complete" );
}

combat_hangar()
{
	hangar_spawners = getentarray ( "hangar_enemies_01", "targetname" );
	ct_spawners = getentarray ( "ct_enemies_01", "targetname" );
	hangar_runaway_spawners = getentarray ( "hangar_runaway", "targetname" );
	hangar_runaway_02_spawners = getentarray ( "hangar_runaway_02", "targetname" );
	
	array_thread( hangar_spawners, ::add_spawn_function, ::disable_long_death );
	array_thread( ct_spawners, ::add_spawn_function, ::disable_long_death );
	array_thread( hangar_runaway_spawners, ::add_spawn_function, ::disable_long_death );
	array_thread( hangar_runaway_02_spawners, ::add_spawn_function, ::disable_long_death );
	
	level.hangar_enemies = [];
	
	flag_wait ( "hangar_combat_start" );
	
	hangar_runaway = array_spawn ( hangar_runaway_spawners, true, true );
	level.ct_enemies = array_spawn ( ct_spawners, true, true );
	
	array_thread ( hangar_runaway, ::runaway_guy_delete );
	
	flag_wait ( "hangar_enemies" );
	
	//fixes some AI issues in this area
	level.carter.dontmelee = true;
	level.joker.dontmelee = true;
	
	thread combat_hangar_hints();
	
	maps\_spawner::flood_spawner_scripted ( hangar_spawners );
	//hangar_enemies = array_spawn ( hangar_spawners, true, true );
	
	flag_wait ( "hangar_combat_retreat" );
	
	level.carter.dontmelee = undefined;
	level.joker.dontmelee = undefined;
	
	flag_wait_or_timeout ( "hangar_combat_retreat_02", 20 );
	
	flag_set ( "hangar_retreat_done" );
	
	//array_setgoalvolume ( level.hangar_enemies, "vol_final_runaway" );
	array_thread( level.hangar_enemies, ::enemy_run_away, "vol_final_runaway", true );
	
	flag_wait ( "hangar_combat_retreat_02" );
	
	//flag_wait( "hangar_exit_retreat" );
	
	hangar_runaway_02 = array_spawn ( hangar_runaway_02_spawners, true, true );
	
	array_thread( level.ct_enemies, ::flagWaitThread, "reaction_explo01a", ::enemy_run_away, "vol_ct_02", false );
	
	flag_wait ( "ct_combat_retreat" );
	
	flag_wait ( "reaction_explo01" );
	
	autosave_by_name();
	
	drone_spawners = getentarray ( "ct_runaway_drones", "targetname" );
	array_thread ( drone_spawners, ::runaway_drone_think );
	//array_setgoalvolume ( level.ct_enemies, "vol_ct_02" );
	
	final_collapse_enemies = GetEntArray( "final_collapse_enemies", "targetname" );
	
	flood_spawn( final_collapse_enemies );
	
	flag_wait( "ct_final_retreat" );
	
	array_thread( final_collapse_enemies, maps\_spawner::flood_spawner_stop );
}

combat_hangar_hints()
{
	wait 5;
	display_hint( "hint_threat_grenade" );
	
	level.player waittill_any_timeout( 10, "grenade_fire" );
	
	thread listen_for_directed_energy_weapon_equiped();
	
	wait 3;
	display_hint( "hint_directed_energy" );
}

listen_for_directed_energy_weapon_equiped()
{
	level endon( "directed_energy_weapon_used" );
	
	while( 1 )
	{
		if( level.player GetCurrentWeapon() == "alt_iw5_m160_sp_deam160_variablereddot" )
			flag_set( "directed_energy_weapon_used" );
		wait 0.1;
	}
}

extraction_chopper()
{
	flag_wait ( "reaction_explo01" );
	
	//wait 5;
	
	level.extraction_chopper = spawn_vehicle_from_targetname_and_drive ( "ct_extraction_chopper" );
	level.extraction_chopper snd_message( "extraction_chopper_spawn" );
	level.extraction_chopper thread warbird_shooting_think();
	level.extraction_chopper SetMaxPitchRoll ( 20, 60 );
	level.extraction_chopper maps\_vehicle::vehicle_lights_on( "running" );
	level.extraction_chopper Vehicle_TurnEngineOff(); //Turning off default engine audio.
	
	wait 2;
	
	level.extraction_chopper notify( "warbird_fire" );
	
	wait 8;
	
	flag_set( "objective_on_extraction_chopper" );
	
	level.extraction_chopper SetGoalYaw( 330 );
	level.extraction_chopper SetHoverParams( 50, 50, 25 );
	
	flag_wait( "extraction_chopper_move_from_explosion" );
	level.extraction_chopper notify( "warbird_stop_firing" );
	level.extraction_chopper snd_message( "extraction_chopper_move" );	
	
	level.extraction_chopper ClearGoalYaw();
	level.extraction_chopper vehicle_paths( getstruct( "extraction_chopper_move_from_explosion", "targetname" ) );
}

extraction_chopper_collapse()
{
	flag_wait( "tower_debris" );
	wait 5;
	struct = getstruct( "extraction_chopper_final_path", "targetname" );
	if( !IsDefined( level.extraction_chopper ) )
	{
		level.extraction_chopper = spawn_vehicle_from_targetname( "ct_extraction_chopper" );
		level.extraction_chopper Vehicle_TurnEngineOff(); //Turning off default engine audio.
	}
	level.extraction_chopper Vehicle_SetSpeedImmediate( 0 );
	level.extraction_chopper Vehicle_Teleport( struct.origin, struct.angles );
	//level.extraction_chopper Vehicle_SetSpeed( 10, 1, 1 );
	level.extraction_chopper vehicle_paths( struct );
}

enemy_run_away( vol_name, delete_on_arrival )
{
	//make sure AI exists
	if( !IsDefined( self ) )
		return;
	
	self notify( "enemy_run_away" );
	self endon( "enemy_run_away" );
	self endon( "death" );
	
	self.ignoreall = true;
	
	volume = getent( vol_name, "targetname" );
	self cleargoalvolume();
	self setgoalvolumeauto ( volume );
	
	if( IsDefined( delete_on_arrival ) && delete_on_arrival )
		self thread enemy_delete_at_goal();
	
	min_dist_sq = 100 * 100;
	
	while( 1 )
	{
		self waittill_any( "damage", "bad_path" );
		self.ignoreall = false;
		
		wait RandomFloatRange( 3, 5);
		self.ignoreall = true;
	}
	
	/*
	while( 1 )
	{
		if( DistanceSquared( level.player.origin, self.origin ) < min_dist_sq )
		{
			self.ignoreall = false;
			wait 3;
		}
		else
		{
			self.ignoreall = true;
			wait 1;
		}
	}*/
}

enemy_delete_at_goal()
{
	self notify( "enemy_delete_at_goal" );
	self endon( "enemy_delete_at_goal" );
	self endon( "death" );
	self waittill( "goal" );
	
	if ( isdefined ( self ) && isalive ( self ) )
		self delete();
}

hangar_enemy_think()
{
	level.hangar_enemies [ level.hangar_enemies.size ] = self;
	
	self ClearGoalVolume();
	
	if ( !flag ( "hangar_retreat_done" ) )
		self setgoalvolumeauto ( getent ( "vol_enemy_hangar", "targetname" ) );
	
	else
		self setgoalvolumeauto ( getent ( "vol_ct_01", "targetname" ) );
}


runaway_guy_delete()
{
	self endon ( "death" );
	
	self waittill ( "goal" );
	
	if ( isdefined ( self ) && isalive ( self ) )
		self delete();
	
}

runaway_drone_think()
{
	//level endon ( "reaction_explo02" );
	
//	while ( true )
//	{
		//wait randomfloatrange ( 0.0, 2.0 );
		
		drone_guy = self spawn_ai( true );
		
		drone_guy thread runaway_guy_delete();
		
		drone_guy endon( "death" );
		
		flag_wait( "collapse_start" );
		
		drone_guy kill();
		
//	}
	
}

add_drone_to_squad()
{
	if( isDefined( self.script_parameters ) && self.script_parameters == "personal_drone" )
	{
		drone_spawner = getent( "squad_drone_spawner", "targetname" );
		self maps\_weapon_pdrone::pdrone_launch( drone_spawner );
		
		if( IsDefined( self.pdrone ) )
		{
			self.pdrone setthreatbiasgroup( "drones" );
		}
	}
}

//removing ambient explosion call.  all ambient explosion logic in fusion_fx.gsc
/*
ambient_explosions()
{
	level.player endon( "death" );
	level endon( "stop_ambient_explosions" );
	
	flag_wait( "start_ambient_explosions" );
	
	locs = getstructarray( "mortar_locs", "targetname" );
	
	while( true )
	{
		counter = RandomInt( locs.size );
		PlayFX( getfx( "mortar_explosion" ), locs[ counter ].origin );
		wait( RandomFloatRange( 5.0, 10.0 ) );
	}

}
*/


reaction_explosions()
{
	if (level.currentgen)
		flag_wait ( "hangar_enemies" );
	
	pressure_explosion_1_before = GetEntArray( "pressure_explosion_1_before", "targetname" );
	pressure_explosion_1_after = GetEntArray( "pressure_explosion_1_after", "targetname" );
	pressure_explosion_2_before = GetEntArray( "pressure_explosion_2_before", "targetname" );
	pressure_explosion_2_after = GetEntArray( "pressure_explosion_2_after", "targetname" );
	array_call( pressure_explosion_1_after, ::hide );
	array_call( pressure_explosion_1_after, ::NotSolid );
	array_call( pressure_explosion_2_after, ::hide );
	array_call( pressure_explosion_2_after, ::NotSolid );
	
	explosion_cart = getent ( "explosion_cart", "targetname" );
	explosion_cart.animname = "cart";
	explosion_cart SetAnimTree();
	fusion_utility_cart_collision = getent( "fusion_utility_cart_collision", "targetname" );
	fusion_utility_cart_collision LinkTo( explosion_cart, "TAG_ORIGIN" );
	
//	cart_dest = getent ( "dest_explosion_vehicle01", "targetname" );
	org = getent( "org_reaction_pickup_event", "targetname" );
	anime = "fusion_utility_cart_explode_cart";
	
	thread reaction_pickup_event();
	
	if (level.nextgen)
	flag_wait ( "hangar_enemies" );
	
	/********************** Explosion Sequence for loading dock area. THIS HAS BEEN MOVED TO fusion_fx.gsc
	//1st pressure explosion vfx on the left side pipe in the hanger
	exploder ( 5101 );
	level.player playsound ( "big_explosion_02_temp" );
	
	wait 1;
	
	//2nd pressure explosion vfx on the ground pipe in the hanger
	exploder ( 5102 );
	level.player playsound ( "big_explosion_02_temp" );
	
	wait 0.5;
	
	//3rd pressure explosion vfx on the left side pipe in the hanger
	exploder ( 5103 );
	level.player playsound ( "big_explosion_02_temp" );
	*/	
	wait 1.5;
	
	flag_wait ( "reaction_explo01a" );
	
	array_call( pressure_explosion_1_before, ::delete );
	array_call( pressure_explosion_1_after, ::show );
	array_call( pressure_explosion_1_after, ::Solid );
	thread pressure_explosion_damage( 1 );
	
	//1st pressure explosion on the street toward the cooling tower
	level thread maps\fusion_fx::big_pipe_explosion_vfx_after_hangar();
	
	wait 0.5;
	
	flag_wait ( "reaction_explo01" );
		
	wait 0.5;
	
	//level.player PlayRumbleOnEntity( "damage_heavy" );
	//earthquake( 0.4, 1, level.player.origin, 200 );
	array_call( pressure_explosion_2_before, ::delete );
	array_call( pressure_explosion_2_after, ::show );
	array_call( pressure_explosion_2_after, ::Solid );
	thread pressure_explosion_damage( 2 );
	
	explosion_cart SetModel( "vehicle_ind_utility_tractor_01_dstrypv" );
	//play animation
	org thread anim_single_solo( explosion_cart, anime );
	
//	cart RotateVelocity ( ( 360, 360, 360 ), 2, 0, 0 );
//	cart moveto ( cart_dest.origin, 2, 0, 1 );
	
	//vfx for pressure explosion under big truck
	explosion_cart thread maps\fusion_fx::underground_pipe_explosion_utility_truck_vfx();
	
	org waittill( anime );
	fusion_utility_cart_collision DisconnectPaths();
}

pressure_explosion_damage( num )
{
	struct = getstruct( "pressure_explosion_" + num + "_damage", "targetname" );
	RadiusDamage( struct.origin, struct.radius, 200, 100 );
}

reaction_pickup_event()
{	
//	pickup_event_soldier_spawners = getentarray ( "reaction_pickup_event_guys", "targetname" );
//	array_thread( pickup_event_soldier_spawners, ::add_spawn_function, ::disable_long_death );
//	pickup_event_soldiers = array_spawn ( pickup_event_soldier_spawners );
//	
//	pickup_event_soldiers[0].animname = "pickup_event_guy1";
//	pickup_event_soldiers[1].animname = "pickup_event_guy2";
	crater_models = getentarray ( "crater_models", "targetname" );
	crater_models = array_add( crater_models, getent( "crater_brush", "targetname" ) );
	crater_geo_pristine = getent ( "crater_brush_surface", "targetname" );
	crater_col = getent ( "crater_connectpaths", "targetname" );
	
	explosion_pickup = getent ( "explosion_pickup", "targetname" );
	explosion_pickup.animname = "pickup";
	explosion_pickup setanimtree();	
	
	//crater_geo hide();
	//crater_col Connectpaths();
	//crater_col notsolid();
	foreach ( model in crater_models )
		model hide();
	
	truck_flip_collision = getent( "truck_flip_collision", "targetname" );
//	fusion_utility_cart_collision = getent( "fusion_utility_cart_collision", "targetname" );
	truck_flip_collision LinkTo( explosion_pickup, "TAG_ORIGIN" );
	truck_flip_collision DisconnectPaths();
	
	scene = [];
//	scene [ scene.size ] = pickup_event_soldiers[0];
//	scene [ scene.size ] = pickup_event_soldiers[1];
	scene [ scene.size ] = explosion_pickup;
	
//	foreach( soldier in pickup_event_soldiers )
//	{
//		soldier.allowdeath = true;
//		soldier.ignoreme = true;
//		soldier.health = 1;
//		soldier setflashbangimmunity( true );
//	}
	
	org = getent ( "org_reaction_pickup_event", "targetname" );
	org anim_first_frame ( scene, "fusion_reaction_pickup_event" );
	
	flag_wait ( "reaction_explo02" );
	
//	scene = array_removeUndefined( scene );
//	scene_final = [];
//	foreach( ent in scene )
//	{
//		if( isai( ent ) )
//		{
//			if( IsAlive( ent ) )
//			{
//				scene_final[ scene_final.size ] = ent;
//			}
//		}
//		else
//		{
//			scene_final[ scene_final.size ] = ent;
//		}
//	}
//	scene = scene_final;
	//scene = array_removeDead_or_dying( scene );
	
	org thread anim_single ( scene, "fusion_reaction_pickup_event" );
	
	explosion_pickup thread reaction_pickup_queue_explosion();
	explosion_pickup thread reaction_pickup_player_proximity();
	
	level waittill( "truck_explosion" );
	
	//wait 3;
	
	//crater_geo delaycall( 0.5,  ::show );
	crater_geo_pristine hide();
	crater_geo_pristine notsolid();
	crater_col solid();
	crater_col DisconnectPaths();
	//crater_truck hide();
//	foreach ( model in crater_models )
//		model delaycall ( 0.5, ::show );
	array_call( crater_models, ::show );
	
	//vfx for pressure explosion under big truck
	explosion_pickup thread maps\fusion_fx::underground_pipe_explosion_pickup_truck_vfx();
	
	thread pressure_explosion_damage( 3 );
	
	truck_flip_collision DisconnectPaths();
	
	//wait 0.75;
	
	//old event of ambient pressure explosion, disable for now
	//exploder ( 1013 );
	//level.player playsound ( "big_explosion_02_temp" );
	
	//wait 1;
	
	//old event of ambient pressure explosion, disable for now
	//exploder ( 1014 );
	//level.player playsound ( "big_explosion_02_temp" );
	
	//wait 0.5;
	
	//old event of ambient pressure explosion, disable for now
	//exploder ( 1015 );
	//exploder ( 1017 );
	//level.player playsound ( "big_explosion_02_temp" );
	
	
	
	//wait 5;
//	array_thread( pickup_event_soldiers, ::enemy_run_away, "vol_final_runaway", true );
}

reaction_pickup_queue_explosion()
{
	level endon( "truck_explosion" );
	self waittillmatch( "single anim", "truck_explosion" );
	level notify( "truck_explosion" );
}

reaction_pickup_player_proximity()
{
	level endon( "truck_explosion" );
	
	distsq = 450*450;
	
	while( 1 )
	{
		if( DistanceSquared( self.origin, level.player.origin ) < distsq )
		{
			guys = [];
			guys[0] = self;
			anim_set_time( guys, "fusion_reaction_pickup_event", .43 );
//			foreach( soldier in guys )
//			{
//				if( IsDefined( soldier ) && IsAlive( soldier ) )
//				{
//					soldier anim_stopanimscripted();
//					soldier kill();
//				}
//			}
			level notify( "truck_explosion" );
}
		wait 0.05;
	}
}

reaction_ai()
{
	ct_enemies_runaway_spawners = getentarray ( "ct_enemies_runaway", "targetname" );
	
	flag_wait ( "ct_combat_retreat" );
	
	array_thread( ct_enemies_runaway_spawners, ::add_spawn_function, ::disable_long_death );
	ct_enemies_runaway = array_spawn ( ct_enemies_runaway_spawners );
	
	flag_wait ( "reaction_explo01" );
	
	array_thread( level.ct_enemies, ::enemy_run_away, "vol_final_runaway", true );
	array_thread( ct_enemies_runaway, ::enemy_run_away, "vol_final_runaway", true );
	//array_setgoalvolume ( level.ct_enemies, "vol_final_runaway" );
	//array_setgoalvolume ( ct_enemies_runaway, "vol_final_runaway" );
	
	close_runners = GetEntArray( "ct_runaway_enemies", "targetname" );
	array_thread( close_runners, ::add_spawn_function, ::disable_long_death );
	close_runners = array_spawn( close_runners );
	//array_thread( close_runners, ::SetGoalVolumeAuto, GetEnt( "vol_final_enemies_goal", "targetname" ) );
	
	flag_wait ( "reaction_explo02" );
	
	final_runaway_spawners = getentarray ( "ct_enemies_final_runaway", "targetname" );
	array_thread( final_runaway_spawners, ::add_spawn_function, ::disable_long_death );
	final_runaway = array_spawn ( final_runaway_spawners, true, true );
	
	flag_wait ( "ct_final_retreat" );
	
	ai = getaiarray ( "axis" );
	array_thread( ai, ::enemy_run_away, "vol_final_runaway", true );
	//array_setgoalvolume ( ai, "vol_final_runaway" );
	//array_thread ( ai, ::runaway_guy_delete );
	//foreach ( guy in ai )
	//	guy.ignoreall = true;
}

finale_enemy_transports()
{
	if( IsDefined( level.start_point ) && level.start_point == "cooling_tower" )
		return;
	
	flag_wait( "evacuation_started" );
	
	transport_01 = spawn_vehicle_from_targetname ( "ct_enemy_transport_01" );
	transport_01 SetMaxPitchRoll ( 30, 30 );
	transport_01 maps\_vehicle::vehicle_lights_on( "running" );
	transport_01.snd_disable_vehicle_system = true;
	
	transport_02 = spawn_vehicle_from_targetname ( "ct_enemy_transport_02" );
	transport_02 SetMaxPitchRoll ( 30, 40 );
	transport_01 maps\_vehicle::vehicle_lights_on( "running" );
	transport_02.snd_disable_vehicle_system = true;
	
	//transport_03 = spawn_vehicle_from_targetname ( "ct_enemy_transport_03" );
	//transport_03 SetMaxPitchRoll ( 30, 30 );
	
	//transport_04 = spawn_vehicle_from_targetname ( "ct_enemy_transport_04" );
	//transport_04 SetMaxPitchRoll ( 30, 40 );
	flag_wait ( "hangar_enemies" );
	transport_01.snd_disable_vehicle_system = false;
	transport_02.snd_disable_vehicle_system = false;

	flag_wait ( "hangar_combat_retreat_02" );
	
	delaythread( 1, ::spawn_transport_flying_01 );
	
	flag_wait( "hangar_exit_retreat" );
	
	autosave_by_name();
	
	delaythread( 1, ::spawn_transport_flying_02 );
	
	level.get_pdrone_crash_location_override = ::get_pdrone_crash_location_override;
	
	retreat_drones = spawn_vehicles_from_targetname_and_drive ( "kva_retreat_drones" );
	foreach( drone in retreat_drones )
	{
		drone thread use_phantom_drone_model();
		drone thread maps\_shg_utility::make_emp_vulnerable();
	}
	
	//thread kva_retreat_drones_animated();
	
	gopath ( transport_01 );
	snd_message ("hangar_transport_01_away", transport_01);
	
	flag_wait ( "ct_combat_retreat" );
	
	retreat_drones_02 = spawn_vehicles_from_targetname_and_drive ( "kva_retreat_drones_02" );
	foreach( drone in retreat_drones_02 )
	{
		drone thread use_phantom_drone_model();
		drone thread maps\_shg_utility::make_emp_vulnerable();
	}
	
	gopath ( transport_02 );
	
	
	//flag_wait ( "reaction_explo02" );
	
	//gopath ( transport_03 );
	
	//flag_wait ( "ct_final_retreat" );
	
	//wait 4;
	
	//gopath ( transport_04 );
	
	flag_wait( "collapse_start" );
	allDrones = array_combine( retreat_drones, retreat_drones_02 );
	foreach( drone in allDrones )
	{
		if( IsDefined( drone ) && IsAlive( drone ) )
			drone kill();
	}
}

spawn_transport_flying_01()
{
	transport_flying_01 = spawn_vehicles_from_targetname_and_drive ( "ct_enemy_transport_flying_01" );
	snd_message("hangar_transport_flying_01_away", transport_flying_01[0]);
}

spawn_transport_flying_02()
{
	transport_flying_02 = spawn_vehicles_from_targetname_and_drive ( "ct_enemy_transport_flying_02" );
	snd_message("hangar_transport_flying_02_away", transport_flying_02[0]);
}

evacuation_first_drones_think()
{
	level endon( "collapse_start" );
	self waittill( "death" );
	
	if( !IsDefined( level.evacuation_first_drones_dead ) )
		level.evacuation_first_drones_dead = 0;
	level.evacuation_first_drones_dead++;
	
	if( level.evacuation_first_drones_dead >= 5 )
		flag_set( "evacuation_first_drones_down" );
}

use_phantom_drone_model()
{
	new_model = "vehicle_drone_02";
	
	//drone setmodel( "vehicle_drone_02" );
	self hide();
	drone_model = spawn( "script_model", self.origin );
	drone_model.angles = self.angles;
	drone_model SetModel( new_model );
	drone_model linkto( self );
	drone_model SetContents( 0 ); //use base model collision
	self.death_model_override = new_model;
	self waittill( "death" );
	
	drone_model delete();
}

kva_retreat_drones_animated()
{
	drone_deploy_run_npc = getent( "drone_deploy_run_npc", "targetname" );
	drone_deploy_crouch_npc = getent( "drone_deploy_crouch_npc", "targetname" );
	
	thread kva_retreat_drone_think( drone_deploy_run_npc, false );
	thread kva_retreat_drone_think( drone_deploy_crouch_npc, false, "Cover Crouch" );
		
	//drone thread use_phantom_drone_model();
	//drone thread maps\_shg_utility::make_emp_vulnerable();
}

kva_retreat_drone_think( npcSpawner, isRun, approachType )
{
	guy = npcSpawner spawn_ai( true );
	guy.animname = "generic";
	struct = getstruct( npcSpawner.target, "targetname" );
	org = spawn( "script_origin", struct.origin );
	org.angles = struct.angles;
	droneSpawner = getent( struct.target, "targetname" );
	
	anime = GetSubStr( struct.animation, 0, struct.animation.size - 4 );
	drone_prop = spawn( "script_model", guy GetTagOrigin( "TAG_STOWED_BACK" ) );
	drone_prop SetModel( droneSpawner.model );
	drone_prop.angles = guy GetTagAngles( "TAG_STOWED_BACK" );
	drone_prop LinkTo( guy, "TAG_STOWED_BACK" );
	drone_prop.animname = "personal_drone";
	drone_prop UseAnimTree( level.scr_animtree[ "personal_drone" ] );
	drone_prop thread anim_loop_solo( drone_prop, "personal_drone_folded_idle" );
	
	//anim_reach_and_approach_solo
	
	if( IsDefined( approachType ) )
		org anim_reach_and_approach_solo( guy, anime, undefined, "Cover Crouch" );
	else
		org anim_generic_reach( guy, anime );
	org anim_generic_reach( guy, anime );
	if( isRun )
		org thread anim_generic_run( guy, anime );
	else
		org thread anim_generic( guy, anime );
	
	
	droneSpawner.origin = drone_prop.origin;
	droneSpawner.angles = drone_prop.angles;
	
	drone = droneSpawner spawn_vehicle();
	//drone.origin = drone_prop.origin;
	//drone.angles = drone_prop.angles;
	drone_prop delete();
	drone.animname = "personal_drone";
	org anim_single_solo( drone, anime );
	
	if( IsDefined( drone.target ) )
		drone gopath();
	if( drone.script_team == "axis" )
		drone thread maps\_shg_utility::make_emp_vulnerable();
}

get_pdrone_crash_location_override()
{
	level.get_pdrone_crash_location_override = undefined;
	
	return (level.player.origin + (200 * AnglesToForward( level.player.angles )));
}

finale_enemy_gaz()
{
	flag_wait( "evacuation_started" );
	
	if( IsDefined( level.start_point ) && level.start_point != "cooling_tower" )
		thread finale_enemy_gaz_1();
	
	gaz_02 = spawn_vehicle_from_targetname ( "retreat_gaz_02" );
	gaz_03 = spawn_vehicle_from_targetname ( "retreat_gaz_03" );
	if (level.currentgen)
		gaz_04 = spawn_vehicle_from_targetname ( "retreat_gaz_04" );
	
	gaz_02 godon();
	gaz_03 godon();
	
	
	flag_wait ( "ct_final_retreat" );
	
	wait 1;
	
	snd_message("start_gaz_02_retreat", gaz_02);
	
	gopath ( gaz_02 );
	
	wait 1.5;
	
	snd_message("start_gaz_03_retreat", gaz_03);
	
	gopath ( gaz_03 );
	
	
}

finale_enemy_gaz_1()
{
	gaz_01 = spawn_vehicle_from_targetname ( "retreat_gaz_01" );
	gaz_01 godon();
	gaz_01.snd_disable_vehicle_system = true;
	
	flag_wait ( "hangar_enemies" );
	gaz_01.snd_disable_vehicle_system = false;

	flag_wait ( "stop_ambient_explosions" );
	wait 5;
	
	gopath ( gaz_01 );
}

cooling_tower_collapse()
{
	collapse_geo_before = GetEntArray( "collapse_geo_before", "targetname" );
	collapse_geo_after = GetEntArray( "collapse_geo_after", "targetname" );
	array_call( collapse_geo_after, ::hide );
	array_call( collapse_geo_after, ::NotSolid );
	
	tower_static_ents = GetEntArray ( "cooling_tower_static", "targetname" );
	
	thread cooling_tower_collapse_visibility( tower_static_ents );
	
	flag_wait ( "collapse_start" );
	snd_message( "tower_collapse_prep");
	
	dummy_rig = spawn_anim_model( "player_rig", (0, 0, 0) );
	dummy_rig hide();
	
	debris = spawn( "script_model", (0, 0, 0) );
	debris SetModel( "fus_sever_debris" );
	debris hide();
	debris.animname = "collapse_debris_arm";
	debris setanimtree();
	
	debris_02 = spawn_anim_model( "fus_sever_debris_02" );
	debris_02 hide();
	
	fus_end_scene_rubble = spawn( "script_model", (0, 0, 0) );
	fus_end_scene_rubble SetModel( "fus_end_scene_rubble" );
	fus_end_scene_rubble hide();
	fus_end_scene_rubble.animname = "fus_end_scene_rubble";
	fus_end_scene_rubble setanimtree();
	
	fusion_chunk_combo = spawn_anim_model( "fusion_chunk_combo" );
	fusion_rock_chunk01 = spawn_anim_model( "fusion_rock_chunk01" );
	fusion_rock_chunk02 = spawn_anim_model( "fusion_rock_chunk02" );
	
	player_dismembered_arm = spawn_anim_model( "player_dismembered_arm" );
	player_dismembered_arm hide();
	
	guys = [];
	guys [0] = level.burke;
	guys [1] = level.player_rig;
	guys [2] = debris;
	guys [3] = player_dismembered_arm;
	guys [4] = fus_end_scene_rubble;
	guys [5] = debris_02;
	guys [6] = fusion_chunk_combo;
	guys [7] = fusion_rock_chunk01;
	guys [8] = fusion_rock_chunk02;
	
	collapse_parts = [];
	
	part = spawn ( "script_model", ( 0, 0, 0 ) );
	part SetModel ( "fus_cooling_tower_collapse_chunks" );
	part.animname = "fus_cooling_tower_collapse_chunks";
	part setanimtree();
	collapse_parts [ "chunks" ] = part;
	
	part = spawn ( "script_model", ( 0, 0, 0 ) );
	part SetModel ( "fus_cooling_tower_collapse_concrete_shattered" );
	part.animname = "fus_cooling_tower_collapse_concrete_shattered";
	part setanimtree();
	collapse_parts [ "concrete_shattered" ] = part;
	
	part = spawn ( "script_model", ( 0, 0, 0 ) );
	part SetModel ( "fus_cooling_tower_collapse_concrete_shattered2" );
	part.animname = "fus_cooling_tower_collapse_concrete_shattered2";
	part setanimtree();
	collapse_parts [ "concrete_shattered2" ] = part;
	
	part = spawn ( "script_model", ( 0, 0, 0 ) );
	part SetModel ( "fus_cooling_tower_collapse_street_collapse" );
	part.animname = "fus_cooling_tower_collapse_street_collapse";
	part setanimtree();
	collapse_parts [ "street" ] = part;
	
	array_call ( collapse_parts, ::hide );
	
	anm2 = getanim_from_animname("fusion_silo_collapse_vm_pt02", level.player_rig.animname);
	animtime_anm2 = GetAnimLength( anm2 );
	
	//define angles and origin of collapse animation part 2
	delta_angles = GetAngleDelta ( level.scr_anim[ "player_rig" ][ "fusion_silo_collapse_vm_pt02" ], 0, 1 );
	delta_origin = GetMoveDelta ( level.scr_anim[ "player_rig" ][ "fusion_silo_collapse_vm_pt02" ], 0, 1 );
		
	org = getent ( "org_collapse_new", "targetname" );
	
	level.player thread collapse_player_dynamic_speed( org );
	
	org anim_first_frame_solo ( dummy_rig, "fusion_silo_collapse_finale" );
	org anim_first_frame ( collapse_parts, "fusion_collapse_ground_tower" );
	
	
	level.player DisableOffhandWeapons();	
	level.player EnableInvulnerability();
	level.player.ignoreme = true;
	
	//lead up ground pipe steam explosion before all big moment vfx and anim start
	level thread maps\fusion_fx::pressure_explosion_lead_up();

	wait 1.1; //wait for lead-up explosions finish

	level notify( "collapse_animation_started" );
	snd_message( "tower_collapse_start");
	org thread collapse_animate_lamps( "fusion_collapse_ground_tower" );
	
	//vfx for fusion tower big moment
	level thread maps\fusion_fx::big_moment_ending_vfx( collapse_parts );
	
	array_call(tower_static_ents, ::Hide);
	array_call ( collapse_parts, ::show );
	
	enemies = getaiarray ( "axis" );
	foreach ( enemy in enemies )
		enemy kill();
	
	array_thread( GetEntArray( "collapse_stop_signs", "targetname" ), ::collapse_stop_sign_think, org );
	array_thread( GetAIArray( "allies" ), ::collapse_friendly_think, org );
	
	org thread anim_single ( collapse_parts, "fusion_collapse_ground_tower" );
	
	flag_wait ( "tower_knockback" );
	thread collapse_shellshock();
	snd_message( "tower_collapse_player_stumble" );
	
	org delaythread( 1, ::anim_first_frame_solo, level.burke, "fusion_silo_stumble_npc" );
	level.burke delaycall( 1, ::hide );
	noself_delayCall( 1, ::setsaveddvar, "g_friendlynamedist", 0 );
	level.burke delaycall( 1, ::SetContents, 0 );
	
	level.player thread setup_player_for_scene();
	level.player anim_first_frame_solo ( level.player_rig, "fusion_silo_collapse_vm_pt01" );
	
	linkDelay = 0.5;
	level.player playerlinktoblend ( level.player_rig, "tag_player", linkDelay );
	level.player delaycall( linkDelay, ::PlayerLinkToDelta, level.player_rig, "tag_player", 1, 15, 15, 15, 15, true );
	level.player_rig delaycall( linkDelay, ::show );
	anime = "fusion_silo_collapse_vm_pt01";
	
	delayThread( 1, ::array_call, collapse_geo_before, ::delete );
	delayThread( 1, ::array_call, collapse_geo_after, ::show );
	delayThread( 1, ::array_call, collapse_geo_after, ::Solid );
	
	thread lerp_fov_overtime( 3, 75 );
	
	animlength = GetAnimLength( level.player_rig getanim( anime ) );
	level.player delaycall( animlength - 0.5, ::EnableWeapons );
	
	level.player thread collapse_player_look_at_tower( anime, org.origin );
	level.player anim_single_solo ( level.player_rig, anime );
	level.player thread setup_player_for_gameplay();
	
	level.player_rig hide();
	level.player unlink();
	
	
	flag_wait ( "tower_debris" );
	snd_message( "tower_collapse_player_knockback" );	
	wait 0.3; //wait for explosions to happen
	
	level.player DisableWeapons();
	
	thread lerp_fov_overtime( 3, 65 );
	level.player thread setup_player_for_scene();
	level.player anim_first_frame_solo ( level.player_rig, "fusion_silo_collapse_vm_pt02" );
	
	end2_angles = CombineAngles ( level.player_rig.angles, ( 0, 0, delta_angles ) );
	end2_origin = level.player_rig.origin + delta_origin[0] * anglestoforward ( level.player_rig.angles ) +  delta_origin[1] * anglestoright ( level.player_rig.angles ) + delta_origin[2] * anglestoup ( level.player_rig.angles );
	
	adjust_origin = dummy_rig.origin - end2_origin;
	adjust_angles = dummy_rig.angles - end2_angles;
	
	level.player_rig.angles = (0, VectorToAngles( org.origin - level.player.origin )[1], 0);
	level.player_rig.origin = level.player.origin;
	
	linkDelay = 0.5;
	level.player playerlinktoblend ( level.player_rig, "tag_player", linkDelay );
	level.player delaycall( linkDelay, ::PlayerLinkToDelta, level.player_rig, "tag_player", 1, 20, 20, 20, 0, true );
	level.player_rig delaycall( linkDelay, ::show );
	
	level.player FreezeControls( true );
	level.player_rig anim_single_solo ( level.player_rig, "fusion_silo_collapse_vm_pt02" );
	
	//thread grey_out_player();
	level notify ( "stop_player_pos_update" );
	
	snd_message("silo_collapse_plr_stunned");
	
	debris show();
	debris_02 show();
	player_dismembered_arm show();
	fus_end_scene_rubble show();
	level.burke show();
	
	snd_message("fus_outro_burke_foley");
	
	org thread anim_single ( guys, "fusion_silo_collapse_finale" );
	thread maps\fusion_fx::end_arm_blood_init( guys );
	
	anm = getanim_from_animname("fusion_silo_collapse_finale", level.player_rig.animname);
	level notify("stop_evacuation_kiosk_movie");
	prep_cinematic( "fusion_endlogo" );
	animtime = GetAnimLength( anm );
	wait animtime - 4.0;
	
	flag_set( "play_ending" );
	//flag_wait( "play_ending" );
//	fade_delay = 0.5;
//	wait fade_delay;
	
	fade_out_time = 2;
	thread ending_fade_out( fade_out_time );
	snd_message( "ending_fade_out" , fade_out_time );
	
	thread hide_player_hud();
	
	wait fade_out_time;
	
	thread play_cinematic( "fusion_endlogo", true, true );
	snd_message( "fusion_endlogo" );
	thread collapse_cleanup();
	//adjust to match cinematic timing
	wait 9.5;
	
	thread introscreen_generic_fade_out("black", 999, 0, 0 );
	
	nextmission();
}

ending_fade_out( fade_out_time )
{
//	if ( !isdefined( fade_in_time ) )
//    	fade_in_time = 1.5;

	SetBlur( 10, fade_out_time );

    introblack = NewHudElem();
    introblack.x = 0;
    introblack.y = 0;
    introblack.horzAlign = "fullscreen";
    introblack.vertAlign = "fullscreen";
    //introblack.foreground = true;
    introblack SetShader( "black", 640, 480 );

    if ( IsDefined( fade_out_time ) && fade_out_time > 0 )
    {
	    introblack.alpha = 0;
	    introblack FadeOverTime( fade_out_time );
	    introblack.alpha = 1;
	    wait( fade_out_time );
    }
	waittillframeend; //extra time to start cinematic
//    wait pause_time;
//    
//    
//    if ( IsDefined( fade_in_time ) && fade_in_time > 0 )
//    {
//	    introblack.alpha = 1;
//	    introblack FadeOverTime( fade_in_time );
//	    introblack.alpha = 0;
//    }

    introblack destroy();
}

collapse_shellshock()
{
	shock_duration = 999;
	level.player ShellShock ( "fusion_pre_collapse", shock_duration );
	
	material = "fullscreen_bloodsplat_bottom";
	level.player delaythread(1, ::play_fullscreen_blood_splatter,material, (10), .5, .5, 1);
	
	flag_wait ( "tower_debris" );
	

	
	// This is when the arm impact happen
	impact_frame = 833;
	anim_start = 680;
	wait_time = ( impact_frame - anim_start ) / 30.0; // waittime in seconds
	wait wait_time;
	
	material = "splatter_alt_sp";
	level.player delaythread(2.16, ::play_fullscreen_blood_splatter, material,999, .5, .5, .2);
	
	shock_duration = 10;
	level.player ShellShock ( "fusion_collapse", shock_duration );
	
	wait 8;
	
	shock_duration = 999;
	level.player ShellShock ( "fusion_pre_collapse", shock_duration );
}

collapse_friendly_think( org )
{
	delayMod = 0.0005;
	delay = distance( self.origin, org.origin ) * delayMod - 0.97;
	
	wait delay;
	
	self flashBangStart( 4 );
	
	if( self != level.burke )
	{
		flag_wait ( "tower_knockback" );
		wait 3;
		self stop_magic_bullet_shield();
		self delete();
	}
}

collapse_stop_sign_think( org )
{
	//wait 2;
	
	delayMod = 0.0005;
	delay = distance( self.origin, org.origin ) * delayMod - 0.97;
	
	wait delay;
	
	sign = getent( self.target, "targetname" );
	sign linkto( self );
	
	awayDirection = VectorToAngles( org.origin - self.origin );
	if( self.angles[1] - awayDirection[1] > -180 )
		angles = awayDirection + (0, -90, 90); //front
	else
		angles = awayDirection + (0, 90, -90); //back
	
	duration = 0.3;
	self rotateto( angles, duration, .1, 0 );
	
	wait duration;
	sign delete();
	self delete();
	//angles = 
	//self rotateto( self.angles
	//self rotate
	//stop_signs = GetEntArray( "collapse_stop_signs", "targetname" );
	//array_call( stop_signs, ::delete );
}

collapse_animate_lamps( anime )
{
	lights = GetEntArray( "collapse_streetlight", "targetname" );
	
	foreach( light in lights )
	{
		if( IsDefined( light ) )
			light delete();
	}
	
	//array_call( GetEntArray( "collapse_streetlight", "targetname" ), ::delete ); //remove old lamps
	
	lamps = [];
	for( i = 1; i < 10; i++)
	{
		lamps[lamps.size] = spawn_anim_model( "fusion_silo_lamp0" + i );
	}
	for( i = 0; i <= 5; i++)
	{
		lamps[lamps.size] = spawn_anim_model( "fusion_silo_lamp1" + i );
	}
	
	self anim_single( lamps, anime );
}

cooling_tower_collapse_visibility( tower_static_ents )
{
	level endon( "collapse_start" );
	
	array_call(tower_static_ents, ::hide);
	
	while( 1 )
	{
		flag_wait( "show_collapse_tower" );
		array_call(tower_static_ents, ::show);
		
		flag_waitopen( "show_collapse_tower" );
		array_call(tower_static_ents, ::hide);
	}
}

grey_out_player()
{
	overlay = create_client_overlay( "white", 0, level.player );
	overlay.sort = -1;
	overlay.foreground = true;
	overlay.color = (.6, .6, .6);
	
	duration = 0.1;
	alpha = 1;
	
	overlay fadeOverTime( duration );
	overlay.alpha = alpha;
	wait duration;
	
	duration = 0.05;
	wait duration;
	
	duration = 0.1;
	
	alpha = 0;
	overlay fadeOverTime( duration );
	overlay.alpha = alpha;
	wait duration;
	overlay Destroy();
}

collapse_player_dynamic_speed( org )
{
	level endon( "stop_player_pos_update" );

	minDist = 2636;
	//maxDist = 3557;
	maxDist = 4000;
	maxDelta = maxDist - minDist;
	
	minSpeed = 0.1;
	maxSpeed = 1;
	
	while ( 1 )
	{
		speed_normalized = (Distance( level.player.origin, org.origin ) - minDist) / maxDelta;
		//iprintln( speed_normalized );
		if( speed_normalized < minSpeed )
			speed_normalized = minSpeed;
		else if( speed_normalized > maxSpeed )
			speed_normalized = maxSpeed;

		level.player SetMoveSpeedScale( speed_normalized );
		wait .05;
	}
	
	level.player blend_MoveSpeedscale_Percent( 50, 3 );
}

collapse_player_look_at_tower( anime, end )
{
	animation = getanim_from_animname( anime, level.player_rig.animname );
	time = GetAnimLength( animation );
	angles = VectorToAngles( end - level.player.origin );
	level.player SetPlayerAngles((0, angles[1], 0));
}

collapse_cleanup()
{
	wait 1;
	ai = GetAIArray();
	foreach( guy in ai )
	{
		if( IsDefined( guy.magic_bullet_shield ) && guy.magic_bullet_shield )
			guy stop_magic_bullet_shield();
	}
	array_call( ai, ::delete );
}

//full screen blood splatter_alt moderate damage
play_fullscreen_blood_splatter(material, time, fadein, fadeout, max_alpha)
{
	overlay = NewClientHudElem( self );
	overlay.x = 0;
	overlay.y = 0;

	overlay SetShader( material, 640, 480 );
	
	overlay.splatter = true;
	overlay.alignX = "left";
	overlay.alignY = "top";
	overlay.sort = 1;
	overlay.foreground = 0;
	overlay.horzAlign = "fullscreen";
	overlay.vertAlign = "fullscreen";
	overlay.alpha = 0;
	
	fade_counter = 0;
	if (!IsDefined(fadein))
		fadein = 1;
	if (!IsDefined(fadeout))
		fadeout = 1;
	if (!IsDefined(max_alpha))
		max_alpha = 1;
	
	//fade up
	step_time = 0.05;
	
	if ( fadein > 0 )
	{
		current_alpha = 0;
		increment_alpha = max_alpha / (fadein/step_time); 
		AssertEx( increment_alpha > 0, "alpha not increasing; infinite loop" );
		while ( current_alpha < max_alpha )
		{
			overlay.alpha = current_alpha;
			current_alpha = current_alpha + increment_alpha;
			wait step_time;
	}
	}
	
	overlay.alpha = max_alpha;
	
	wait(time - (fadein + fadeout));

	//fade down
	if ( fadeout > 0 )
	{
		current_alpha = max_alpha;
		decrement_alpha = max_alpha / (fadeout/step_time);
		AssertEx( decrement_alpha > 0, "alpha not decreasing; infinite loop" );
		while ( current_alpha > 0 )
		{
			overlay.alpha = current_alpha;
			current_alpha = current_alpha - decrement_alpha;
			wait step_time;
		}
	}
	
	overlay.alpha = 0;
	
	overlay destroy();
}

warbird_shooting_think( check_line_of_sight )
{
	level.player endon( "death" );
	self endon( "death" );
	
	self.mgturret[ 0 ] SetMode( "manual" );
	self.mgturret[ 1 ] SetMode( "manual" );
	
	//init flag if not set
	if( !self ent_flag_exist( "fire_turrets" ) )
		self ent_flag_init( "fire_turrets" );
	self ent_flag_set( "fire_turrets" );
	
	self thread warbird_fire_monitor();
	
	while( true )
	{
		self waittill( "warbird_fire" );
		self thread warbird_fire( check_line_of_sight );
	}
}

warbird_fire( check_line_of_sight )
{
	self endon( "death" );
	
	turret_1 = self.mgturret[ 0 ];
	turret_2 = self.mgturret[ 1 ];
	
	while( self ent_flag( "fire_turrets" ) )
	{
		all_guys = GetAIArray( "axis" );
		if( IsDefined( level.drones ) && IsDefined( level.drones["axis"].array ) )
			all_guys = array_combine( all_guys, level.drones["axis"].array );
		guys = [];
		
		foreach( guy in all_guys ) //remove ignoreme guys
		{
			if( IsDefined( guy.ignoreme ) && guy.ignoreme )
				continue;
			else
				guys[ guys.size  ] = guy;
		}
		guys = SortByDistance( guys, self.origin );
		
		enemy_target = undefined;
		foreach ( guy in guys )
		{
			if ( !IsDefined( guy ) )
				continue;
			
			if ( !IsAlive( guy ) )
				continue;
			
			if ( IsDefined( check_line_of_sight ) && check_line_of_sight )
			{
				turret_flash_pos = self.mgturret[0] GetTagOrigin( "tag_flash" );
				target_pos = guy GetEye();
				target_dir = VectorNormalize( target_pos - turret_flash_pos );
				start_pos = target_pos + ( target_dir * 20 );
				
				if ( !SightTracePassed( start_pos, target_pos, false, guy, self.mgturret[0] ) )
					continue;
			}
			
			enemy_target = guy;
			break;
		}
		
		if ( IsDefined( enemy_target ) )
		{
			turret_1 SetTargetEntity( enemy_target );
			turret_2 SetTargetEntity( enemy_target );
			
			turret_1 TurretFireEnable();
			turret_2 TurretFireEnable();
			
			turret_1 StartFiring();
			turret_2 StartFiring();
			
			self wait_for_warbird_fire_target_done( enemy_target, check_line_of_sight );
			
			turret_1 ClearTargetEntity();
			turret_2 ClearTargetEntity();
			
			turret_1 TurretFireDisable();
			turret_2 TurretFireDisable();
		}
		
		wait( 0.05 );
	}
	
	turret_1 TurretFireDisable();
	turret_2 TurretFireDisable();
}

wait_for_warbird_fire_target_done( enemy_target, check_line_of_sight )
{
	enemy_target endon( "death" );
	
	if ( !self ent_flag( "fire_turrets" ) )
		return;
	
	self endon( "fire_turrets" );
	
	while ( true )
	{
		// occasionally check if you still have LOS to target
		if ( IsDefined( check_line_of_sight ) && check_line_of_sight )
		{
			turret_flash_pos = self.mgturret[0] GetTagOrigin( "tag_flash" );
			target_pos = enemy_target GetEye();
			target_dir = VectorNormalize( target_pos - turret_flash_pos );
			start_pos = turret_flash_pos + ( target_dir * 20 );
					
			if ( !SightTracePassed( start_pos, target_pos, false, enemy_target, self.mgturret[0] ) )
			{
				return;
			}
		}
		
		wait 0.3;
	}
}

warbird_fire_monitor()
{	
	self endon( "death" );
	
	self waittill( "warbird_stop_firing" );
	self ent_flag_clear( "fire_turrets" );
}

heli_looking_at_target( guy )
{
	angle = 45;
	cos_angle = Cos( angle );
	forward = AnglesToForward( self.angles );
	guy_to_heli = VectorNormalize( guy.origin - self.origin );
	
	if( VectorDot( forward, guy_to_heli ) >= cos_angle )
	{
		return true;
	}
	else
	{
		return false;
	}
}

//ITIOT stuff
demo_skip_forward()
{
	flag_wait ( "start_itiot" );
	
	if ( getdvarint ( "demo_itiot" ) == 1 )
	{	
		wait 0.5;
		
		level.overlay = create_client_overlay( "black", 0, level.player );
		level.overlay.sort = -1;
		level.overlay.foreground = true;
		level.overlay.color = (0, 0, 0);
		level.overlay fadeOverTime( 1 );
		level.overlay.alpha = 1;
		//thread introscreen_generic_fade_out("black", 5, 1, 1 );
		snd_message( "itiot_fade_out" );
		lines = [];
		lines[0] = "In the interest of time...";
		thread demo_feed_lines(lines, 1);
		
		wait 1;
		
		if ( IsDefined( level.player.drivingVehicle ) )
		{
			level.player.drivingVehicle notify( "exit_vehicle_dof" );
			level.player player_dismount_vehicle();
		}
		else if ( IsDefined( level.player.drivingVehicleAndTurret ) )
		{
			level.player.drivingVehicleAndTurret notify( "exit_vehicle_dof" );
			level.player.drivingVehicleAndTurret notify( "dismount_vehicle_and_turret" );
			level.player.drivingVehicleAndTurret = undefined;
		}
		
		//start cleanup
		if( IsDefined( level.alpha_leader ) )
			level.alpha_leader stop_magic_bullet_shield();
		if( IsDefined( level.joker ) )
			level.joker stop_magic_bullet_shield();
		if( IsDefined( level.carter ) )
			level.carter stop_magic_bullet_shield();
		if( IsDefined( level.burke ) )
			level.burke stop_magic_bullet_shield();
		
		level.burke anim_stopanimscripted();
		level.joker anim_stopanimscripted();
		
		level notify( "itiot_cleanup" );
		
		array_call( GetAIArray(), ::delete ); //remove all ai
		array_call( GetEntArray( "script_vehicle_x4walker_wheels_turret", "classname" ), ::delete ); //remove mobile turrets
		if(IsDefined(level.player.linked_to_cover))
			level.player.linked_to_cover vehicle_scripts\_cover_drone::player_unlink_from_cover();
		array_call( GetEntArray( "script_vehicle_cover_drone", "classname" ), ::delete ); //remove mobile cover
		array_call( GetEntArray( "mobile_turret", "targetname" ), ::delete ); //remove mobile turrets
		array_call( GetEntArray( "script_vehicle_pdrone", "classname" ), ::delete ); //remove ally personal drones
		//array_call( GetEntArray( "script_vehicle_xh9_warbird", "classname" ), ::delete ); //remove warbirds  //this deletes too much
		
		//end cleanup
		level.player SetStance( "stand" );
		level.player FreezeControls( true );
		level.player teleport_player( GetStruct( "itiot_player_start", "targetname" ) );
		level.player SetPlayerAngles( level.player.angles + (7, 0, 0) ); //tilt view down slightly
	
		wait 4;
		snd_message( "itiot_fade_in" );
		
		level.player FreezeControls ( false );
		
		flag_set( "flag_shut_down_reactor_failed" );
		flag_set( "evacuation_started" );
	}
}

 demo_feed_lines( lines, interval )
 {
    keys = GetArrayKeys( lines );

    for ( i = 0; i < keys.size; i++ )
    {
        key = keys[ i ];
        time = ( i * interval ) + 1;
        delayThread( time, ::CenterLineThread, lines[ key ], ( lines.size - i - 1 ), interval, key );
    }
 }
 
 CenterLineThread( string, size, interval, index_key )
 {
    level notify( "new_introscreen_element" );

    hudelem = NewHudElem();
    hudelem.x = 0;
    hudelem.y = 0;
    hudelem.alignX = "center";
    hudelem.alignY = "middle";
    hudelem.horzAlign = "center";
    hudelem.vertAlign = "middle_adjustable";
    hudelem.sort = 1;// force to draw after the background
    hudelem.foreground = true;
    hudelem SetText( string );
    hudelem.alpha = 0;
    hudelem FadeOverTime( 0.2 );
    hudelem.alpha = 1;

    hudelem.hidewheninmenu = true;
    hudelem.fontScale = 2.4;// was 1.6 and 2.4, larger font change
    hudelem.color = ( 0.8, 1.0, 0.8 );
    hudelem.font = "objective";
    hudelem.glowColor = ( 0.3, 0.6, 0.3 );
    hudelem.glowAlpha = 1;
    duration = Int( ( interval * 1000 ) + 4000 );
    hudelem SetPulseFX( 30, duration, 700 );// something, decay start, decay duration

    thread maps\_introscreen::hudelem_destroy( hudelem );

    if ( !isdefined( index_key ) )
                    return;
    if ( !isstring( index_key ) )
                    return;
    if ( index_key != "date" )
                    return;
 }
 
 introscreen_generic_fade_out( shader, pause_time, fade_in_time, fade_out_time )
{
    if ( !isdefined( fade_in_time ) )
    	fade_in_time = 1.5;

    introblack = NewHudElem();
    introblack.x = 0;
    introblack.y = 0;
    introblack.horzAlign = "fullscreen";
    introblack.vertAlign = "fullscreen";
    introblack.foreground = true;
    introblack SetShader( shader, 640, 480 );

    if ( IsDefined( fade_out_time ) && fade_out_time > 0 )
    {
	    introblack.alpha = 0;
	    introblack FadeOverTime( fade_out_time );
	    introblack.alpha = 1;
	    wait( fade_out_time );
    }

    wait pause_time;
    
    
    if ( IsDefined( fade_in_time ) && fade_in_time > 0 )
    {
	    introblack.alpha = 1;
	    introblack FadeOverTime( fade_in_time );
	    introblack.alpha = 0;
    }

    introblack destroy();
}

prep_cinematic( cinematicName )
{
	setsaveddvar("cg_cinematicFullScreen", "0");	// don't draw while paused
	cinematicingame( cinematicName, 1 );	// start it paused
	level.current_cinematic = cinematicName;
}

play_cinematic( cinematicName, no_audio, no_pause )
{
	if( !isdefined( no_audio ) )
		aud_send_msg("begin_cinematic", cinematicName);
		
	if (isdefined(level.current_cinematic))
	{
		assert(level.current_cinematic == cinematicName);
		pauseCinematicInGame( 0 );
		setsaveddvar("cg_cinematicFullScreen", "1");	// start drawing
		level.current_cinematic = undefined;
	}
	else
	{
		cinematicingame( cinematicName );
	}
	if( !isdefined( no_pause ) || !no_pause )
		setsaveddvar("cg_cinematicCanPause", "1");	// allow pausing during movie
	wait 1;
	while( iscinematicplaying() )
	{
		wait .05;
	}
	if( !isdefined( no_pause ) || !no_pause )
		setsaveddvar("cg_cinematicCanPause", "0");	// back to the default
	
	if( !isdefined( no_audio ) )
		aud_send_msg("end_cinematic", cinematicName);
}

#using_animtree( "generic_human" );
setup_evacuation_scene()
{
	maps\_drone_civilian::init();
	maps\_drone_ai::init();
	
	level.evacuation_scene_spawners = [];
	level.evacuation_scene_spawners[ "civilian" ] = GetEntArray( "evacuation_scene_spawners_civilians", "targetname" );
	level.evacuation_scene_spawners[ "axis" ] = GetEntArray( "evacuation_scene_spawners_axis", "targetname" );
	
	level.evacuation_scene_index = [];
	level.evacuation_scene_index[ "civilian"] = 0;
	level.evacuation_scene_index[ "axis"] = 0;
	
	//--Civilians--//
	//run cycles
	level.scr_anim[ "civilian" ][ "civilian_run_hunched_A_relative" ] = %civilian_run_hunched_A_relative;
	level.scr_anim[ "civilian" ][ "civilian_run_upright_relative" ] = %civilian_run_upright_relative;
	level.scr_anim[ "civilian" ][ "unarmed_scared_run" ] = %unarmed_scared_run;
	
	//scenes
	level.scr_anim[ "civilian" ][ "civilian_leaning_death" ] = %civilian_leaning_death;
	level.scr_anim[ "civilian" ][ "DC_Burning_bunker_stumble" ] = %DC_Burning_bunker_stumble;
	level.scr_anim[ "civilian" ][ "civilian_run_upright_turnL90" ]	 = %civilian_run_upright_turnL90;
	level.scr_anim[ "civilian" ][ "civilian_run_hunched_turnL90_slide" ] = %civilian_run_hunched_turnL90_slide;
	
	thread handle_evacuation_scene_triggers();
}

handle_evacuation_scene_triggers()
{
	triggers = GetEntArray( "evacuation_scene_trigger", "script_noteworthy" );
	
	array_thread( triggers, ::evacuation_scene_trigger_think );
}

evacuation_scene_trigger_think()
{
	spawn_orgs = GetStructArray( self.target, "targetname" );
	
	self waittill( "trigger", player );
	
	//setting flag for fire light to trigger as player enters trigger outside of hangar
	flag_set( "hangar_exit_explosion" );
	
	foreach( org in spawn_orgs )
	{
		org thread evacuation_scene_think();
	}
}

evacuation_scene_think()
{
	spawner = get_evacuation_scene_spawner( self.script_parameters );

	if( IsDefined( self.script_delay ) )
		wait self.script_delay;
	
	if( IsDefined( self.script_noteworthy ) && (self.script_noteworthy == "runner" ) )
	{
		assertex( IsDefined( self.target ), "Target not specified on runner drone" );
		spawner.target = self.target;
		actor = spawner spawn_ai( true );
		spawner.target = undefined;
		actor.origin = self.origin;
		//actor.target = self.target;
		actor.no_friendly_fire_penalty = true;
		actor thread evacuation_scene_run_actor( self.animation, self.script_parameters );
	}
	else if( IsDefined( self.script_noteworthy ) && (self.script_noteworthy == "run_and_die" ) )
	{
		assertex( IsDefined( self.target ), "Target not specified on runner drone" );
		spawner.target = self.target;
		actor = spawner spawn_ai( true );
		spawner.target = undefined;
		actor.origin = self.origin;
		//actor.target = self.target;
		actor.no_friendly_fire_penalty = true;
		actor thread evacuation_scene_run_actor_and_die( self.animation, self.script_parameters );
	}
	else if( IsDefined( self.script_noteworthy ) && (self.script_noteworthy == "anim_then_run" ) )
	{
		assertex( IsDefined( self.target ), "Target not specified on runner drone" );
		spawner.target = self.target;
		spawner.script_moveoverride = true;
		actor = spawner spawn_ai( true );
		actor.no_friendly_fire_penalty = true;
		spawner.script_moveoverride = undefined;
		actor.animname = self.script_parameters;
		runAnime = actor evacuation_scene_determine_run_cycle( self.animation );
		actor set_run_anim_array( runAnime, undefined, true );
		//actor notify_delay( "move", 0.1 );
		self evacuation_scene_animate_actor( actor );
		actor notify( "move" );
		actor waittill( "goal" );
		actor kill();
		//actor.target = self.target;
		//actor thread evacuation_scene_run_actor_and_die( self.animation, self.script_parameters );
	}
	else
	{
		actor = spawner spawn_ai( true );
		actor.no_friendly_fire_penalty = true;
		actor.animname = self.script_parameters;
		self thread evacuation_scene_animate_actor( actor );
	}
}

get_evacuation_scene_spawner( spawner_team )
{
	spawner = level.evacuation_scene_spawners[ spawner_team ][ level.evacuation_scene_index[ spawner_team ] ];
	
	//increment spawner index
	level.evacuation_scene_index[ spawner_team ]++;
	if( level.evacuation_scene_index[ spawner_team ] >= level.evacuation_scene_spawners[ spawner_team ].size )
		level.evacuation_scene_index[ spawner_team ] = 0;
	
	return spawner;
}

evacuation_scene_animate_actor( actor )
{
	actor endon( "death" );
	actor.allowDeath = true;
	anime = self.animation;
	//loop if it is a looping animation
	if ( isarray( level.scr_anim[ actor.animname ][ anime ] ) )
	{
		looping = true;
		self thread anim_generic_loop( actor, anime, "stop_idle" );
	}
	else
	{
		isDeathAnim = IsSubStr( anime, "death" );
		
		if( isDeathAnim )
		{
			actor.skipDeathAnim = true;
			actor.noragdoll = true;
		}
		
		if( anime == "dubai_restaurant_rolling_soldier" )
		{
			actor delayCall( 1.8, ::startragdoll );
			//actor delayCall( 1.8, ::kill );
		}
		
		if( IsSubStr( anime, "run" ) )
			self anim_single_solo_run( actor, anime );
		else
			self anim_single_solo( actor, anime );
		
		if( isDeathAnim )
			actor kill();
		
		loop_anime = anime + "_idle";
		if( IsDefined( level.scr_anim[ actor.animname ][ loop_anime ] ) )
			self thread anim_loop_solo( actor, loop_anime, "stop_idle" );
	}
}

evacuation_scene_run_actor( runAnim, actor_team )
{
	self.runAnim = level.scr_anim[ actor_team ][ runAnim ];
	self waittill( "goal" );
	self delete();
}

evacuation_scene_run_actor_and_die( deathAnim, actor_team )
{
	self waittill( "goal" );
	self.animation = deathAnim;
	self.animname = actor_team;
	org = getstruct( self.target, "targetname" );
	org evacuation_scene_animate_actor( self );
}

evacuation_scene_determine_run_cycle( anime )
{
	if( IsSubStr( anime, "civilian_run_hunched" ) )
		anime = "civilian_run_hunched_A_relative";
	else if( IsSubStr( anime, "civilian_run_upright" ) )
		anime = "civilian_run_upright_relative";
	else
		assert( "No run found that matches " + anime );
	
	self.runAnim = level.scr_anim[ self.animname ][ anime ];
	return anime;
}

evacuation_balcony_death()
{
	flag_wait( "reaction_explo01" );
	spawner = getent( "evacuation_scene_civilian_balcony_death", "targetname" );
	struct = getstruct( spawner.target, "targetname" );
	guy = spawner spawn_ai( true );
	guy.no_friendly_fire_penalty = true;
	guy.origin = struct.origin;
	guy.angles = struct.angles;
	
	//struct thread anim_generic_loop( guy, "unarmed_cowercrouch_idle", "end_idle" );
	
	//struct notify( "end_idle" );
	struct anim_generic( guy, "payback_comp_balcony_kick_enemy" );
	//wait 1.2;
	//guy.a.nodeath = true;
	guy kill( level.player.origin );
	guy startragdoll();
	//delaythread( 1.2, ::rag_doll, guy );
	//guy kill();
	//guy anim_loop_solo( "" ),
}

evacuation_corpses()
{
	
	civilian_spawner = getent( "evacuation_corpse_civilian", "targetname" );
	
	structs = getstructarray( "evacuation_corpse", "targetname" );
	foreach ( s in structs )
	{
		if( !IsDefined( s.script_parameters ) )
		{
			Assert( "No team specified for corpse at " + s.origin );
			continue;
		}
		
		guy = undefined;
		
		switch ( s.script_parameters )
		{
			case "civilian":
				guy = civilian_spawner spawn_ai();
				break;
		
			case "axis":
			case "allies":
			default:
				Assert( "Team " + s.script_parameters + " on struct at " + s.origin + " not supported for evacuation corpse." );
				break;
		}
		if( !IsDefined( guy ) )
			continue;
		guy.origin = s.origin;
		guy.angles = s.angles;
		guy SetCanDamage( false );
		
		anime = level.scr_anim[ "generic" ][ s.animation ];
		if ( IsArray( anime ) )
			anime = anime[ 0 ];
			
		guy AnimScripted( "endanim", s.origin, s.angles, anime );
		
//		guy gun_remove();
		
		guy NotSolid();
		
		if ( issubstr( s.animation, "death" ) )
			guy delayCall( 0.05, ::setAnimTime, anime, 1.0 );
	}
}

detect_turret_death()
{
	self.deathFunction = ::set_turret_death_anim;
}

set_turret_death_anim()
{
	if( self.damageweapon == "none" && self.damagetaken > 100 )
	{
		deathAnim = animscripts\death::getStrongBulletDamageDeathAnim();
		if( IsDefined( deathAnim ) )
		{
			self.deathAnim = deathAnim;
		}
	}
	
	// continue thru normal animscript either way
	return false;
}

smaw_laser_think()
{
	while( true )
	{
		level.player waittill( "weaponchange" );
		
		if( level.player GetCurrentWeapon() == "smaw_nolock_fusion" )
		{
			level.player LaserForceOn();
		}
		else
		{
			level.player LaserForceOff();
		}
	}
}

intro_heli_movies()
{
	SetSavedDvar("cg_cinematicFullScreen", "0");
	
	CinematicInGameLoop("fusion_heliscreen01");
	level.burke waittillmatch("single anim", "start_video_2");	
	CinematicInGameLoop("fusion_heliscreen02");
	level.burke waittillmatch("single anim", "start_video_3");	
	
	CinematicInGame("fusion_heliscreen03");
	
	// to avoid a few frames of black, we start 01 a bit before 03 actually finishes
	wait 2.05 - .2;
	// use this code to measure the real length
//	cinematic_length = 0;
//	while(IsCinematicPlaying())
//	{
//		cinematic_length += .05;
//		waitframe();
//	}
//	/#  IPrintLn("cinematic length: " + cinematic_length); #/
		
	CinematicInGameLoop("fusion_heliscreen01");
	wait 90;
	StopCinematicInGame();
}

evacuation_kiosk_movie()
{
	level endon("stop_evacuation_kiosk_movie");
	
	SetSavedDvar( "cg_cinematicFullScreen", "0" );
	
	playing = false;
	while(true)
	{
		should_play = level.player.origin[0] < 7200;
		
		// stupidly enough, the state of the cinematic is not saved with the game, so essentially it could suddenly stop playing
		// at any point.  This should fix the saved game case, but it will not fix the replay case (as the answer to IsCinematicPlaying()
		// is stored in the replay to ensure determinism).  So if the cinematic doesn't play after doing a replay, tough cookies.
		playing = playing && IsCinematicPlaying();
		
		if(!playing && should_play)
		{
			CinematicInGameLoop("fusion_evacuation");	
			playing = true;
		}
		else if(playing && !should_play)
		{
			StopCinematicInGame();
			playing = false;	
		}	
		
		wait .5;
	}
}

flying_attack_drone_system_init()
{	
	level.player_test_points = getstructarray( "player_test_point", "targetname" );
	level.drone_air_spaces = GetEntArray( "drone_air_space", "script_noteworthy" );

	// Initialize the array of drones, for flocking purposes.
	if( !IsDefined( level.flying_attack_drones ) )
		level.flying_attack_drones = [];
	
	/*
	// Parameterize the drones, based on the player's selected difficulty.
	while ( !isdefined( level.gameskill ) )
		wait( 0.05 );
	switch( level.gameSkill )
	{
		case 0:// easy
			break;
		case 1:// regular
			break;
		case 2:// hardened
			break;
		case 3:// veteran
			break;
	}
	*/
}

start_flying_attack_drone( sTargetname )
{
	if ( !isdefined( sTargetname ) )
		sTargetname = "flying_attack_drone";

	flying_attack_drone = maps\_vehicle::spawn_vehicle_from_targetname_and_drive( sTargetname );
	if ( isdefined( flying_attack_drone ) )
    {
		Assert( flying_attack_drone.vehicletype == "pdrone" );
		flying_attack_drone.my_debug_name = sTargetname;
		flying_attack_drone thread flying_attack_drone_logic();
    }

	return flying_attack_drone;
}

flying_attack_drone_logic( flying_attack_drone )
{
	self endon( "death" );
	
	flying_attack_drone = self;

	baseSpeed = undefined;
	if ( !isdefined( flying_attack_drone.script_airspeed ) )
		baseSpeed = 40;
	else
		baseSpeed = flying_attack_drone.script_airspeed;

	// Set up targeting stuff for the player.
	flying_attack_drone EnableAimAssist();
	Target_Set( flying_attack_drone, ( 0, 0, -80 ) );
	Target_SetJavelinOnly( flying_attack_drone, true );

	flying_attack_drone thread flying_attack_drone_damage_monitor();
	flying_attack_drone thread flying_attack_drone_death_monitor();

	flying_attack_drone SetNearGoalNotifyDist( 30 );
	flying_attack_drone Vehicle_SetSpeed( baseSpeed, baseSpeed / 4, baseSpeed / 4 );
	flying_attack_drone waittill( "near_goal" );

	flying_attack_drone thread flying_attack_drone_move_think();
}

flying_attack_drone_move_think()
{
	// Documentation: Do the following setup in Radiant:
	//	-	Create script structs with targetname = "player_test_point".
	//	-	Create info_volumes with script_noteworthy = "drone_air_space".
	//	-	Link (i.e., use the "w" shortcut key) each player_test_point to a drone_air_space.
	//	-	Using script_linkName and script_linkto, link each drone_air_space to its neighboring drone_air_spaces.
	//
	// The flying_attack_drones randomly move and flock within their current drone_air_space, and path to the
	// drone_air_space corresponding to the player's player_test_point.

	Assert( IsDefined( level.player_test_points ) );
	Assert( IsDefined( level.drone_air_spaces ) );

	self endon( "death" );
	
	// Start in the closest air space.
	self.current_air_space = getClosest( self.origin, level.drone_air_spaces );
	self update_flying_attack_drone_goal_pos();
	self waittill( "near_goal" );
	wait 2;

	// Next, follow the shortest path to the target_air_space.
	for ( ;; )
	{
		player = get_closest_player_healthy( self.origin );
		self SetLookAtEnt( player );
		playerOrigin = player.origin;
		current_player_test_point = getClosest( playerOrigin, level.player_test_points );
		target_air_space = GetEnt( current_player_test_point.target, "targetname" );
		if ( target_air_space != self.current_air_space )
		{
			next_air_space = get_next_air_space( self.current_air_space, target_air_space, level.drone_air_spaces );
			if ( IsDefined( next_air_space ) )
			{
				self.current_air_space = next_air_space;
			}
		}
		self update_flying_attack_drone_goal_pos();
		self waittill( "near_goal" );
		if ( target_air_space == self.current_air_space )
		{
			wait RandomFloatRange(0.5, 1.5);
		}
	}
}

update_flying_attack_drone_goal_pos()
{
	goal_pos = self.origin;
	// First, ensure we move into our intended airspace.
	test_pos = Spawn( "script_origin", (0, 0, 0) );
	test_pos.origin = goal_pos;
	if ( !( test_pos IsTouching( self.current_air_space ) ) )
	{
		goal_pos = get_random_point_in_air_space( self.current_air_space );
	}
	else
	{
		// We're in our intended air space.
		// Check if other drones are in the same air space.  If so, flock with them.
		num_other_drones_in_flock = 0;
		num_separation_drones = 0;
		separation_goal = (0, 0, 0);
		num_cohesion_drones = 0;
		cohesion_goal = (0, 0, 0);
		foreach (drone in level.flying_attack_drones)
		{
			if ( self != drone && IsDefined(self.current_air_space) && IsDefined(drone.current_air_space) )
			{
				if ( self.current_air_space == drone.current_air_space )
				{
					num_other_drones_in_flock ++;
					offset = drone.origin - self.origin;
					dist = length( offset );
					if (dist < 90)
					{
						// Move away from this drone.
						num_separation_drones ++;
						separation_goal -= 0.5 * (90 - dist) * offset/dist;
					}
					else if (dist > 150)
					{
						// Move toward this drone.
						num_cohesion_drones ++;
						cohesion_goal += 0.5 * (dist - 150) * offset/dist;
					}
				}
			}
		}
		if ( num_other_drones_in_flock > 0 )
		{
			if (num_separation_drones > 0)
			{
				goal_pos += separation_goal / num_separation_drones;
			}
			if (num_cohesion_drones > 0)
			{
				goal_pos += cohesion_goal / num_cohesion_drones;
			}
		}
		else
		{
			// We're alone in our intended air_space.  Do a random walk.
			goal_pos = get_random_point_in_air_space( self.current_air_space );
		}
	}
	self SetVehGoalPos( goal_pos, 1 );
	// Clean up
	test_pos Delete();
}

get_random_point_in_air_space( air_space )
{
	test_pos = Spawn( "script_origin", (0, 0, 0) );
	test_pos.origin = air_space GetPointInBounds( RandomFloatRange(-1, 1), RandomFloatRange(-1, 1), RandomFloatRange(-1, 1) );		
	while ( !( test_pos IsTouching(air_space) ) )
		test_pos.origin = air_space GetPointInBounds( RandomFloatRange(-1, 1), RandomFloatRange(-1, 1), RandomFloatRange(-1, 1) );
	return_pos = test_pos.origin;
	test_pos Delete();
	return return_pos;
}

flying_attack_drone_damage_monitor()
{
	self endon( "death" );

	self.damagetaken = 0;
	// Note:	For the moment, isTakingDamage is unused.
	//			But later, we might use it to trigger drone behaviors such as move, flee, etc.
	self.isTakingDamage = false;

	for ( ;; )
	{
		// this damage is done to self.health which isnt used to determine the vehicle's health, damageTaken is.
		self waittill( "damage", damage, attacker, direction_vec, P, type );

		if ( !isdefined( attacker ) || !isplayer( attacker ) )
			continue;

		self notify( "flying_attack_drone_damaged_by_player" );
		self thread flying_attack_drone_damage_update();
	}
}

flying_attack_drone_damage_update()
{
	self notify( "taking damage" );
	self endon( "taking damage" );
	self endon( "death" );
	self.isTakingDamage = true;
	wait( 1 );
	self.isTakingDamage = false;
}

flying_attack_drone_death_monitor()
{
	level.flying_attack_drones = array_add( level.flying_attack_drones, self );
	self waittill( "death" );
	
	level.flying_attack_drones = array_remove( level.flying_attack_drones, self );
	level notify( "flying_attack_drone_destroyed" );
}

// Get all air_spaces linked from start_space.
get_linked_air_spaces( start_space, air_spaces )
{
	linked = [];
	start_space_tokens = [];
	if( IsDefined( start_space.script_linkto ) )
	{
		start_space_tokens = StrTok( start_space.script_linkto, " " );
	}

	for ( i = 0; i < air_spaces.size; i++ )
	{
		found = false;
		if( IsDefined( air_spaces[ i ].script_linkName ) )
		{
			for ( j = 0; j < start_space_tokens.size; j++ )
			{
				if ( air_spaces[ i ].script_linkName == start_space_tokens[ j ] )
				{
					linked[ linked.size ] = air_spaces[ i ];
					found = true;
					break;
				}
			}
		}
		if( !found && IsDefined( air_spaces[i].script_linkto ) && IsDefined( start_space.script_linkName ) )
		{
			tokens = StrTok( air_spaces[i].script_linkto, " " );
			for ( j = 0; j < tokens.size; j++ )
			{
				if ( start_space.script_linkName == tokens[ j ] )
				{
					linked[ linked.size ] = air_spaces[ i ];
					break;
				}
			}
		}
	}
	
	return linked;
}

// Use A* to find the next airspace on our path to goal.
get_next_air_space( start, goal, air_spaces )
{	
	// open_set are the items we still need to consider and expand.
	open_set = [];
	open_set[0] = start;
	// closed_set are the items that aren't being considered at present, but were considered and expanded earlier in the search.
	closed_set = [];

	// air_space.g_score is the cost from start to air_space, along the best path found so far.
	foreach ( air_space in air_spaces )
	{
		air_space.g_score = 0;
	}
	
	// Every item in open_set must have an f_score.
	// x.f_score is the estimated cost of going from start to goal, via x.
	start.f_score = start.g_score + Distance( start.origin, goal.origin );

	while ( open_set.size > 0 )
	{
		// Find the item in open_set with the lowest f_score.  We call this item "current".
		current = undefined;
		min_f_score = 500000;
		foreach ( item in open_set )
		{
			if ( item.f_score < min_f_score )
			{
				current = item;
				min_f_score = item.f_score;
			}
		}
		assert( IsDefined( current ) );
		
		if ( current == goal )
		{
			// Trace the path from goal back to start.
			temp = goal;
			// See the explanation of x.came_from, below.
			while ( temp.came_from != start )
			{
				temp = temp.came_from;
			}
			// Return the first item in the path, after start.
			return temp;
		}

		// Move current from open_set to closed_set.
		open_set = array_remove( open_set, current );
		closed_set[ closed_set.size ] = current;
		// Process current's neighbors.
		linked_items = get_linked_air_spaces( current, air_spaces );
		foreach ( item in linked_items )
		{
			test_g_score = current.g_score + Distance( current.origin, item.origin );
			if ( array_contains( closed_set, item ) && test_g_score >= item.g_score )
			{
				continue;
			}
			item_in_open_set = array_contains( open_set, item );
			if ( !item_in_open_set || test_g_score < item.g_score )
			{
				// x.came_from is the immediately prior node, to get to x, along the best path found so far.
				item.came_from = current;
				item.g_score = test_g_score;
				item.f_score = item.g_score + Distance( item.origin, goal.origin );
				if ( !item_in_open_set )
				{
					open_set[ open_set.size ] = item;
				}
			}
		}
	}

	// No path exists.
	return undefined;
}
