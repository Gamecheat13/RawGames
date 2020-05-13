//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// Mission: 					m10_crash_end
//	Insertion Points:	start (or icr)	- Beginning
//										ibr							- Broken Floor
//										iea							- explosion alley
//										ivb							- Vehicle Bay
//										iju							- Jump maintenance_AI
//										
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343

// -------------------------------------------------------------------------------------------------
// MAINTENANCE: AI
// -------------------------------------------------------------------------------------------------
// variables
global boolean b_maintenance_AI_start_enabled 							= TRUE;
global boolean b_maintenance_AI_room_enabled 								= TRUE;
global boolean b_maintenance_AI_upper_enabled 							= TRUE;
global boolean b_maintenance_AI_lower_enabled 							= TRUE;


// functions
// === f_maintenance_AI_init::: Initialize
script dormant f_maintenance_AI_init()
	dprint( "::: f_maintenance_AI_init :::" );

	// initialize sub modules
	wake( f_maintenance_AI_start_init );
	wake( f_maintenance_AI_room_init );

end

// === f_maintenance_AI_deinit::: Deinitialize
script dormant f_maintenance_AI_deinit()
	//dprint( "::: f_maintenance_AI_deinit :::" );

	// deinitialize sub modules
	wake( f_maintenance_AI_start_deinit );
	wake( f_maintenance_AI_room_deinit );

end

// === f_maintenance_ai_cleanup::: Cleanup
script dormant f_maintenance_ai_cleanup()
	//dprint( "::: f_maintenance_ai_cleanup :::" );
	
	ai_kill( gr_maintenance );
	
end



// -------------------------------------------------------------------------------------------------
// MAINTENANCE: AI: START
// -------------------------------------------------------------------------------------------------
// variables

// functions
// === f_maintenance_AI_start_init::: Initialize
script dormant f_maintenance_AI_start_init()
	//dprint( "::: f_maintenance_AI_start_init :::" );

	// initialize sub modules
	if( b_maintenance_AI_start_enabled ) then
		//wake( f_maintenance_AI_start_upper_init );
		wake( f_maintenance_AI_start_lower_init );
	end

end

// === f_maintenance_AI_start_deinit::: Deinitialize
script dormant f_maintenance_AI_start_deinit()
	//dprint( "::: f_maintenance_AI_start_deinit :::" );

	// deinitialize sub modules
	sleep_forever( f_maintenance_AI_start_init );

end

// -------------------------------------------------------------------------------------------------
// MAINTENANCE: AI: START: UPPER
// -------------------------------------------------------------------------------------------------
// variables
global short S_maintenance_start_warnings = 0;

// functions
// === f_maintenance_AI_start_upper_init::: Initialize
//script dormant f_maintenance_AI_start_upper_init()
//	//dprint( "::: f_maintenance_AI_start_upper_init :::" );
//
////	// initialize sub modules
////	if ( b_maintenance_AI_upper_enabled ) then
////		ai_place( sq_maintenance_start_upper );
////	end
//
//end

//// === f_maintenance_AI_start_upper_deinit::: Deinitialize
//script dormant f_maintenance_AI_start_upper_deinit()
//	//dprint( "::: f_maintenance_AI_start_upper_deinit :::" );
//
//	// deinitialize sub modules
//	wake( f_maintenance_AI_start_upper_init );
//
//end

// === msug_start_gate =============================================================================
// === f_B_maintenance_AI_msug_start_CONDITION::: Conditions
script static boolean f_B_maintenance_AI_msug_start_CONDITION()
	( not f_B_brokenfloor_destruction_destroyed() ) and ( not volume_test_players(tv_maintenance_start_grunt_break) ) and ( current_zone_set_fully_active() < S_zoneset_32_broken_34_maintenance );
end

// --- msug_start -----------------------------------------------------------------------------
// === cs_maintenance_AI_start_msusg_wave::: ai
script command_script cs_maintenance_AI_start_msusg_wave()
	
	repeat
		cs_abort_on_alert( FALSE );
		cs_abort_on_damage( TRUE );
	
		if ( volume_test_objects(tv_maintenance_start_grunt_wave, ai_get_object(ai_current_actor)) ) then
			//dprint( "::: cs_maintenance_AI_start_msusg_wave: A :::" );
			cs_stationary_face( TRUE, ps_maintenance_start_upper.wave_face );
			cs_custom_animation( 'objects\characters\storm_grunt\storm_grunt.model_animation_graph', "combat:pistol:taunt:var4", TRUE );
		else
			//dprint( "::: cs_maintenance_AI_start_msusg_wave: B :::" );
			cs_stop_custom_animation();
			cs_go_to_and_face( ps_maintenance_start_upper.wave_loc, ps_maintenance_start_upper.wave_face );
		end
	
	until( FALSE, 1 );
		
end

// === cs_maintenance_AI_start_msusg_combat::: ai
script command_script cs_maintenance_AI_start_msusg_combat()
static boolean b_secondary = TRUE;
	//dprint( "::: cs_maintenance_AI_start_msusg_combat: !!!!!!!!!!!!!!!!!!! :::" );

	cs_stop_custom_animation();

	cs_abort_on_alert( FALSE );
	cs_abort_on_damage( FALSE );
	cs_shoot_secondary_trigger( TRUE );
	
