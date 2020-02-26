//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434
//
// 	Mission: 					SPARTAN OPS: E7M1 - Abort
//										
//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** E7M1: CHANGERS ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
static short S_e7m1_changer_cnt = 																	0;

global object obj_e7m1_pup_changer_user = 													NONE;
global object obj_e7m1_pup_changer_tower = 													NONE;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_e7m1_changers_init::: Init
script dormant f_e7m1_changers_init()
	//dprint( "f_e7m1_changers_init" );

	// setup triggers
	wake( f_e7m1_changers_trigger );

	// initilaize ai team
	sleep_until( object_valid(dm_08_m2_changer_area_03b) and object_active_for_script(dm_08_m2_changer_area_03b), 1 );
	dm_08_m2_changer_area_03b->effect_group_enemy( gr_e7m1_all );

end

// === f_e7m1_changers_trigger::: Trigger
script dormant f_e7m1_changers_trigger()
	//dprint( "f_e7m1_changers_trigger" );
	
	sleep_until( LevelEventStatus("sandbox_changer_enabled"), 1 );
	wake( f_e7m1_camo_changer_detected );
	
	sleep_until( LevelEventStatus("sandbox_changer_enemy_cloaked"), 1 );
	wake( f_e7m1_camo_emitter_changed_enemy );

end

// === f_e7m1_changer_cnt::: Gets the total changer cnt
script static short f_e7m1_changer_cnt()
	S_e7m1_changer_cnt;
end

script static void f_e7m1_changers_manage( object_name obj_changer, ai ai_enemy_combat_task, real r_distance_see, real r_distance_force, real r_objcon_min, real r_objcon_max )
	dprint( "f_e7m1_changers_manage: DISABLED" );

/*
	// wait for mission to start
	sleep_until( f_spops_mission_identified(), 1 );
	
	if ( f_spops_mission_identified(DEF_E7M1_MISSION_ID) ) then

		// increment cnt
		S_e7m1_changer_cnt = S_e7m1_changer_cnt + 1;
	
		// create the changer
		object_create( obj_changer );
		sleep_until( object_valid(obj_changer), 1 );
		sleep( 1 );
	
		// wait for objcon min
		sleep_until( R_e7m1_objcon >= r_objcon_min, 1 );
		//dprint( "f_e7m1_changers_manage: OBJCON MIN" );
		
		// trigger condition
		sleep_until( 
			( (ai_task_count(ai_enemy_combat_task) > 0) or (R_e7m1_objcon >= r_objcon_max) )
			and
			( objects_distance_to_object(ai_actors(gr_e7m1_pool), obj_changer) > 0.25 )
			and(
				( objects_distance_to_object(Players(), obj_changer) <= r_distance_force )
				or
				(
					( objects_distance_to_object(Players(), obj_changer) <= r_distance_see )
					and
					objects_can_see_object( Players(), obj_changer, 30.0 )
				)
			)
		, 1 );
		
		// enable the changer
		if ( R_e7m1_objcon < r_objcon_max ) then
			//dprint( "f_e7m1_changers_manage: ACTIVATE" );
		
			device_set_power( device(obj_changer), 1.0 );
		
			// wait to shut down
			sleep_until( ((R_e7m1_objcon >= r_objcon_max) and (ai_task_count(ai_enemy_combat_task) <= 0)) or (obj_changer == NONE), 1 );
			device_set_power( device(obj_changer), 0.0 );
	
		end
	
		// deccrement cnt
		S_e7m1_changer_cnt = S_e7m1_changer_cnt - 1;
		
		//dprint( "f_e7m1_changers_manage: COMPLETE" );
	
	end
*/
	
end
script static void f_e7m1_changers_manage( object_name obj_changer, ai ai_enemy_combat_task, real r_distance_see, real r_distance_force, real r_objcon_min )
	f_e7m1_changers_manage( obj_changer, ai_enemy_combat_task, r_distance_see, r_distance_force, r_objcon_min, DEF_E7M1_AI_OBJCON_AREA_8A + 1.0 );
end

