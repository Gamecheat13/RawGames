//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434
;
; Mission: 					m80_delta
;	Insertion Points:	to_hallways (or itl)
;										
//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434



// ==========================================================================================================================================================
// ==========================================================================================================================================================
// ==========================================================================================================================================================
// *** HALLWAYS: TWO ***
// ==========================================================================================================================================================
// ==========================================================================================================================================================
// ==========================================================================================================================================================

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_hallways_two_startup::: Startup
script startup f_hallways_two_startup()
	sleep_until( b_mission_started, 1 );
	//dprint( "::: f_hallways_two_startup :::" );

	// init hallways
	wake( f_hallways_two_init );

end

// === f_hallways_two_init::: Initialize
script dormant f_hallways_two_init()
	//dprint( "::: f_hallways_two_init :::" );
	
	// setup cleanup
	wake( f_hallways_two_cleanup );
	
	// wait for init condition
	sleep_until( (zoneset_current_active() == S_ZONESET_TO_AIRLOCK_TWO), 1 );
	
	// init modules
	wake( f_hallways_two_ai_init );

	// init sub modules
	wake( f_hallways_two_rescue_init );
	wake( f_hallways_two_puppeteers_init );
	wake( f_hallways_two_props_init );
	wake( f_hallways_two_doors_init );

end

// === f_hallways_two_deinit::: Deinitialize
script dormant f_hallways_two_deinit()
	//dprint( "::: f_hallways_two_deinit :::" );
	
	// deinit modules
	wake( f_hallways_two_ai_deinit );

	// deinit sub modules
	wake( f_hallways_two_rescue_deinit );
	wake( f_hallways_two_puppeteers_deinit );
	wake( f_hallways_two_props_deinit );
	wake( f_hallways_two_doors_deinit );

	// kill functions
	kill_script( f_hallways_two_init );

end

// === f_hallways_two_cleanup::: Cleanup
script dormant f_hallways_two_cleanup()
	sleep_until( zoneset_current() > S_ZONESET_AIRLOCK_TWO, 1 );
	//dprint( "::: f_hallways_two_cleanup :::" );

	// Deinitialize
	wake( f_hallways_two_deinit );

	// collect garbages
	garbage_collect_now();

end

// === f_hallways_two_trigger::: Trigger
script dormant f_hallways_two_trigger()
	sleep_until( volume_test_players(tv_hallway_two_start), 1 );
	//dprint( "::: f_hallways_two_trigger :::" );

	// trigger action
	wake( f_hallways_two_start );

	// ending	
	sleep_until( volume_test_players(tv_reached_hallway_2_end), 1 );
	f_hallways_ai_objcon_set( 260 );

end

// === f_hallways_two_start::: xxx
script dormant f_hallways_two_start()
	//dprint( "::: f_hallways_two_start :::" );

	// setup data mining
	data_mine_set_mission_segment( "m80_Hallway_Two" );

	// checkpoint
	checkpoint_no_timeout( TRUE, "f_hallways_two_start", 30.0 );
	
	// set obj con
	f_hallways_ai_objcon_set( 210 );

	// collect garbage
	garbage_collect_now();
	
end

   
     
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// HALLWAYS: TWO: PROPS
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_hallways_two_props_init::: Init
script dormant f_hallways_two_props_init()
	//dprint( "::: f_hallways_two_props_init :::" );
	
	object_create_folder( 'to_airlock_two_crates' );
	object_create_folder( 'to_airlock_two_equipment' );
	object_create_folder( 'to_airlock_two_weapons' );
	
end

// === f_hallways_two_props_deinit::: Deinit
script dormant f_hallways_two_props_deinit()
	//dprint( "::: f_hallways_two_props_deinit :::" );

	// create	
	object_destroy_folder( 'to_airlock_two_crates' );
	
	// kill functions
	kill_script( f_hallways_two_props_init );
	
end   



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// HALLWAYS: TWO: RESCUE
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_hallways_two_rescue_init::: Init
script dormant f_hallways_two_rescue_init()
	//dprint( "::: f_hallways_two_rescue_init :::" );
	
	// setup trigger
	wake( f_hallways_two_rescue_trigger );
	
end