end

// --- msug_transition -----------------------------------------------------------------------------
// === XXX::: XXX
script command_script cs_maintenance_AI_start_msug_transition()


//( not f_B_brokenfloor_destruction_destroyed() ) and ( not volume_test_players(tv_maintenance_start_grunt_break) ) and ( current_zone_set_fully_active() < S_zoneset_32_broken_34_maintenance );
	dprint( "------------------------------------------------------------" );
	dprint_if( f_B_brokenfloor_destruction_destroyed(), "f_B_brokenfloor_destruction_destroyed()" );
	dprint_if( volume_test_players(tv_maintenance_start_grunt_break), "volume_test_players(tv_maintenance_start_grunt_break)" );
	dprint_if( current_zone_set_fully_active() >= S_zoneset_32_broken_34_maintenance, "current_zone_set_fully_active() >= S_zoneset_32_broken_34_maintenance" );
	dprint( "------------------------------------------------------------" );

	cs_stop_custom_animation();

	cs_abort_on_alert( FALSE );
	cs_abort_on_damage( FALSE );
	cs_stationary_face( TRUE, ps_maintenance_start_upper.warn_face );
	cs_push_stance( "FLEE" );	
	
	repeat
		cs_go_to( ps_maintenance_start_upper.warn_transit, .125 );
	until ( objects_distance_to_point(ai_get_object(ai_current_actor), ps_maintenance_start_upper.warn_transit) < 0.25, 1 );
	cs_push_stance( "" );
	unit_set_current_vitality( ai_current_actor, 1.0, 0.0 );
	cs_go_to_and_face( ps_maintenance_start_upper.warn_transit, ps_maintenance_start_upper.warn_face );


end

// --- msug_warn -----------------------------------------------------------------------------------
// === XXX::: XXX
script static boolean f_B_maintenance_AI_start_msug_warn_CONDITION()
	( not f_B_maintenance_destruction_done() ) and 
	( not B_maintenance_upper_saw_player ) and 
	( not (f_maintenance_lower_hasplayers() and f_ai_is_aggressive(gr_maintenance_lower)) );
end
//// === XXX::: XXX
//script command_script cs_maintenance_AI_start_msug_warn()
//	dprint( "::: cs_maintenance_AI_start_msug_warn: !!!!!!!!!!!!!!!!!!! :::" );
//
//	// cancel the previous task group
//	ai_set_task_condition( ai_maintenance.msug_start_gate, FALSE );
//
//	repeat
//		cs_abort_on_alert( FALSE );
//		cs_abort_on_damage( FALSE );
//	
//		if ( volume_test_objects(tv_maintenance_start_grunt_warn, ai_get_object(ai_current_actor)) ) then
//		
//			dprint( "::: cs_maintenance_AI_start_msug_warn: A :::" );
//			begin_random_count(1)
//				cs_stationary_face_object( TRUE, ai_get_object(sq_maintenance_upper_grunt_01) );
//				cs_stationary_face_object( TRUE, ai_get_object(sq_maintenance_upper_grunt_02) );
//				cs_stationary_face_object( TRUE, ai_get_object(sq_maintenance_upper_grunt_03) );
//				cs_stationary_face_object( TRUE, ai_get_object(sq_maintenance_upper_grunt_04) );
//				//cs_stationary_face_object( TRUE, ai_get_object(sq_maintenance_upper_grunt_05) );
//				//cs_stationary_face_object( TRUE, ai_get_object(sq_maintenance_upper_grunt_06) );
//			end
//		
//			cs_custom_animation( 'objects\characters\storm_grunt\storm_grunt.model_animation_graph', "combat:pistol:warn", TRUE );
//			S_maintenance_start_warnings = S_maintenance_start_warnings + 1;
//		else
//			dprint( "::: cs_maintenance_AI_start_msug_warn: B :::" );
//			cs_stop_custom_animation();
//			cs_push_stance( "FLEE" );	
//			cs_go_to_and_face( ps_maintenance_start_upper.warn_loc, ps_maintenance_start_upper.warn_face );
//		end
//
//	until( FALSE, 1 );
//
//end

