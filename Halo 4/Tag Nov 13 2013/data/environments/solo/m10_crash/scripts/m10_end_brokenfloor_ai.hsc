//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// Mission: 					m10_crash_end
//	Insertion Points:	start (or icr)	- Beginning
//										ibr							- Broken Floor
//										iea							- explosion alley
//										ivb							- Vehicle Bay
//										iju							- Jump Debris
//										
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343

// -------------------------------------------------------------------------------------------------
// BROKENFLOOR: AI: TEST
// -------------------------------------------------------------------------------------------------
/*
script static void test_brokenfloor_ai()
	static short s_state = 0;
	
	if ( s_state == 0 ) then
		ai_place( gr_broken_start );
		wake( f_brokenfloor_destruction_init );
	elseif ( s_state == 2 ) then
		wake( f_brokenfloor_destruction_trigger );
	else
		ai_set_task_condition( ai_broken_start.bsg_home, FALSE );
		cs_run_command_script( sq_broken_start_grunt01, cs_brokenfloor_AI_flee );
		cs_run_command_script( sq_broken_start_grunt02, cs_brokenfloor_AI_flee );
		cs_run_command_script( sq_broken_start_grunt03, cs_brokenfloor_AI_flee );
		cs_run_command_script( sq_broken_start_grunt04, cs_brokenfloor_AI_flee );
		B_brokenfloor_ai_start_active = TRUE;
	end
	s_state = s_state + 1;

end
*/



// -------------------------------------------------------------------------------------------------
// BROKENFLOOR: AI
// -------------------------------------------------------------------------------------------------
// variables

// functions
// === f_brokenfloor_AI_init::: Initialize
script dormant f_brokenfloor_AI_init()
	//dprint( "::: f_brokenfloor_AI_init :::" );

	// initialize modules
	wake( f_brokenfloor_AI_start_init );
	wake( f_maintenance_AI_start_init );

end

// === f_brokenfloor_AI_deinit::: Deinitialize
script dormant f_brokenfloor_AI_deinit()
	//dprint( "::: f_brokenfloor_AI_deinit :::" );

	// kill functions
	sleep_forever( f_brokenfloor_AI_init );
	sleep_forever( f_brokenfloor_AI_cleanup );

	// deinitialize modules
	wake( f_brokenfloor_AI_start_deinit );

end

// === f_brokenfloor_AI_cleanup::: Cleanup
script dormant f_brokenfloor_AI_cleanup()
	dprint( "::: f_brokenfloor_AI_cleanup :::" );
	sleep_until(volume_test_players(tv_broken_ai_deinit), 1);
	ai_kill_silent(gr_broken_start);
	// XXX

end



// -------------------------------------------------------------------------------------------------
// BROKENFLOOR: AI: START
// -------------------------------------------------------------------------------------------------
// variables
global boolean B_brokenfloor_ai_start_active	= FALSE;

// functions
// === f_brokenfloor_AI_start_init::: Initialize
script dormant f_brokenfloor_AI_start_init()
	//dprint( "::: f_brokenfloor_AI_start_init :::" );

	// spawn
	ai_place( gr_broken_start );
	cs_run_command_script( sq_broken_start_grunt01, cs_brokenfloor_AI_flee );
	cs_run_command_script( sq_broken_start_grunt02, cs_brokenfloor_AI_flee );
	cs_run_command_script( sq_broken_start_grunt03, cs_brokenfloor_AI_flee );
	cs_run_command_script( sq_broken_start_grunt04, cs_brokenfloor_AI_flee );

	// setup trigger
	 wake( f_brokenfloor_AI_start_trigger );

end

// === f_brokenfloor_AI_start_trigger::: Trigger the AI to start moving
script dormant f_brokenfloor_AI_start_trigger()
	sleep_until( volume_test_players(tv_broken_checkpoint_enter) or volume_test_players(tv_broken_room_force01) or f_ai_sees_enemy(gr_broken_start) or (volume_test_players(tv_broken_lookat_area) and volume_test_players_lookat(tv_broken_lookat_target, 25.0, 2.5)), 1 );
	//dprint( "::: f_brokenfloor_AI_start_trigger :::" );

	B_brokenfloor_ai_start_active = TRUE;
//	ai_set_task_condition( ai_broken_start.bsg_home, FALSE );

	// xxx store combat checkpoint to kill it
	//f_combat_checkpoint_add( gr_broken_start, 0, TRUE, 1, 15.0, -1.0 );
	game_save();

end

// === f_brokenfloor_AI_start_destruction::: Makes the AI switch to pay attention to the destruction
script dormant f_brokenfloor_AI_start_destruction()
	//dprint( "::: f_brokenfloor_AI_start_destruction :::" );

	cs_run_command_script( gr_broken_start, cs_brokenfloor_AI_destruction );

end

// === f_brokenfloor_AI_start_deinit::: Deinitialize
script dormant f_brokenfloor_AI_start_deinit()
	//dprint( "::: f_brokenfloor_AI_start_deinit :::" );

	// kill functions
	sleep_forever( f_brokenfloor_AI_start_init );

end

// === f_brokenfloor_AI_start_kill::: Kills AI if they fall in this trigger
script dormant f_brokenfloor_AI_start_kill()
	//dprint( "::: f_brokenfloor_AI_start_kill :::" );

	ai_kill( gr_broken_start );
	
end

// === cs_brokenfloor_AI_flee::: Flee towards exit
script command_script cs_brokenfloor_AI_flee()
	//dprint( "cs_brokenfloor_AI_flee" );
	
	sleep_until( B_brokenfloor_ai_start_active, 1 );
	
	cs_abort_on_alert( FALSE );
	cs_abort_on_damage( FALSE );
	cs_push_stance( "FLEE" );
	cs_go_to( ps_broken_start_exit );
	
end

// === cs_brokenfloor_AI_destruction::: Respond to destruction
script command_script cs_brokenfloor_AI_destruction()
	//dprint( "cs_brokenfloor_AI_destruction" );
	
	cs_abort_on_alert( FALSE );
	cs_abort_on_damage( FALSE );
	cs_look( TRUE, ps_broken_start_destruction.main );
	
	if ( volume_test_object(tv_broken_destruction_impact, ai_current_actor) ) then
		//sleep_rand_s( 0.0, 0.25 );
		cs_face( TRUE, ps_broken_start_dive );
		cs_custom_animation( 'objects\characters\storm_grunt\storm_grunt.model_animation_graph', "combat:missile:dive_front", TRUE );
	else
		cs_custom_animation( 'objects\characters\storm_grunt\storm_grunt.model_animation_graph', "combat:unarmed:brace", TRUE );
		if ( f_B_brokenfloor_destruction_active() ) then
			cs_custom_animation( 'objects\characters\storm_grunt\storm_grunt.model_animation_graph', "combat:unarmed:brace", TRUE );
		end
	end
	cs_stop_custom_animation();
	cs_run_command_script( ai_current_actor, cs_brokenfloor_AI_flee );
	
end



