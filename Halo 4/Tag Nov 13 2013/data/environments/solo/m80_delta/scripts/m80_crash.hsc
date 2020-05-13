//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434
;
; Mission: 					m80_delta
;	Insertion Points:	crash (icr)
;										
//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434

// ==========================================================================================================================================================
// ==========================================================================================================================================================
// ==========================================================================================================================================================
// *** CRASH ***
// ==========================================================================================================================================================
// ==========================================================================================================================================================
// ==========================================================================================================================================================

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
global object P_crash_player_puppet = NONE;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_crash_startup::: Startup
script startup f_crash_startup()
	sleep_until( b_mission_started, 1 );
	//dprint( "::: f_crash_startup :::" );

	// init crash
	wake( f_crash_init );

end

// === f_crash_init::: Initialize
script dormant f_crash_init()
	//dprint( "::: f_crash_init :::" );

	// setup cleanup
	wake( f_crash_cleanup );
	
	// wait for init condition
	sleep_until( zoneset_current_active() >= S_ZONESET_CRASH, 1 );
	
	// init modules
	wake( f_crash_narrative_init );
	//wake( f_crash_audio_init );
	wake( f_crash_fx_init );
	
	// init sub modules
	wake( f_crash_props_init );
	wake( f_crash_puppeteers_init );
	wake( f_crash_doors_init );
	wake( f_crash_thing_init );
	wake( f_crash_dead_init );
	
	// setup trigger
	wake( f_crash_trigger );

end

/*
// Start loading dynamic resources for horseshoe immediately.
script dormant f_stream_crash_transition()
	zoneset_prepare(S_ZONESET_CRASH_TRANSITION, true);
	sleep_until(not PreparingToSwitchZoneSet(), 1);

	// Do nothing if we're already loading another zoneset, otherwise commit the load so we can save again.
	if (zoneset_current() == S_ZONESET_CRASH_TRANSITION) then
		zoneset_load(S_ZONESET_CRASH_TRANSITION, false);
	end
end
*/

// === f_crash_deinit::: Deinitialize
script dormant f_crash_deinit()
	//dprint( "::: f_crash_deinit :::" );
	
	// init modules
	wake( f_crash_narrative_deinit );
	//wake( f_crash_audio_deinit );
	wake( f_crash_fx_deinit );
	
	// deinit sub modules`
	wake( f_crash_props_deinit );
	wake( f_crash_puppeteers_deinit );
	wake( f_crash_doors_deinit );
	wake( f_crash_thing_deinit );
	wake( f_crash_dead_deinit );

	// kill functions
	kill_script( f_crash_init );
	kill_script( f_crash_trigger );
	kill_script( f_crash_start );
	//kill_script( f_crash_action );

end

// === f_crash_cleanup::: Cleanup
script dormant f_crash_cleanup()
	sleep_until( zoneset_current_active() > S_ZONESET_TO_HORSESHOE, 1 );
	//dprint( "::: f_crash_cleanup :::" );

	// Deinitialize
	wake( f_crash_deinit );

	// collect garbages
	garbage_collect_now();

end

// === f_crash_trigger::: Trigger
script dormant f_crash_trigger()
	//dprint( "::: f_crash_trigger :::" );

	// start
	wake( f_crash_start );

	// start objective
	sleep_until( dialog_id_played_check(L_dlg_crash_landing) or B_dlig_crash_landing_objective_set, 1 );
	//f_objective_set_timer_reminder( DEF_R_OBJECTIVE_CRASH_EXIT(), TRUE, FALSE, TRUE, TRUE );
	f_objective_set( DEF_R_OBJECTIVE_CRASH_EXIT(), TRUE, FALSE, TRUE, TRUE );

	sleep_until( dialog_id_played_check(L_dlg_crash_landing), 1 );
	f_objective_blip( DEF_R_OBJECTIVE_CRASH_EXIT(), TRUE );
	// action
	//wake( f_crash_action );

end

// === f_crash_start::: Action
script dormant f_crash_start()
	//dprint( "::: f_crash_start :::" );

	// start data mining
	data_mine_set_mission_segment( "m80_Crash" );

	// prepare and load the transition zoneset
	if ( zoneset_current() == S_ZONESET_CRASH ) then
		zoneset_prepare_and_load( S_ZONESET_CRASH_TRANSITION );
	end