// === msueg_escape_gate ===========================================================================
// --- msueg_start ---------------------------------------------------------------------------------
// === XXX::: XXX
//script command_script cs_maintenance_AI_start_msueg_start()
//static real r_health = unit_get_health(ai_current_actor);
//
//	cs_abort_on_alert( FALSE );
//	cs_abort_on_damage( FALSE );
////	if ( B_maintenance_upper_saw_player ) then
////		ai_set_task_condition( ai_maintenance.mugg_listen_gate, FALSE );
////	end
//	if ( (unit_get_health(ai_current_actor) >= r_health) and (f_maintenance_upper_hasplayers()) ) then
//		if ( not f_ai_sees_enemy(ai_current_actor) ) then
//			cs_custom_animation( 'objects\characters\storm_grunt\storm_grunt.model_animation_graph', "combat:pistol:taunt:var2", TRUE );
//		end
//		if ( not f_ai_sees_enemy(ai_current_actor) ) then
//			cs_custom_animation( 'objects\characters\storm_grunt\storm_grunt.model_animation_graph', "combat:unarmed:surprise_back", TRUE );
//		end
//	end
//	ai_set_task_condition( ai_maintenance.msueg_start, FALSE );
//	
//end
//
//// === XXX::: XXX
//script command_script cs_maintenance_AI_start_msueg_flee()
//
//	//dprint( "cs_maintenance_AI_start_msug_escape: A" );
//	cs_stop_custom_animation();
//
//	cs_abort_on_alert( FALSE );
//	cs_abort_on_damage( FALSE );
//	
////	ai_set_task_condition( ai_maintenance.mugg_listen_gate, FALSE );
//	cs_push_stance( "FLEE" );	
//	
//	repeat
//		cs_go_to( ps_maintenance_start_upper.escape_wait );
//	until( volume_test_objects(tv_maintenance_start_grunt_escape_wait, ai_get_object(ai_current_actor)), 1 );
//	ai_set_task_condition( ai_maintenance.msueg_flee, FALSE );
//
//	// XXX
//	// play cower animation	
//	// keep out of way of elite
//	
//end
//
//// === XXX::: XXX
//script command_script cs_maintenance_AI_start_msueg_jump()
//static real r_health = unit_get_health( ai_current_actor );
//
//	sleep_until( f_ai_sees_enemy(ai_current_actor) or volume_test_players(tv_maintenance_start_grunt_escape_force) or (unit_get_health(ai_current_actor) < r_health), 1 );
//	dprint_if( f_ai_sees_enemy(ai_current_actor), "f_ai_sees_enemy(ai_current_actor)" );
//	dprint_if( volume_test_players(tv_maintenance_start_grunt_escape_force), "volume_test_players(tv_maintenance_start_grunt_escape_force)" );
//	cs_abort_on_alert( FALSE );
//	cs_abort_on_damage( FALSE );
//	cs_push_stance( "FLEE" );	
//	cs_go_to( ps_maintenance_start_upper.escape_jump );
//
//end













// -------------------------------------------------------------------------------------------------
// MAINTENANCE: AI: START: LOWER
// -------------------------------------------------------------------------------------------------
// variables

// functions
// === f_maintenance_AI_start_lower_init::: Initialize
script dormant f_maintenance_AI_start_lower_init()
	//dprint( "::: f_maintenance_AI_start_lower_init :::" );

	// initialize sub modules
	if ( b_maintenance_AI_lower_enabled ) then
		if ( ai_spawn_count(gr_maintenance_start_lower) == 0 ) then
			ai_place( gr_maintenance_start_lower );
		end
	end

end

// === f_maintenance_AI_start_lower_deinit::: Deinitialize
script dormant f_maintenance_AI_start_lower_deinit()
	//dprint( "::: f_maintenance_AI_start_lower_deinit :::" );

	// deinitialize sub modules
	wake( f_maintenance_AI_start_lower_init );

end

script static boolean f_B_maintenance_AI_mlg_respond_gate_CONDITION()
	(current_zone_set_fully_active() < S_zoneset_32_broken_34_maintenance) or ((not f_ai_is_aggressive(sq_maintenance_upper_elite)) and (not f_maintenance_upper_hasplayers()) and (not f_maintenance_lower_hasplayers()));
end

script command_script cs_maintenance_AI_mlrg_move()
static short s_loc = 0;

	//dprint( "cs_maintenance_AI_mlrg_move: A" );

	cs_abort_on_alert( FALSE );
	cs_abort_on_damage( FALSE );

	s_loc = s_loc + 1;
	if ( s_loc == 1 ) then
		cs_go_to_and_face( ps_maintenance_start_lower.respond_01, ps_maintenance_start_lower.respond_look );
	end
	if ( s_loc == 2 ) then
		cs_go_to_and_face( ps_maintenance_start_lower.respond_02, ps_maintenance_start_lower.respond_look );
	end
	if ( s_loc == 3 ) then
		cs_go_to_and_face( ps_maintenance_start_lower.respond_03, ps_maintenance_start_lower.respond_look );
	end
	
end



// -------------------------------------------------------------------------------------------------
// MAINTENANCE: AI: ROOM
// -------------------------------------------------------------------------------------------------
// variables

// functions
// === f_maintenance_AI_room_init::: Initialize
script dormant f_maintenance_AI_room_init()
	//dprint( "::: f_maintenance_AI_room_init :::" );

//	// initialize sub modules
	if ( b_maintenance_AI_room_enabled ) then
		wake( f_maintenance_AI_room_upper_init );
//		wake( f_maintenance_AI_room_lower_init );
	end

end

// === f_maintenance_AI_room_deinit::: Deinitialize
script dormant f_maintenance_AI_room_deinit()
	//dprint( "::: f_maintenance_AI_room_deinit :::" );

	wake( f_maintenance_AI_room_upper_deinit );
	//wake( f_maintenance_AI_room_lower_deinit );

	// deinitialize sub modules
	//wake( f_maintenance_AI_room_init );

end

// -------------------------------------------------------------------------------------------------
// MAINTENANCE: AI: ROOM: UPPER
// -------------------------------------------------------------------------------------------------
// variables