// === f_hallways_two_rescue_deinit::: Deinit
script dormant f_hallways_two_rescue_deinit()
	//dprint( "::: f_hallways_two_rescue_deinit :::" );
	
	// kill functions
	kill_script( f_hallways_two_rescue_init );
	kill_script( f_hallways_two_rescue_trigger );
	kill_script( f_hallways_two_rescue_action );
	
end

// === f_hallways_two_rescue_trigger::: Trigger
script dormant f_hallways_two_rescue_trigger()
	//dprint( "::: f_hallways_two_rescue_trigger :::" );
	sleep_until( volume_test_players(tv_hallway_two_ai_can_take_damage), 1 );
	
	// action
	wake( f_hallways_two_rescue_action );
	
end

// === f_hallways_two_rescue_action::: Action
script dormant f_hallways_two_rescue_action()
	//dprint( "::: f_hallways_two_rescue_action :::" );

	// start
	f_objective_pause_secondary_set( 1, 'pause_secondary_1_rescue' );
	f_objective_pause_secondary_show( 1 );
	
	// complete
	sleep_until( (device_get_position(door_to_airlock_two_reward_maya) > 0.0) or (ai_living_count(sg_to_airlock_two_protect) <= 0), 1 );
	if ( ai_living_count(sg_to_airlock_two_protect) > 0 ) then
		f_objective_pause_secondary_complete( 1 );
	end
	
	// fail
	sleep_until( (ai_living_count(sg_to_airlock_two_protect) <= 0) or (zoneset_current() >= S_ZONESET_TO_LOOKOUT), 1 );
	if ( zoneset_current_active() < S_ZONESET_TO_LOOKOUT ) then
		f_objective_pause_secondary_fail( 1 );
	end

end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// HALLWAYS: TWO: PUPPETEERS
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_hallways_two_puppeteers_init::: Init
script dormant f_hallways_two_puppeteers_init()
	//dprint( "::: f_hallways_two_puppeteers_init :::" );
	
	// init sub modules
	wake( f_hallways_two_puppeteer_human_start_init );
	wake( f_hallways_two_puppeteer_human_reward_init );
	wake( f_hallways_two_puppeteer_elite_init );
	
end

// === f_hallways_two_puppeteers_deinit::: Deinit
script dormant f_hallways_two_puppeteers_deinit()
	//dprint( "::: f_hallways_two_puppeteers_deinit :::" );
	
	// init sub modules
	wake( f_hallways_two_puppeteer_human_start_deinit );
	wake( f_hallways_two_puppeteer_human_reward_deinit );
	wake( f_hallways_two_puppeteer_elite_deinit );
	
	// kill functions
	kill_script( f_hallways_two_puppeteers_init );
	
end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// HALLWAYS: TWO: PUPPETEER: HUMAN: START
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_hallways_two_puppeteer_human_start_init::: Init
script dormant f_hallways_two_puppeteer_human_start_init()
	//dprint( "::: f_hallways_two_puppeteer_human_start_init :::" );
	
	// setup trigger
	wake( f_hallways_two_puppeteer_human_start_trigger );
	
end

// === f_hallways_two_puppeteer_human_start_deinit::: Deinit
script dormant f_hallways_two_puppeteer_human_start_deinit()
	//dprint( "::: f_hallways_two_puppeteer_human_start_deinit :::" );
	
	// kill functions
	kill_script( f_hallways_two_puppeteer_human_start_init );
	kill_script( f_hallways_two_puppeteer_human_start_trigger );
	kill_script( f_hallways_two_puppeteer_human_start_action );
	
end

// === f_hallways_two_puppeteer_human_start_trigger::: Trigger
script dormant f_hallways_two_puppeteer_human_start_trigger()
	sleep_until( ai_living_count(sg_to_airlock_two_humans) > 0, 1 );
	//dprint( "::: f_hallways_two_puppeteer_human_start_trigger :::" );
	
	// kill functions
	wake( f_hallways_two_puppeteer_human_start_action );
	
end

// === f_hallways_two_puppeteer_human_start_action::: Action
script dormant f_hallways_two_puppeteer_human_start_action()
local long l_pup_id = -1;
	//dprint( "::: f_hallways_two_puppeteer_human_start_action :::" );
	
	// end
	l_pup_id = pup_play_show( pup_hallway2_humans_start );

	sleep_until( (not pup_is_playing(l_pup_id)) or ai_allegiance_broken(player, human), 1 );
	if ( pup_is_playing(l_pup_id) ) then
		pup_stop_show( l_pup_id );
	end
	