end
/*
// === f_crash_action::: Action
script dormant f_crash_action()
	//dprint( "::: f_crash_action :::" );
	
	// add objective list item
	wake( f_objective_list_crash_start );

end
*/



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// CRASH: PROPS
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_crash_props_init::: Init
script dormant f_crash_props_init()
	//dprint( "::: f_crash_props_init :::" );

	// create props
	// crash
	object_create_folder( crash_crates );
	object_create_folder( crash_weapons );
	//object_create_folder( crash_equipment );

	// to_horseshoe
	sleep_until( zoneset_current_active() >= S_ZONESET_CRASH_TRANSITION, 1 );
	//if ( editor_mode() ) then
	//	sleep( 1 );
	//end

	object_create_folder( to_horseshoe_crates );
	object_create_folder( to_horseshoe_weapons );
	object_create_folder( to_horseshoe_equipment );
	
	// faked EXPLOSION
	if ( zoneset_current() < S_ZONESET_TO_HORSESHOE ) then
//		dprint( "::: f_crash_props_init: EXPLOSION :::" );
		damage_new( 'objects\weapons\pistol\storm_sticky_detonator\projectiles\damage_effects\storm_sticky_detonator_grenade_explosion_pve.damage_effect', flg_crash_pup_sticky_target_fake_a );
		damage_new( 'objects\weapons\pistol\storm_sticky_detonator\projectiles\damage_effects\storm_sticky_detonator_grenade_explosion_pve.damage_effect', flg_crash_pup_sticky_target_fake_b );
	end
	
end

// === f_crash_props_deinit::: Deinit
script dormant f_crash_props_deinit()
	//dprint( "::: f_crash_props_deinit :::" );
	
	object_destroy_folder( crash_crates );
	object_destroy_folder( to_horseshoe_crates );
	
	// kill functions
	kill_script( f_crash_props_init );
	
end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// CRASH: DEAD
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_crash_dead_init::: Init
script dormant f_crash_dead_init()
	sleep_until( zoneset_current_active() >= S_ZONESET_CRASH_TRANSITION, 1 );
	local long l_pup_id = -1;
	dprint( "::: f_crash_dead_init :::" );

	// editor sleeps a little bit
	//if ( editor_mode() ) then
	//	sleep( 1 );
	//end
	
	// dead covenant
	ai_place( sq_crash_dead );

	// dead marines
	//object_create( bpd_crash_dead_01 );
	l_pup_id = pup_play_show( 'pup_crash_dead_01' ); 
	sleep_until( not pup_is_playing(l_pup_id), 1 );
	sleep( 1 );

	//object_create( bpd_crash_dead_02 );
	l_pup_id = pup_play_show( 'pup_crash_dead_02' ); 
	sleep_until( not pup_is_playing(l_pup_id), 1 );
	sleep( 1 );

	//object_create( bpd_crash_dead_03 );
	l_pup_id = pup_play_show( 'pup_crash_dead_03' ); 
//	sleep_until( not pup_is_playing(l_pup_id), 1 );

end

// === f_crash_dead_deinit::: Deinit
script dormant f_crash_dead_deinit()
	//dprint( "::: f_crash_dead_deinit :::" );

	object_destroy( bpd_crash_dead_01 );
	object_destroy( bpd_crash_dead_02 );
	object_destroy( bpd_crash_dead_03 );
	
	// kill functions
	kill_script( f_crash_dead_init );
	
end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// CRASH: PUPPETEER
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------

// === f_crash_puppeteers_init::: Init
script dormant f_crash_puppeteers_init()
	//dprint( "::: f_crash_puppeteers_init :::" );
	
	// init sub modules
	//wake( f_crash_puppeteer_start_init );
	wake( f_crash_puppeteer_sticky_init );
	
end

// === f_crash_puppeteers_deinit::: Deinit
script dormant f_crash_puppeteers_deinit()
	//dprint( "::: f_crash_puppeteers_deinit :::" );
	
	// kill functions
	kill_script( f_crash_puppeteers_init );
	
	// deinit sub modules
	wake( f_crash_puppeteer_start_deinit );
	wake( f_crash_puppeteer_sticky_deinit );
	
end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// CRASH: PUPPETEER: START
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_crash_puppeteer_start_init::: Init
//script dormant f_crash_puppeteer_start_init()
	//dprint( "::: f_crash_puppeteer_start_init :::" );
	
	// XXX 
	