// functions
// === f_maintenance_AI_room_upper_init::: Initialize
script dormant f_maintenance_AI_room_upper_init()
	sleep_until( f_B_maintenance_destruction_loaded(), 1 );
	dprint( "::: f_maintenance_AI_room_upper_init :::" );

	sleep_until(volume_test_players(tv_enter_maintenence), 1);
	pup_play_show("grunt_maintenence");
	unit_set_maximum_vitality (sq_maintenance_upper_grunt_01.spawn_points_0, 1 ,1);
	unit_set_maximum_vitality (sq_maintenance_upper_grunt_02.spawn_points_0, 1 ,1);
	unit_set_maximum_vitality (sq_maintenance_upper_grunt_03.spawn_points_0, 1 ,1);
	unit_set_maximum_vitality (sq_maintenance_upper_grunt_04.spawn_points_0, 1 ,1);
	
	// HAX
	//objects_attach (sn_maintenence_elite_attach,"", sq_maintenance_upper_elite.boss ,"");

	sleep_until (objects_distance_to_object (m10_maintenance_dropcrate_f01, sq_maintenance_upper_elite.boss) < 2, 1);
	//objects_detach (sn_maintenence_elite_attach, sq_maintenance_upper_elite.boss);

	damage_object (sq_maintenance_upper_elite.boss, body, 10000);
	damage_object (sq_maintenance_upper_grunt_02, body, 10000);
	sleep(15);
	damage_object (fuel_can_u_3, default, 10000);
	sleep(15);
	damage_object (fuel_can_u_2, default, 10000);

	
end

// === f_maintenance_AI_room_upper_deinit::: Deinitialize
script dormant f_maintenance_AI_room_upper_deinit()
	//dprint( "::: f_maintenance_AI_room_upper_deinit :::" );

	// deinitialize sub modules
	wake( f_maintenance_AI_room_upper_init );

end

// -------------------------------------------------------------------------------------------------
// MAINTENANCE: AI: ROOM: UPPER: ELITE
// -------------------------------------------------------------------------------------------------
global boolean B_maintenance_AI_room_upper_elite_berzerk = FALSE;
global boolean B_maintenance_AI_room_upper_elite_hostile = FALSE;

script static boolean f_B_maintenance_AI_mueg_berzerk_CONDITION()
static boolean b_return = FALSE;
static object o_elite = ai_get_object( sq_maintenance_upper_elite );

	b_return = 
	(
		(
			f_maintenance_upper_hasplayers() 
			and
			(
				f_maintenance_destruction_ramp01_destroyed()
				or
				f_maintenance_destruction_ramp02_destroyed()
			)
		)
		or
		(
			f_ai_is_aggressive(sq_maintenance_upper_elite)
			and
			(unit_get_health(sq_maintenance_upper_elite) < 1.0)
		)
		or
		(
			volume_test_players( tv_maintenance_upper_elite_home_area )
			and
			volume_test_objects( tv_maintenance_upper_elite_home_area, o_elite )
		)
		or
		(
			volume_test_players( tv_maintenance_upper_elite_look_from )
			and
			volume_test_players_lookat( tv_maintenance_upper_elite_look_at, 7.5, 5.0 )
		)
		or
		(
			f_maintenance_hall_destruction_active()
		)
	);
	
	// return
	b_return;
end

script command_script cs_maintenance_ai_mueg_berzerk()


	sleep_until( f_ai_is_aggressive(ai_current_actor), 1 );
	dprint( "::: cs_maintenance_ai_mueg_berzerk!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! :::" );
	// make the boss go berzerk
	cs_stop_custom_animation();
	ai_berserk( ai_current_actor, TRUE );
	
end


script static void f_maintenance_ai_mueg_base_combat_ENTRY()
	//dprint( "::: f_maintenance_ai_mueg_base_combat_ENTRY !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! :::" );

	B_maintenance_AI_room_upper_elite_hostile = TRUE;
	
end

//// === cs_maintenance_ai_mueg_base_combat::: AI
//script command_script cs_maintenance_ai_mueg_base_combat()
//	//dprint( "::: cs_maintenance_ai_mueg_base_combat !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! :::" );
//
//	cs_stop_custom_animation();
//	ai_set_task_condition( ai_maintenance.mueg_home, FALSE );
//	
//end