// === f_e7m1_changer_interact::: Makes an AI interact with the terminal
script static void f_e7m1_changer_interact( ai ai_user, object_name obj_changer, string_id pup_show )
local long l_pup_id = 0;
	//dprint( "f_e7m1_changer_interact" );
	
	// set the variables
	obj_e7m1_pup_changer_user = ai_get_object( ai_user );
	obj_e7m1_pup_changer_tower = obj_changer;
	
	// Play pup show
	l_pup_id = pup_play_show( pup_show );
	//dprint( "f_e7m1_changer_interact: SHOW" );
	spops_audio_music_event( 'play_mus_pve_e07m1_event_sandbox_changer_enemy_goto', "play_mus_pve_e07m1_event_sandbox_changer_enemy_goto" );
	
	// wait for show to finish or become invalid
	//dprint( "f_e7m1_changer_interact: WAIT" );
	sleep_until( (not pup_is_playing(l_pup_id)) or (ai_living_count(ai_user) <= 0) or (obj_changer == NONE) or (device_get_position(device(obj_changer)) > 0.0), 1 );
	//dprint( "f_e7m1_changer_interact: DONE" );
	if ( pup_is_playing(l_pup_id) ) then
		//dprint( "f_e7m1_changer_interact: KILL" );
		pup_stop_show( l_pup_id );
	end
	
end
script static void f_e7m1_changer_interact_grunt( ai ai_user, object_name obj_changer )
	f_e7m1_changer_interact( ai_user, obj_changer, 'pup_e7m1_changer_interact_grunt' );
end
script static void f_e7m1_changer_interact_jackal( ai ai_user, object_name obj_changer )
	f_e7m1_changer_interact( ai_user, obj_changer, 'pup_e7m1_changer_interact_jackal' );
end
script static void f_e7m1_changer_interact_elite( ai ai_user, object_name obj_changer )
	f_e7m1_changer_interact( ai_user, obj_changer, 'pup_e7m1_changer_interact_elite' );
end

// === f_e7m1_changer_interact_complete::: When the changer interaction is complete what happens
script static void f_e7m1_changer_interact_complete( object obj_user, object obj_changer )
	//dprint( "f_e7m1_changer_interact_complete" );

	if ( object_get_health(obj_user) > 0.0 ) then

		if ( obj_changer == dm_08_m2_changer_area_03b ) then
			//dprint( "f_e7m1_changer_interact_complete: dm_08_m2_changer_area_03b" );
			dm_08_m2_changer_area_03b->effect_team_enemy( TRUE );
		end
		if ( obj_changer == dm_08_m2_changer_area_04c ) then
			//dprint( "f_e7m1_changer_interact_complete: dm_08_m2_changer_area_04c" );
			dm_08_m2_changer_area_04c->effect_team_enemy( TRUE );
		end
		if ( obj_changer == dm_08_m2_changer_area_04f ) then
			//dprint( "f_e7m1_changer_interact_complete: dm_08_m2_changer_area_04f" );
			dm_08_m2_changer_area_04f->effect_team_enemy( TRUE );
		end
		if ( obj_changer == dm_08_m2_changer_area_05a ) then
			//dprint( "f_e7m1_changer_interact_complete: dm_08_m2_changer_area_05a" );
			dm_08_m2_changer_area_05a->effect_team_enemy( TRUE );
		end
		if ( obj_changer == dm_08_m2_changer_area_06a ) then
			//dprint( "f_e7m1_changer_interact_complete: dm_08_m2_changer_area_06a" );
			dm_08_m2_changer_area_06a->effect_team_enemy( TRUE );
		end
		if ( obj_changer == dm_08_m2_changer_area_07b ) then
			//dprint( "f_e7m1_changer_interact_complete: dm_08_m2_changer_area_07b" );
			dm_08_m2_changer_area_07b->effect_team_enemy( TRUE );
		end
		if ( obj_changer == dm_08_m2_changer_area_08a ) then
			//dprint( "f_e7m1_changer_interact_complete: dm_08_m2_changer_area_08a" );
			dm_08_m2_changer_area_08a->effect_team_enemy( TRUE );
		end

	end

end