//end

// === f_crash_puppeteer_start_deinit::: Deinit
script dormant f_crash_puppeteer_start_deinit()
	//dprint( "::: f_crash_puppeteer_start_deinit :::" );
	
	// kill functions
	//kill_script( f_crash_puppeteer_start_init );
	kill_script( f_crash_puppeteer_start_action );
	kill_script( f_crash_puppeteer_start_enter );
	kill_script( f_crash_puppeteer_start_exit );
	
end

// === f_crash_puppeteer_start_action::: Action
script static void f_crash_puppeteer_start_action()
local long l_pup_id = -1;
	//dprint( "::: f_crash_puppeteer_start_action :::" );

	// hide hud elements
	chud_show_crosshair( FALSE );
	chud_show_grenades( FALSE );
	chud_show_shield( FALSE );
	chud_show_motion_sensor( FALSE );

	hud_rampancy_players_set( 0.25 );
	p_crash_player_puppet = player_get_first_valid();
	l_pup_id = pup_play_show( "pup_crash_chief_get_up" );
	sleep_until( not pup_is_playing(l_pup_id), 1 );

	// restore the hud
	hud_play_global_animtion( screen_fade_in );
	hud_stop_global_animtion( screen_fade_in );

	// restore hud elements
	chud_show_crosshair( TRUE );
	chud_show_grenades( TRUE );
	chud_show_shield( TRUE );
	chud_show_motion_sensor( TRUE );

end

global real s_crash_pup_start_fade_time = 12.5; 

// === f_crash_puppeteer_start_enter::: Puppeteer Sub-Action
script static void f_crash_puppeteer_start_enter()
	//dprint( "::: f_crash_puppeteer_start_enter :::" );

	//hud_play_global_animtion( screen_fade_out );
	fade_out( 0, 0, 0, 0 );
	cinematic_show_letterbox_immediate( TRUE );
	effect_new_on_object_marker( 'objects\temp\jsnyder\screen_shake_test_effect\screen_shake_test.effect', player_get_first_valid(), "" );
	fade_in( 0, 0, 0, seconds_to_frames(s_crash_pup_start_fade_time) ); 
	hud_rampancy_players_scale( 0.75, s_crash_pup_start_fade_time );
	//hud_stop_global_animtion( screen_fade_out );

end

// === f_crash_puppeteer_start_title::: Puppeteer Sub-Action
script static void f_crash_puppeteer_start_title()
	//dprint( "::: f_crash_puppeteer_start_title :::" );

	cinematic_set_title( chapter_title_crash );

end

// === f_crash_puppeteer_start_exit::: Puppeteer Sub-Action
script static void f_crash_puppeteer_start_exit()
	//dprint( "::: f_crash_puppeteer_start_exit :::" );

	// remove letterbos	
	sleep_s( 0.25 );
	object_destroy( scn_crash_ar );
	cinematic_show_letterbox( FALSE );
	sleep_s( 0.5 );

end
/*
script static void f_chapter_title_display( cutscene_title ct_title )
	hud_play_global_animtion( screen_fade_out );
	sleep_s( 0.5 );
	cinematic_show_letterbox( TRUE );
	hud_stop_global_animtion( screen_fade_out );
	sleep_s( 1.5 );
	cinematic_set_title( ct_title );
	sleep_s( 7.0 );
	cinematic_show_letterbox( FALSE );
	sleep_s( 0.5 );
	hud_play_global_animtion( screen_fade_in );
	hud_stop_global_animtion( screen_fade_in );
	sleep_s( 1.0 );
end

*/

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// CRASH: PUPPETEER: STICKY
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_crash_puppeteer_sticky_init::: Init
script dormant f_crash_puppeteer_sticky_init()
	//dprint( "::: f_crash_puppeteer_sticky_init :::" );
	
	// setup trigger
	wake( f_crash_puppeteer_sticky_trigger );
	
end

// === f_crash_puppeteer_sticky_deinit::: Deinit
script dormant f_crash_puppeteer_sticky_deinit()
	//dprint( "::: f_crash_puppeteer_sticky_deinit :::" );
	
	// kill functions
	kill_script( f_crash_puppeteer_sticky_init );
	kill_script( f_crash_puppeteer_sticky_trigger );
	//kill_script( f_crash_puppeteer_sticky_spawn );
	kill_script( f_crash_puppeteer_sticky_action );