//script static boolean f_B_maintenance_AI_mueg_watch_CONDITION()
//	( (not f_maintenance_upper_hasplayers()) and f_maintenance_lower_hasplayers() ) and ( f_ai_is_aggressive(gr_maintenance_lower) or S_maintenance_start_warnings );
//end
//
//script static void f_maintenance_AI_mueg_watch_ENTRY()
//	dprint( "f_maintenance_AI_mueg_watch_ENTRY" );
//end
//
//script command_script cs_maintenance_AI_mueg_watch()
//	//dprint( "cs_maintenance_AI_mueg_watch !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! " );
//
//	sleep_until( f_ai_is_aggressive(sq_maintenance_upper_elite) or volume_test_players(tv_maintenance_upper_elite_watch_force_exit) or (ai_living_count(sq_maintenance_lower_elite) < ai_spawn_count(sq_maintenance_lower_elite)), 1 );
//	
//	cs_custom_animation( 'objects\characters\storm_elite_ai\storm_elite_ai.model_animation_graph', "combat:rifle:shakefist", TRUE );
//	ai_set_task_condition( ai_maintenance.mueg_cutoff, TRUE );
//	ai_set_task_condition( ai_maintenance.mueg_watch, FALSE );
//	
//end
//
//script static boolean f_B_maintenance_AI_mueg_track_gate_CONDITION()
//
//	( not f_maintenance_upper_hasplayers() ) and f_maintenance_lower_hasplayers();
//end
//
//script command_script cs_maintenance_AI_mueg_cutoff()
//static real r_sheilds = 0.0;
//	
//	cs_stop_custom_animation();
//	repeat
//		cs_abort_on_alert( FALSE );
//		cs_abort_on_damage( FALSE );
//
//		if ( unit_get_shield(ai_current_actor) > r_sheilds ) then
//			r_sheilds = unit_get_shield( ai_current_actor );
//		end
//		
//		//dprint( "cs_maintenance_AI_mueg_cutoff !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! " );
//		if ( volume_test_objects(tv_maintenance_upper_elite_home_area, ai_get_object(ai_current_actor)) ) then
//			cs_go_to( ps_maintenance_upper_elite.wait_transition_01, 1.0 );
//		elseif ( not volume_test_objects(tv_maintenance_upper_elite_transition_02, ai_get_object(ai_current_actor)) ) then
//			cs_go_to( ps_maintenance_upper_elite.wait_transition_02, 1.0 );
//		else
//			cs_go_to( ps_maintenance_upper_elite.wait_loc_01, 1.0 );
//		end
//	until( unit_get_shield(ai_current_actor) < (r_sheilds * 0.25), 1 );
//	
//	//dprint( "cs_maintenance_AI_mueg_cutoff: EXIT!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! " );
//	ai_set_task_condition( ai_maintenance.mueg_berzerk, TRUE );
//	ai_set_task_condition( ai_maintenance.mueg_wait, FALSE );
//	ai_set_task_condition( ai_maintenance.mueg_cutoff, FALSE );
//	ai_set_task_condition( ai_maintenance.mueg_watch, FALSE );
//	ai_set_task_condition( ai_maintenance.mueg_base_combat, FALSE );
//	ai_set_task_condition( ai_maintenance.mueg_home, FALSE );
//end
//
//script command_script cs_maintenance_ai_mueg_wait()
//	//dprint( "cs_maintenance_ai_mueg_wait !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! " );
//
//	cs_abort_on_alert( FALSE );
//	cs_abort_on_damage( TRUE );
//
//	ai_set_task_condition( ai_maintenance.mueg_cutoff, FALSE );
//	ai_set_task_condition( ai_maintenance.mueg_watch, FALSE );
//	ai_set_task_condition( ai_maintenance.mueg_base_combat, FALSE );
//	ai_set_task_condition( ai_maintenance.mueg_home, FALSE );
//
//	cs_go_to( ps_maintenance_upper_elite.wait_look_01 );
//	cs_stationary_face( TRUE, ps_maintenance_upper_elite.wait_look_01 );
//
//	sleep_until( volume_test_players(tv_maintenance_upper_elite_wait_watch), 1 );
//	ai_set_task_condition( ai_maintenance.mueg_berzerk, TRUE );
//
//end
//
//script static boolean f_B_maintenance_AI_mueg_wait_CONDITION()
//	volume_test_objects( tv_maintenance_upper_elite_wait, ai_get_object(sq_maintenance_upper_elite) );
//end

// -------------------------------------------------------------------------------------------------
// MAINTENANCE: AI: ROOM: UPPER: GRUNTS
// -------------------------------------------------------------------------------------------------
global boolean B_maintenance_upper_saw_player = FALSE;

// === cs_maintenance_AI_room_upper_grunt::: AI
script command_script cs_maintenance_AI_room_upper_grunt()

	//dprint( "::: cs_maintenance_AI_room_upper_grunt :::" );

	cs_abort_on_alert( FALSE );
	cs_abort_on_damage( FALSE );
	cs_push_stance( "FLEE" );	
	repeat
		//cs_set_pathfinding_radius( real_random_range(2.0, 5.0) );
		begin_random_count(1)	
			cs_go_to( ps_maintenance_upper_grunts.p0, 0.75 );
			cs_go_to( ps_maintenance_upper_grunts.p1, 0.75 );
			cs_go_to( ps_maintenance_upper_grunts.p2, 0.75 );
			cs_go_to( ps_maintenance_upper_grunts.p3, 0.75 );
			cs_go_to( ps_maintenance_upper_grunts.p4, 0.75 );
			cs_go_to( ps_maintenance_upper_grunts.p5, 0.75 );
			cs_go_to( ps_maintenance_upper_grunts.p6, 0.75 );
			cs_go_to( ps_maintenance_upper_grunts.p7, 0.75 );
			cs_go_to( ps_maintenance_upper_grunts.p8, 0.75 );
			cs_go_to( ps_maintenance_upper_grunts.p9, 0.75 );
			cs_go_to( ps_maintenance_upper_grunts.p10, 0.75 );
			cs_go_to( ps_maintenance_upper_grunts.p11, 0.75 );
			cs_go_to( ps_maintenance_upper_grunts.p12, 0.75 );
			cs_go_to( ps_maintenance_upper_grunts.p13, 0.75 );
			cs_go_to( ps_maintenance_upper_grunts.p14, 0.75 );
			cs_go_to( ps_maintenance_upper_grunts.p15, 0.75 );
			cs_go_to( ps_maintenance_upper_grunts.p16, 0.75 );
			cs_go_to( ps_maintenance_upper_grunts.p17, 0.75 );
			cs_go_to( ps_maintenance_upper_grunts.p18, 0.75 );
			cs_go_to( ps_maintenance_upper_grunts.p19, 0.75 );
			cs_go_to( ps_maintenance_upper_grunts.p20, 0.75 );
			cs_go_to( ps_maintenance_upper_grunts.p21, 0.75 );
			cs_go_to( ps_maintenance_upper_grunts.p22, 0.75 );
			cs_go_to( ps_maintenance_upper_grunts.p23, 0.75 );
			cs_go_to( ps_maintenance_upper_grunts.p24, 0.75 );
			cs_go_to( ps_maintenance_upper_grunts.p25, 0.75 );
			cs_go_to( ps_maintenance_upper_grunts.p26, 0.75 );
		end
	until ( FALSE, 1 );
	