end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// HALLWAYS: TWO: PUPPETEER: HUMAN: REWARD
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
global object obj_hallway_two_reward_opener = 		NONE;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_hallways_two_puppeteer_human_reward_init::: Init
script dormant f_hallways_two_puppeteer_human_reward_init()
	//dprint( "::: f_hallways_two_puppeteer_human_reward_init :::" );
	
	// setup trigger
	wake( f_hallways_two_puppeteer_human_reward_trigger );
	
end

// === f_hallways_two_puppeteer_human_reward_deinit::: Deinit
script dormant f_hallways_two_puppeteer_human_reward_deinit()
	//dprint( "::: f_hallways_two_puppeteer_human_reward_deinit :::" );
	
	// kill functions
	kill_script( f_hallways_two_puppeteer_human_reward_init );
	kill_script( f_hallways_two_puppeteer_human_reward_trigger );
	kill_script( f_hallways_two_puppeteer_human_reward_action );
	kill_script( f_hallways_two_puppeteer_human_reward_actor );
	kill_script( f_hallways_two_puppeteer_human_reward_blip );
	
end

// === f_hallways_two_puppeteer_human_reward_trigger::: Trigger
script dormant f_hallways_two_puppeteer_human_reward_trigger()
	sleep_until( f_ai_is_defeated(sg_to_airlock_two_enemies), 1 );
	//dprint( "::: f_hallways_two_puppeteer_human_reward_trigger :::" );
	
	sleep_until( f_ai_is_defeated(sg_to_airlock_two_initial), 1 );
	
	// kill functions
	wake( f_hallways_two_puppeteer_human_reward_action );

end

// === f_hallways_two_puppeteer_human_reward_actor::: Manages an actor who gives rewards
script static void f_hallways_two_puppeteer_human_reward_actor( ai ai_actor, string_id sid_pup )
local long l_pup_id = -1;
local object obj_actor = ai_get_object( ai_actor );
	//dprint( "::: f_hallways_two_puppeteer_human_reward_actor :::" );

	if ( ai_living_count(ai_actor) > 0 ) then

		unit_set_maximum_vitality( ai_actor, object_get_maximum_vitality(ai_actor, FALSE) * 0.375, 0.0 );
		unit_set_current_vitality( ai_actor, object_get_maximum_vitality(ai_actor, FALSE) * 2.125, 0.0 );
		inspect( object_get_maximum_vitality(ai_actor, FALSE) );

		repeat
	
			// wait for it to be ok for the show to start
			sleep_until( (not f_ai_sees_enemy(ai_actor) and (not ai_allegiance_broken(player, human)) and (object_get_recent_body_damage(ai_actor) <= 0.0)) or (ai_living_count(ai_actor) <= 0), 1 );
	
			if ( ai_living_count(sg_to_airlock_two_protect) > 0 ) then
	
				// play the puppet show
				l_pup_id = pup_play_show( sid_pup );
	
				// wait for a need to shut down the show
				sleep_until( (ai_living_count(ai_actor) <= 0) or f_ai_sees_enemy(sg_to_airlock_two_protect) or ai_allegiance_broken(player, human), 1 );
	
				// check if it needs to kill the show
				if ( pup_is_playing(l_pup_id) ) then
					pup_stop_show( l_pup_id );
				end
	
			end

			// if this is the reward giver, reset
			if ( obj_hallway_two_reward_opener == obj_actor ) then
				obj_hallway_two_reward_opener = NONE;
			end
		
		until ( ai_living_count(ai_actor) <= 0, 1 );

	end

end