end

script dormant f_crash_puppeteer_sticky_test()
	door_crash_exit->speed_open( 3.0 );
	wake( f_crash_puppeteer_sticky_trigger );
	door_crash_exit->open();
end

// === f_crash_puppeteer_sticky_trigger::: Trigger
script dormant f_crash_puppeteer_sticky_trigger()
	//dprint( "::: f_crash_puppeteer_sticky_trigger :::" );

	// aciton
	//sleep_until( (zoneset_current_active() >= S_ZONESET_CRASH_TRANSITION) and object_valid(door_crash_exit) and (device_get_position(door_crash_exit) > 0.0), 1 );
	sleep_until( object_valid(door_crash_exit) and (device_get_position(door_crash_exit) > 0.0), 1 );
	wake( f_crash_puppeteer_sticky_action );

end
/*
// === f_crash_puppeteer_sticky_action::: Spawn
script dormant f_crash_puppeteer_sticky_spawn()
	//dprint( "::: f_crash_puppeteer_sticky_spawn :::" );

	// set allegiance
	//ai_allegiance( player, human );
	
	// place
	f_ai_spawn_delay_wait( TRUE, -1 );
	ai_place( sg_crash_sticky );
		object_cannot_die( ai_get_object(sq_crash_sticky_human_01), TRUE );
		object_cannot_die( ai_get_object(sq_crash_sticky_enemy_01), TRUE );

end
*/
// === f_crash_puppeteer_sticky_action::: Action
global real R_crash_puppeteer_door_pos = 				0.7;
//global real R_crash_puppeteer_recent_damage = 	0.0375;
//global real R_crash_puppeteer_sticky_marine_health = -1.0;
script dormant f_crash_puppeteer_sticky_action()
local long l_pup_id = -1;
	//dprint( "::: f_crash_puppeteer_sticky_action :::" );

	l_pup_id = pup_play_show( 'pup_crash_sticky' );
	
	sleep_until( zoneset_current_active() >= S_ZONESET_CRASH_TRANSITION, 1 );
	
	// place
	ai_place( sq_crash_sticky_enemy_01 );
		ai_set_blind( sq_crash_sticky_enemy_01, FALSE );
		ai_set_deaf( sq_crash_sticky_enemy_01, FALSE );
		ai_magically_see( sq_crash_sticky_enemy_01, sq_crash_sticky_human_01 );

	sleep_until( not pup_is_playing(l_pup_id), 1 );

	object_cannot_die( ai_get_object(sq_crash_sticky_human_01.01), FALSE );
	object_cannot_die( ai_get_object(sq_crash_sticky_enemy_01.01), FALSE );
	object_cannot_die( ai_get_object(sq_crash_sticky_enemy_01.02), FALSE );
	
end

script static void f_crash_puppeteer_sticky_marined_damage_set()
	//dprint( "TESTING" );
	object_can_take_damage( ai_get_object(sq_crash_sticky_human_01.01) );
end

script static boolean f_crash_puppeteer_sticky_go()
	( zoneset_current_active() >= S_ZONESET_CRASH_TRANSITION ) and ( device_get_position(door_crash_exit) >= (R_crash_puppeteer_door_pos * 0.25) );
end

script static boolean f_crash_puppeteer_sticky_marined_damage_check()
static real r_last_dmg = unit_get_health( sq_crash_sticky_human_01.01 );
static short s_dmg_cnt = 0;

	if ( r_last_dmg != unit_get_health(sq_crash_sticky_human_01.01) ) then
		r_last_dmg = unit_get_health( sq_crash_sticky_human_01.01 );
		s_dmg_cnt = s_dmg_cnt + 1;
	end
	
	// return
	s_dmg_cnt >= 3;

end

script command_script cs_crash_puppeteer_sticky_attack()
	cs_shoot( ai_current_actor, TRUE, ai_get_object(sq_crash_sticky_human_01.01) );
end

// === f_crash_puppeteer_shoot::: Action
script static void f_crash_puppeteer_shoot()
	//dprint( "::: f_crash_puppeteer_shoot :::" );
	
	effect_new_on_object_marker( 'objects\weapons\pistol\storm_sticky_detonator\fx\sgl_firing.effect',unit_get_primary_weapon(sq_crash_sticky_human_01.01),'primary_trigger' );
	
	// setup explosion
	thread( f_crash_puppeteer_shoot_explosion() );
	