end
//script command_script cs_maintenance_AI_room_upper_listen()
//static short s_loc = 0;
//
//	//dprint( "::: cs_maintenance_AI_room_upper_listen :::" );
//	
//	cs_abort_on_alert( FALSE );
//	cs_abort_on_damage( FALSE );
//	
//	s_loc = s_loc + 1;
//	if ( s_loc == 1 ) then
//		cs_go_to_and_face( ps_maintenance_upper_grunts.listen_01, ps_maintenance_start_upper.warn_loc );
//	end
//	if ( s_loc == 2 ) then
//		cs_go_to_and_face( ps_maintenance_upper_grunts.listen_02, ps_maintenance_start_upper.warn_loc );
//	end
//	if ( s_loc == 3 ) then
//		cs_go_to_and_face( ps_maintenance_upper_grunts.listen_03, ps_maintenance_start_upper.warn_loc );
//	end
//	if ( s_loc == 4 ) then
//		cs_go_to_and_face( ps_maintenance_upper_grunts.listen_04, ps_maintenance_start_upper.warn_loc );
//	end
//	if ( s_loc == 5 ) then
//		cs_go_to_and_face( ps_maintenance_upper_grunts.listen_05, ps_maintenance_start_upper.warn_loc );
//	end
//	
//	if ( not f_ai_is_aggressive(ai_current_actor) ) then
//		repeat
//			cs_stop_custom_animation();
//			//cs_stationary_face_object( TRUE, ai_get_object(sq_maintenance_start_upper) );
//			//dprint( "::: cs_maintenance_AI_room_upper_listen: A :::" );
//			cs_custom_animation( 'objects\characters\storm_grunt\storm_grunt.model_animation_graph', "combat:pistol:brace", TRUE );
//		until( f_ai_is_aggressive(ai_current_actor), 1 );
//	end
//
//	//dprint( "::: cs_maintenance_AI_room_upper_listen: B :::" );
//
//	cs_stop_custom_animation();
//	begin_random_count(1)
//		cs_custom_animation( 'objects\characters\storm_grunt\storm_grunt.model_animation_graph', "combat:pistol:point", TRUE );
//		cs_custom_animation( 'objects\characters\storm_grunt\storm_grunt.model_animation_graph', "combat:pistol:surprise_front", TRUE );
//	end
//	B_maintenance_upper_saw_player = TRUE;
//
//	//dprint( "::: cs_maintenance_AI_room_upper_listen: C :::" );
//	ai_set_task_condition( ai_maintenance.mugg_upper, FALSE );
//
//end


// -------------------------------------------------------------------------------------------------
// MAINTENANCE: AI: ROOM: LOWER
// -------------------------------------------------------------------------------------------------
// variables
//global object O_maintenance_AI_room_elite = NONE;
//global boolean B_maintenace_AI_room_lower_chaos = FALSE;
//
//// functions
//// === f_maintenance_AI_room_lower_init::: Initialize
//script dormant f_maintenance_AI_room_lower_init()
//	//dprint( "::: f_maintenance_AI_room_lower_init :::" );
//
//	// initialize sub modules
//	if ( b_maintenance_AI_lower_enabled ) then
//		if ( ai_spawn_count(sq_maintenance_lower_elite) == 0 ) then
//			ai_place( sq_maintenance_lower_elite );
//		end
//		if ( ai_spawn_count(sq_maintenance_lower_grunts) == 0 ) then
//			ai_place( sq_maintenance_lower_grunts );
//		end
//	end
//	
//end

// === f_maintenance_AI_room_lower_deinit::: Deinitialize
//script dormant f_maintenance_AI_room_lower_deinit()
//	//dprint( "::: f_maintenance_AI_room_lower_deinit :::" );
//
//	// deinitialize sub modules
//	wake( f_maintenance_AI_room_lower_init );
//
//end