// === f_hallways_two_puppeteer_human_reward_action::: Action
script dormant f_hallways_two_puppeteer_human_reward_action()
local boolean b_first_time = FALSE;
	//dprint( "::: f_hallways_two_puppeteer_human_reward_action :::" );

	if ( ai_living_count(sg_to_airlock_two_protect) > 0 ) then

		// setup actors to perform rewards sequence
		thread( f_hallways_two_puppeteer_human_reward_actor(humans_to_airlock_two_scene1.marine,'pup_hallway2_humans_reward_marine') );
		thread( f_hallways_two_puppeteer_human_reward_actor(humans_to_airlock_two_scene2.male1,'pup_hallway2_humans_reward_male1') );
		thread( f_hallways_two_puppeteer_human_reward_actor(humans_to_airlock_two_scene3.male2,'pup_hallway2_humans_reward_male2') );
		thread( f_hallways_two_puppeteer_human_reward_actor(humans_to_airlock_two_scene2.female1,'pup_hallway2_humans_reward_female1') );
		thread( f_hallways_two_puppeteer_human_reward_actor(humans_to_airlock_two_scene3.female2,'pup_hallway2_humans_reward_female2') );
		
		repeat
	
			// wait for conidition to set a target
			sleep_until( (volume_test_players(tv_hallways_two_reward_start) and (not f_ai_sees_enemy(sg_to_airlock_two_protect)) and (not ai_allegiance_broken(player, human)) and (object_get_health(obj_hallway_two_reward_opener) <= 0)) or (device_get_position(door_to_airlock_two_reward_maya) > 0.0) or (ai_living_count(sg_to_airlock_two_protect) <= 0), 1 );
		
			if ( (device_get_position(door_to_airlock_two_reward_maya) <= 0.0) and (ai_living_count(sg_to_airlock_two_protect) > 0) ) then
				obj_hallway_two_reward_opener = list_get( ai_actors(sg_to_airlock_two_protect), random_range(0,ai_living_count(sg_to_airlock_two_protect) - 1) );
				
				// rescue dialog
				if ( not b_first_time ) then
					b_first_time = TRUE;
					music_set_state( 'Play_mus_m80_v25_hallway2_humans_end_state' );
					wake( f_dialog_airlock_hallways_2_rescue );
				end
			end
		
		until( (device_get_position(door_to_airlock_two_reward_maya) > 0.0) or (ai_living_count(sg_to_airlock_two_protect) <= 0), 1 );
	
		// shut off opener
		obj_hallway_two_reward_opener = NONE;
		
		// blip blip rewards
		if ( (ai_living_count(sg_to_airlock_two_protect) > 0) and (device_get_position(door_to_airlock_two_reward_maya) > 0.0) ) then
			wake( f_hallways_two_puppeteer_human_reward_blip );
		end

	end
	
end

// === f_hallways_two_puppeteer_human_reward_speaker_male::: Action
script static boolean f_hallways_two_puppeteer_human_reward_speaker_male()
	( obj_hallway_two_reward_opener == ai_get_object(humans_to_airlock_two_scene1.marine) ) or ( obj_hallway_two_reward_opener == ai_get_object(humans_to_airlock_two_scene2.male1) ) or ( obj_hallway_two_reward_opener == ai_get_object(humans_to_airlock_two_scene3.male2) );
end

script static ai f_hallways_two_human_reward_get_male_nearest()
local ai ai_male = NONE;
local real r_distance = 0.0;

	if ( (unit_get_health(humans_to_airlock_two_scene2.male1) > 0.0) and ((ai_male == NONE) or (objects_distance_to_object(Players(), ai_get_object(humans_to_airlock_two_scene2.male1)) < r_distance)) ) then
		r_distance = objects_distance_to_object( Players(), ai_get_object(humans_to_airlock_two_scene2.male1) );
		ai_male = humans_to_airlock_two_scene2.male1;
	end
	if ( (unit_get_health(humans_to_airlock_two_scene3.male2) > 0.0) and ((ai_male == NONE) or (objects_distance_to_object(Players(), ai_get_object(humans_to_airlock_two_scene3.male2)) < r_distance)) ) then
		r_distance = objects_distance_to_object( Players(), ai_get_object(humans_to_airlock_two_scene3.male2) );
		ai_male = humans_to_airlock_two_scene3.male2;
	end
	if ( (unit_get_health(humans_to_airlock_two_scene1.marine) > 0.0) and ((ai_male == NONE) or (objects_distance_to_object(Players(), ai_get_object(humans_to_airlock_two_scene1.marine)) < r_distance)) ) then
		r_distance = objects_distance_to_object( Players(), ai_get_object(humans_to_airlock_two_scene1.marine) );
		ai_male = humans_to_airlock_two_scene1.marine;
	end

	ai_male;