end

// === f_crash_puppeteer_explosion::: Action
script static void f_crash_puppeteer_shoot_explosion()
local long l_timer = timer_stamp( 2.0 );
	dprint( "::: f_crash_puppeteer_explosion :::" );

	sleep_until( timer_expired(l_timer) or volume_test_players(tv_crasy_sticky_force) or f_ai_is_defeated(sq_crash_sticky_enemy_01), 1 );
	
	// EXPLOSION!!!
	sound_impulse_start( 'sound\storm\weapons\sticky_detonator\projectile\sticky_detonator_proj_explosion.sound', ai_get_object(sq_crash_sticky_enemy_01), 1 );
	effect_new( 'objects\weapons\pistol\storm_sticky_detonator\fx\sgl_airborne_super_detonation.effect', flg_crash_pup_sticky_target );
	damage_new( 'objects\weapons\pistol\storm_sticky_detonator\projectiles\damage_effects\storm_sticky_detonator_grenade_explosion_pve.damage_effect', flg_crash_pup_sticky_target );
	
	// kill the ai
	sleep_s( 0.25 );
	sleep( 1 );
	ai_kill_no_statistics( sq_crash_sticky_enemy_01 );
	
end

// COMMAND_SCRIPTS ------------------------------------------------------------------------------------------------------------------------------------------
static long L_crash_marine_thread = 0;
script command_script cs_crash_marine_01_alive()

	// swap out the sticky det
	if ( unit_has_weapon_readied(ai_current_actor, 'objects\weapons\pistol\storm_sticky_detonator\storm_sticky_detonator_pve.weapon') ) then
		ai_swap_weapons( ai_current_actor );
		sleep_until( not unit_has_weapon_readied(ai_current_actor, 'objects\weapons\pistol\storm_sticky_detonator\storm_sticky_detonator_pve.weapon'), 1 );
	end

	if ( not isthreadvalid(L_crash_marine_thread) ) then
		L_crash_marine_thread = f_cs_atrium_marine_shared( ai_current_actor, ps_crash_sticky_marine_patrol.p0, ps_crash_sticky_marine_patrol.p1, ps_crash_sticky_marine_patrol.p2, ps_crash_sticky_marine_patrol.p3 );
	end

end

script command_script cs_crash_marine_01_alive_help()

	//if ( isthreadvalid(L_crash_marine_thread) ) then
	//	sleep( 5 );
	//	kill_thread( L_crash_marine_thread );
	//end

	// swap out the sticky det
	if ( unit_has_weapon_readied(ai_current_actor, 'objects\weapons\pistol\storm_sticky_detonator\storm_sticky_detonator_pve.weapon') ) then
		ai_swap_weapons( ai_current_actor );
		sleep_until( not unit_has_weapon_readied(ai_current_actor, 'objects\weapons\pistol\storm_sticky_detonator\storm_sticky_detonator_pve.weapon'), 1 );
	end

end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// CRASH: THING
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------

// === f_crash_thing_init::: Init
script dormant f_crash_thing_init()
	//dprint( "::: f_crash_thing_init :::" );
	
	// setup trigger
	wake( f_crash_thing_trigger );
	
end

// === f_crash_thing_deinit::: Deinit
script dormant f_crash_thing_deinit()
	//dprint( "::: f_crash_thing_deinit :::" );
	
	// kill functions
	kill_script( f_crash_thing_init );
	kill_script( f_crash_thing_trigger );
	
end

// === f_crash_thing_trigger::: TRIGGER
script dormant f_crash_thing_trigger()
	//dprint( "::: f_crash_thing_trigger :::" );

	f_damage_volume_players( tv_crash_thing_damage, 5.0, 2.5, 1 );

end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// CRASH: DOORS
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_crash_doors_init::: Init
script dormant f_crash_doors_init()
	//dprint( "::: f_crash_doors_init :::" );
	
	// init sub modules
	wake( f_crash_door_mid_init );
	wake( f_crash_door_exit_init );
	
end

// === f_crash_doors_deinit::: Deinit
script dormant f_crash_doors_deinit()
	//dprint( "::: f_crash_doors_deinit :::" );

	// deinit sub modules
	wake( f_crash_door_mid_deinit );
	wake( f_crash_door_exit_deinit );
	
	// kill functions
	kill_script( f_crash_doors_init );
	