//// === cs_maintenance_AI_room_lower_elite_mleg_orders::: AI
//script command_script cs_maintenance_AI_room_lower_elite_mleg_orders()
//static object o_jackel = NONE;
//static real r_order_range = 2.0;
//	//dprint( "::: cs_maintenance_AI_room_lower_elite_mleg_orders :::" );
//
//	O_maintenance_AI_room_elite = ai_get_object( ai_current_actor );
//
//	cs_abort_on_alert( FALSE );
//	cs_abort_on_damage( FALSE );
////	repeat
////		cs_go_to( ps_maintenance_lower_orders.elite );
////		// face
////		begin_random_count(1)	
////			o_jackel = ai_get_object( sq_maintenance_lower_jackal );
////			o_jackel = ai_get_object( sq_maintenance_start_lower_01 );
////			o_jackel = ai_get_object( sq_maintenance_start_lower_02 );
////		end
////		
////		if ( object_get_health(o_jackel) > 0 ) then
////			cs_stop_custom_animation();
////			cs_stationary_face_object ( FALSE, o_jackel );
////
////			if ( objects_distance_to_object(o_jackel, O_maintenance_AI_room_elite) < r_order_range ) then
////				// give order
////				begin_random_count(1)	
////					cs_custom_animation( 'objects\characters\storm_elite_ai\storm_elite_ai.model_animation_graph', "combat:rifle:warn", TRUE );
////					cs_custom_animation( 'objects\characters\storm_elite_ai\storm_elite_ai.model_animation_graph', "combat:rifle:shakefist", TRUE );
////					cs_custom_animation( 'objects\characters\storm_elite_ai\storm_elite_ai.model_animation_graph', "combat:rifle:point", TRUE );
////				end
////			end
////
////		end
////		sleep_s( 0.25 );
////		
////	until ( (ai_living_count(sq_maintenance_lower_jackal) < 0) and (ai_living_count(sq_maintenance_start_lower_01) < 0) and (ai_living_count(sq_maintenance_start_lower_02) < 0), 1 );
//
//	// shut down this task
//	ai_set_task_condition( ai_maintenance.mleg_orders, FALSE );
//	ai_set_task_condition( ai_maintenance.mjg_orders, FALSE );
//	
//end
//script command_script cs_maintenance_AI_room_lower_elite_mleg_combat()
//	//dprint( "::: cs_maintenance_AI_room_lower_elite_mleg_combat :::" );
//
//	ai_set_task_condition( ai_maintenance.mleg_orders, FALSE );
//	ai_set_task_condition( ai_maintenance.mjg_orders, FALSE );
//
//end
//
//script static boolean f_B_maintenance_AI_lower_orders_CONDITION()
//	( not f_ai_is_aggressive(sq_maintenance_lower_elite) ) and ( ai_living_count(sq_maintenance_lower_elite) > 0 ) and ( not B_maintenace_AI_room_lower_chaos );
//end
//
//script command_script cs_maintenance_AI_mjg_orders()
//static short s_loc = 0;
//
//	//dprint( "::: cs_maintenance_AI_mjg_orders :::" );
//	repeat
//		cs_go_to( ps_maintenance_start_lower.orders_transition, 0.25 );
//	until( (current_zone_set_fully_active() == S_zoneset_32_broken_34_maintenance) or (objects_distance_to_point(ai_get_object(ai_current_actor), ps_maintenance_start_lower.orders_transition) >= 0.5), 1 );
//	
//	cs_abort_on_alert( FALSE );
//	cs_abort_on_damage( FALSE );
//	
//	s_loc = s_loc + 1;
//	if ( s_loc == 1 ) then
//		cs_run_command_script( ai_current_actor, cs_maintenance_AI_mjg_orders_01 );
//	end
//	if ( s_loc == 2 ) then
//		cs_run_command_script( ai_current_actor, cs_maintenance_AI_mjg_orders_02 );
//	end
//	if ( s_loc == 3 ) then
//		cs_run_command_script( ai_current_actor, cs_maintenance_AI_mjg_orders_03 );
//	end
//
//end