end

script static ai f_hallways_two_human_reward_get_female_nearest()
local ai ai_female = NONE;
local real r_distance = 0;

	if ( (unit_get_health(humans_to_airlock_two_scene2.female1) > 0.0) and ((ai_female == NONE) or (objects_distance_to_object(Players(), ai_get_object(humans_to_airlock_two_scene2.female1)) < r_distance)) ) then
		r_distance = objects_distance_to_object( Players(), ai_get_object(humans_to_airlock_two_scene2.female1) );
		ai_female = humans_to_airlock_two_scene2.female1;
	end
	if ( (unit_get_health(humans_to_airlock_two_scene3.female2) > 0.0) and ((ai_female == NONE) or (objects_distance_to_object(Players(), ai_get_object(humans_to_airlock_two_scene3.female2)) < r_distance)) ) then
		r_distance = objects_distance_to_object( Players(), ai_get_object(humans_to_airlock_two_scene3.female2) );
		ai_female = humans_to_airlock_two_scene3.female2;
	end

	ai_female;
end

// === f_hallways_two_puppeteer_human_reward_blip::: Blips the reward
script dormant f_hallways_two_puppeteer_human_reward_blip()
	//dprint( "::: f_hallways_two_puppeteer_human_reward_blip :::" );

	sleep_until( door_to_airlock_two_reward_maya->position_open_check(), 1 );

	// blip the reward
	if ( not f_ability_check_players_all('objects\equipment\storm_auto_turret\storm_auto_turret_pve.equipment') ) then
		f_hallways_two_reward_blip( TRUE );

		// wait for players to be in the room
		sleep_until( volume_test_players(tv_player_left_reward_room), 1 );
		
		sleep_until( volume_test_players(tv_airlock_two_entered) or (f_ability_player_cnt('objects\equipment\storm_auto_turret\storm_auto_turret_pve.equipment') >= 2) or (f_ability_player_cnt('objects\equipment\storm_auto_turret\storm_auto_turret_pve.equipment') >= player_count()), 1 );
		checkpoint_no_timeout( TRUE, "f_hallways_two_puppeteer_human_reward_blip" );	
		
		// unblip the objective
		sleep_until( (f_ability_player_cnt('objects\equipment\storm_auto_turret\storm_auto_turret_pve.equipment') >= 2) or (f_ability_player_cnt('objects\equipment\storm_auto_turret\storm_auto_turret_pve.equipment') >= player_count()), 1);
		f_hallways_two_reward_blip( FALSE );
/*
*/	
	end

end

// === f_hallways_two_puppeteer_human_reward_speaker_male::: Action
script static void f_hallways_two_reward_blip( boolean b_blip )
static long l_thread = 0;

	if ( b_blip and (not isthreadvalid(l_thread)) ) then
		l_thread = f_blip_auto_flag_equipment( flg_objective_hallways_two_reward, "PAT", 'objects\equipment\storm_auto_turret\storm_auto_turret_pve.equipment', FALSE );
	elseif ( not b_blip ) then
		kill_thread( l_thread );
	end
	
end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// HALLWAYS: TWO: PUPPETEER: ELITE
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_hallways_two_puppeteer_elite_init::: Init
script dormant f_hallways_two_puppeteer_elite_init()
	//dprint( "::: f_hallways_two_puppeteer_elite_init :::" );
	
	// setup trigger
	wake( f_hallways_two_puppeteer_elite_trigger );
	
end

// === f_hallways_two_puppeteer_elite_deinit::: Deinit
script dormant f_hallways_two_puppeteer_elite_deinit()
	//dprint( "::: f_hallways_two_puppeteer_elite_deinit :::" );
	
	// kill functions
	kill_script( f_hallways_two_puppeteer_elite_init );
	kill_script( f_hallways_two_puppeteer_elite_trigger );
	kill_script( f_hallways_two_puppeteer_elite_action );
	
end

// === f_hallways_two_puppeteer_elite_trigger::: Trigger
script dormant f_hallways_two_puppeteer_elite_trigger()
	sleep_until( ai_living_count(sq_hallway_2_execute_elite) > 0, 1 );
	//dprint( "::: f_hallways_two_puppeteer_elite_trigger :::" );
	
	// kill functions
	wake( f_hallways_two_puppeteer_elite_action );
	