end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// CRASH: DOOR: MID
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------

// === f_crash_door_mid_init::: Init
script dormant f_crash_door_mid_init()
//local long l_thread = 0;
	//dprint( "::: f_crash_door_mid_init :::" );

	// set speed
	sleep_until( object_valid(door_crash_exit) and object_active_for_script(door_crash_exit), 1 );
	door_crash_exit->speed_open( 3.0 );

	// setup auto disable	
	thread( door_crash_exit->auto_enabled_zoneset(FALSE, S_ZONESET_TO_HORSESHOE, -1) );

	// open
	door_crash_exit->zoneset_auto_open_setup( S_ZONESET_CRASH_TRANSITION, TRUE, TRUE, S_ZONESET_CRASH, S_ZONESET_CRASH_TRANSITION, TRUE );
	door_crash_exit->auto_distance_open( -2.75, FALSE );
	
	// close
	door_crash_exit->zoneset_auto_close_setup( S_ZONESET_TO_HORSESHOE, TRUE, TRUE, S_ZONESET_CRASH, S_ZONESET_TO_HORSESHOE, TRUE );
	door_crash_exit->auto_trigger_close_all_out( tv_crash_door_close_out, TRUE );
	
	// force closed
	door_crash_exit->close_immediate();
	
end

// === f_crash_door_mid_deinit::: Deinit
script dormant f_crash_door_mid_deinit()
	//dprint( "::: f_crash_door_mid_deinit :::" );
	
	// kill functions
	kill_script( f_crash_door_mid_init );
	//kill_script( f_crash_door_mid_trigger );
	
end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// CRASH: DOOR: EXIT
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------

// === f_crash_door_exit_init::: Init
script dormant f_crash_door_exit_init()

	// setup vo triggers
	wake( f_crash_door_exit_trigger );

	// wait for objective
	sleep_until( f_objective_blipped_check(DEF_R_OBJECTIVE_CRASH_EXIT()), 1 );

	sleep_until( object_valid(door_horseshoe_enter) and object_active_for_script(door_horseshoe_enter), 1 );
	//dprint( "::: f_crash_door_exit_init :::" );
	
	// setup auto disable	
	thread( door_horseshoe_enter->auto_enabled_zoneset(FALSE, S_ZONESET_HORSESHOE, -1) );

	// open
	door_horseshoe_enter->zoneset_auto_open_setup( S_ZONESET_TO_HORSESHOE, TRUE, TRUE, S_ZONESET_CRASH, S_ZONESET_CRASH_TRANSITION, TRUE );
	door_horseshoe_enter->auto_distance_open( -5.0, FALSE );
	
	// close
	door_horseshoe_enter->zoneset_auto_close_setup( S_ZONESET_HORSESHOE, TRUE, TRUE, S_ZONESET_TO_HORSESHOE, S_ZONESET_TO_HORSESHOE, TRUE );
	door_horseshoe_enter->auto_trigger_close_all_out( tv_horseshoe_door_enter_close, TRUE );

	// complete the exit objective
	f_objective_complete( DEF_R_OBJECTIVE_HORSESHOE_ENTER(), FALSE, TRUE );

	// force closed
	door_horseshoe_enter->close_immediate();
	
end

// === f_crash_door_exit_deinit::: Deinit
script dormant f_crash_door_exit_deinit()
	//dprint( "::: f_crash_door_exit_deinit :::" );
	
	// kill functions
	kill_script( f_crash_door_exit_init );
	kill_script( f_crash_door_exit_trigger );
	
end

// === f_crash_door_exit_trigger::: Trigger
script dormant f_crash_door_exit_trigger()
	//dprint( "::: f_crash_door_exit_trigger :::" );
	
	sleep_until( volume_test_players(m80_quarantine_01), 1 );

	// quarantine on	
	if ( not f_objective_blipped_check(DEF_R_OBJECTIVE_CRASH_EXIT()) ) then
		wake( f_dialog_m80_quarantine_on );
		sleep_until( volume_test_players(m80_quarantine_01) and f_objective_blipped_check(DEF_R_OBJECTIVE_CRASH_EXIT()), 1 );
	end
	
	// quarantine off
	wake( f_dialog_m80_quarantine_off );
	
end