//script command_script cs_maintenance_AI_mjg_orders_01()
//
//	cs_abort_on_alert( FALSE );
//	cs_abort_on_damage( FALSE );
//	repeat
//		if ( objects_distance_to_point(ai_get_object(ai_current_actor),ps_maintenance_lower_orders.jackal_01) > 0.25 ) then
//			cs_go_to( ps_maintenance_lower_orders.jackal_01, 0.25 );
//		end
//		cs_stationary_face_object( FALSE, O_maintenance_AI_room_elite );
//		sleep_rand_s( 0.5, 1.75 );
//	until ( FALSE, 1 );
//
//end
//
//script command_script cs_maintenance_AI_mjg_orders_02()
//
//	cs_abort_on_alert( FALSE );
//	cs_abort_on_damage( FALSE );
//	repeat
//		if ( objects_distance_to_point(ai_get_object(ai_current_actor),ps_maintenance_lower_orders.jackal_02) > 0.25 ) then
//			cs_go_to( ps_maintenance_lower_orders.jackal_02, 0.25 );
//		end
//		cs_stationary_face_object( FALSE, O_maintenance_AI_room_elite );
//		sleep_rand_s( 0.5, 1.75 );
//	until ( FALSE, 1 );
//
//end
//
//script command_script cs_maintenance_AI_mjg_orders_03()
//
//	cs_abort_on_alert( FALSE );
//	cs_abort_on_damage( FALSE );
//	repeat
//		if ( objects_distance_to_point(ai_get_object(ai_current_actor),ps_maintenance_lower_orders.jackal_03) > 0.25 ) then
//			cs_go_to( ps_maintenance_lower_orders.jackal_03, 0.25 );
//		end
//		cs_stationary_face_object( FALSE, O_maintenance_AI_room_elite );
//		sleep_rand_s( 0.5, 1.75 );
//	until ( FALSE, 1 );
//
//end
//
//script command_script cs_maintenance_AI_mjg_combat()
//	//dprint( "::: cs_maintenance_AI_mjg_combat :::" );
//
//	ai_set_task_condition( ai_maintenance.mleg_orders, FALSE );
//	ai_set_task_condition( ai_maintenance.mjg_orders, FALSE );
//
//end
//
//// === cs_maintenance_AI_room_lower_grunt::: AI
//script command_script cs_maintenance_AI_room_lower_grunt_orders()
//
//	repeat
//		cs_stop_custom_animation();
//		cs_stationary_face_object( FALSE, O_maintenance_AI_room_elite );
//		sleep_rand_s( 0.5, 1.75 );
//		begin_random_count(1)	
//			cs_custom_animation( 'objects\characters\storm_grunt\storm_grunt.model_animation_graph', "combat:pistol:warn", TRUE );
//			cs_custom_animation( 'objects\characters\storm_grunt\storm_grunt.model_animation_graph', "combat:unarmed:brace", TRUE );
//		end
//
//	until ( FALSE, 1 );
//	
//end
//
//// === cs_maintenance_AI_room_lower_grunt::: AI
//script command_script cs_maintenance_AI_room_lower_grunt_panic()
//
//	//dprint( "::: cs_maintenance_AI_room_lower_grunt :::" );
//	cs_abort_on_alert( FALSE );
//	cs_abort_on_damage( FALSE );
//	cs_push_stance( "FLEE" );	
//	repeat
//		if ( (not B_maintenace_AI_room_lower_chaos) and (volume_test_objects(tv_maintenance_lower_area, ai_get_object(ai_current_actor))) ) then
//			B_maintenace_AI_room_lower_chaos = TRUE;
//		end
//	
//		begin_random_count(1)	
//			cs_go_to( ps_maintenance_lower_grunts.p0, 0.75 );
//			cs_go_to( ps_maintenance_lower_grunts.p1, 0.75 );
//			cs_go_to( ps_maintenance_lower_grunts.p2, 0.75 );
//			cs_go_to( ps_maintenance_lower_grunts.p3, 0.75 );
//			cs_go_to( ps_maintenance_lower_grunts.p4, 0.75 );
//			cs_go_to( ps_maintenance_lower_grunts.p5, 0.75 );
//			cs_go_to( ps_maintenance_lower_grunts.p6, 0.75 );
//			cs_go_to( ps_maintenance_lower_grunts.p7, 0.75 );
//			cs_go_to( ps_maintenance_lower_grunts.p8, 0.75 );
//			cs_go_to( ps_maintenance_lower_grunts.p9, 0.75 );
//			cs_go_to( ps_maintenance_lower_grunts.p10, 0.75 );
//			cs_go_to( ps_maintenance_lower_grunts.p11, 0.75 );
//			cs_go_to( ps_maintenance_lower_grunts.p12, 0.75 );
//			cs_go_to( ps_maintenance_lower_grunts.p13, 0.75 );
//			cs_go_to( ps_maintenance_lower_grunts.p14, 0.75 );
//			cs_go_to( ps_maintenance_lower_grunts.p15, 0.75 );
//			cs_go_to( ps_maintenance_lower_grunts.p16, 0.75 );
//			cs_go_to( ps_maintenance_lower_grunts.p17, 0.75 );
//			cs_go_to( ps_maintenance_lower_grunts.p18, 0.75 );
//			cs_go_to( ps_maintenance_lower_grunts.p19, 0.75 );
//			cs_go_to( ps_maintenance_lower_grunts.p20, 0.75 );
//			cs_go_to( ps_maintenance_lower_grunts.p21, 0.75 );
//			cs_go_to( ps_maintenance_lower_grunts.p22, 0.75 );
//			cs_go_to( ps_maintenance_lower_grunts.p23, 0.75 );
//			cs_go_to( ps_maintenance_lower_grunts.p24, 0.75 );
//			cs_go_to( ps_maintenance_lower_grunts.p25, 0.75 );
//			cs_go_to( ps_maintenance_lower_grunts.p26, 0.75 );
//			cs_go_to( ps_maintenance_lower_grunts.p27, 0.75 );
//			cs_go_to( ps_maintenance_lower_grunts.p28, 0.75 );
//			cs_go_to( ps_maintenance_lower_grunts.p29, 0.75 );
//		end
//	until ( FALSE, 1 );
//	
//end

// === cs_maintenance_AI_grunt1::: AI
script command_script cs_force_flee()
	//dprint( "::: cs_maintenance_AI_grunt1 :::" );
	cs_abort_on_alert( FALSE );
	cs_abort_on_damage( FALSE );
	cs_push_stance( "FLEE" );	
end