end

// === f_hallways_two_puppeteer_elite_action::: Action
script dormant f_hallways_two_puppeteer_elite_action()
local long l_pup_id = -1;
	//dprint( "::: f_hallways_two_puppeteer_elite_action :::" );
	
	// action
	l_pup_id = pup_play_show( pup_hallway2_elite );
	
	// wait for show to end or need to be interrupted
	sleep_until( not pup_is_playing(l_pup_id) or volume_test_players(tv_wake_execute_enemy) or (ai_task_count(obj_to_airlock_two.gate_saw_player) > 0) or (object_get_shield(sq_hallway_2_execute_elite) < 1.0), 1 );
	
	// re-setup the elite
	if( ai_living_count(sq_hallway_2_execute_elite) > 0 ) then
		ai_set_objective( sq_hallway_2_execute_elite, obj_to_airlock_two );
		ai_disregard( ai_get_object(sq_hallway_2_execute_elite), FALSE );
		
		// delay reaction
		if ( ai_task_count(obj_to_airlock_two.gate_saw_player ) > 0 ) then
			sleep_s( 1.0 );
		end
	end
	
	// shut down the show
	if ( pup_is_playing(l_pup_id) ) then
		pup_stop_show( l_pup_id );
	end
	
end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// HALLWAYS: TWO: DOORS
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_hallways_two_doors_init::: Init
script dormant f_hallways_two_doors_init()
	//dprint( "::: f_hallways_two_doors_init :::" );
	
	// init sub modules
	wake( f_hallways_two_door_broken_init );
	wake( f_hallways_two_door_reward_init );
	
end

// === f_hallways_two_doors_deinit::: Deinit
script dormant f_hallways_two_doors_deinit()
	//dprint( "::: f_hallways_two_doors_deinit :::" );

	// deinit sub modules
	wake( f_hallways_two_door_broken_deinit );
	wake( f_hallways_two_door_reward_deinit );
	
	// kill functions
	kill_script( f_hallways_two_doors_init );
	
end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// HALLWAYS: TWO: DOORS: BROKEN
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------

// === f_hallways_two_door_broken_init::: Init
script dormant f_hallways_two_door_broken_init()
	sleep_until( object_valid(door_to_airlock_two_scene_maya) and object_active_for_script(door_to_airlock_two_scene_maya), 1 );
	//dprint( "::: f_hallways_two_door_broken_init :::" );

	// setup door
	door_to_airlock_two_scene_maya->open_instant();
	door_to_airlock_two_scene_maya->blend_setup( 2.0 );
	door_to_airlock_two_scene_maya->speed_setup( 4.5, 15.0 );
	door_to_airlock_two_scene_maya->jitter_setup( TRUE, 0.9875, 1.0, 0.900, 0.950, 0.375, 0.975 );
	
end

// === f_hallways_two_door_broken_deinit::: Deinit
script dormant f_hallways_two_door_broken_deinit()
	//dprint( "::: f_hallways_two_door_broken_deinit :::" );
	
	// kill functions
	kill_script( f_hallways_two_door_broken_init );
	
end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// HALLWAYS: TWO: DOORS: REWARD
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------

// === f_hallways_two_door_reward_init::: Init
script dormant f_hallways_two_door_reward_init()
	sleep_until( object_valid(door_to_airlock_two_reward_maya), 1 );
	//dprint( "::: f_hallways_two_door_reward_init :::" );
	
end

// === f_hallways_two_door_reward_deinit::: Deinit
script dormant f_hallways_two_door_reward_deinit()
	//dprint( "::: f_hallways_two_door_reward_deinit :::" );
	
	// kill functions
	kill_script( f_hallways_two_door_reward_init );
	kill_script( f_hallways_two_door_reward_action );
	
end

// === f_hallways_two_door_reward_action::: Action
script dormant f_hallways_two_door_reward_action()
	sleep_until( object_valid(door_to_airlock_two_reward_maya) and object_active_for_script(door_to_airlock_two_reward_maya), 1 );
	//dprint( "::: f_hallways_two_door_reward_action :::" );

	// open the door
	door_to_airlock_two_reward_maya->open();
	
end
