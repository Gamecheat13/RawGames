//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434
;
; Mission: 					m80_delta
;	Insertion Points:	to_<area> (or itl)
;										
//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434



// ==========================================================================================================================================================
// ==========================================================================================================================================================
// ==========================================================================================================================================================
// *** guns_hallway: HALLWAY: AI ***
// ==========================================================================================================================================================
// ==========================================================================================================================================================
// ==========================================================================================================================================================

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_guns_hallway_ai_init::: Initialize
script dormant f_guns_hallway_ai_init()
	//dprint( "::: f_guns_hallway_ai_init :::" );
	
	// init sub modules
	sleep_until( (zoneset_current() >= S_ZONESET_LOOKOUT_HALLWAYS_A) and (zoneset_current() <= S_ZONESET_ATRIUM_RETURNING), 1 );
	wake( f_guns_hallway_ai_music_init );
	wake( f_guns_hallway_ai_phantom_init );
	wake( f_guns_hallway_ai_hub_init );
	wake( f_guns_hallway_ai_lower_init );
	wake( f_guns_hallway_ai_upper_init );

end

// === f_guns_hallway_ai_deinit::: Deinitialize
script dormant f_guns_hallway_ai_deinit()
	//dprint( "::: f_guns_hallway_ai_deinit :::" );

	// kill functions
	kill_script( f_guns_hallway_ai_init );
	
	// init sub modules
	wake( f_guns_hallway_ai_music_deinit );
	wake( f_guns_hallway_ai_phantom_deinit );
	wake( f_guns_hallway_ai_hub_deinit );
	wake( f_guns_hallway_ai_lower_deinit );
	wake( f_guns_hallway_ai_upper_deinit );
	
	// erase ai
	f_ai_garbage_erase( sg_guns_hallway );

end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// GUNS: HALLWAY: AI: MUSIC
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_guns_hallway_ai_music_init::: musicize
script dormant f_guns_hallway_ai_music_init()
	//dprint( "::: f_guns_hallway_ai_music_init :::" );
	
	// setup trigger
	wake( f_guns_hallway_ai_music_trigger );

end

// === f_guns_hallway_ai_music_deinit::: Demusicize
script dormant f_guns_hallway_ai_music_deinit()
	//dprint( "::: f_guns_hallway_ai_music_deinit :::" );

	// kill functions
	kill_script( f_guns_hallway_ai_music_init );
	kill_script( f_guns_hallway_ai_music_trigger );

end

// === f_guns_hallway_ai_music_trigger::: Trigger
script dormant f_guns_hallway_ai_music_trigger()

	sleep_until( f_ai_sees_enemy(sg_guns_hallway), 1 );
	//dprint( "::: f_guns_hallway_ai_music_trigger: START :::" );
	thread( f_mus_m80_e08_begin() );

	sleep_until( (f_ai_is_defeated(sg_guns_hallway) and (ai_spawn_count(sg_guns_hallway_upper) > 0)) or (zoneset_current_active() == S_ZONESET_ATRIUM_LOOKOUT), 1 );
	//dprint( "::: f_guns_hallway_ai_music_trigger: FINISH :::" );
	thread( f_mus_m80_e08_finish() );

end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// GUNS: HALLWAY: AI: PHANTOM
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
static long L_guns_hallway_ai_phantom_timer = 0;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_guns_hallway_ai_phantom_init::: Initialize
script dormant f_guns_hallway_ai_phantom_init()
	//dprint( "::: f_guns_hallway_ai_phantom_init :::" );
	
	// setup trigger
	wake( f_guns_hallway_ai_phantom_trigger );

end

// === f_guns_hallway_ai_phantom_deinit::: Deinitialize
script dormant f_guns_hallway_ai_phantom_deinit()
	//dprint( "::: f_guns_hallway_ai_phantom_deinit :::" );

	// kill functions
	kill_script( f_guns_hallway_ai_phantom_init );
	kill_script( f_guns_hallway_ai_phantom_trigger );
	kill_script( f_guns_hallway_ai_phantom_spawn );
	
	// erase ai
	ai_erase( sg_guns_hallway_hub_phantom ); 	

end

// === f_guns_hallway_ai_phantom_trigger::: Trigger
script dormant f_guns_hallway_ai_phantom_trigger()
	//sleep_until( zoneset_current_active() == S_ZONESET_LOOKOUT_HALLWAYS_A, 1 );
	//dprint( "::: f_guns_hallway_ai_phantom_trigger :::" );

	wake( f_guns_hallway_ai_phantom_spawn );

end

// === f_guns_hallway_ai_phantom_spawn::: Spawn
script dormant f_guns_hallway_ai_phantom_spawn()
	//dprint( "::: f_guns_hallway_ai_phantom_spawn :::" );

	ai_place( sg_guns_hallway_hub_phantom ); 

	// put a command script on the turret
	cs_run_command_script( ai_get_turret_ai(sg_guns_hallway_hub_phantom, 0), cs_guns_hallway_ai_phantom_turret );
	
end

// COMMAND_SCRIPTS ------------------------------------------------------------------------------------------------------------------------------------------
// === cs_guns_hallway_ai_phantom::: Command AI
script command_script cs_guns_hallway_ai_phantom()
	//dprint( "$$$ cs_guns_hallway_ai_phantom $$$" );

	cs_abort_on_alert( FALSE );
	cs_abort_on_damage( TRUE );

	// wait for phantom to see players
	sleep_until( (objects_can_see_object(Players(), ai_vehicle_get(ai_current_actor), 20.0)) or (L_guns_hallway_ai_phantom_timer != 0), 1 );
	L_guns_hallway_ai_phantom_timer = timer_stamp( 3.0, 5.0 );

	// leave
	sleep_until( timer_expired(L_guns_hallway_ai_phantom_timer) or (zoneset_current() == S_ZONESET_LOOKOUT_HALLWAYS_B), 1 );
	//dprint( "$$$ cs_guns_hallway_ai_phantom: LEAVING!!! $$$" );
	cs_fly_to( ps_guns_hallway_ai_phantom.exit );
	object_destroy( ai_vehicle_get(ai_current_actor) );

end

// === cs_guns_hallway_ai_phantom::: Command AI
script command_script cs_guns_hallway_ai_phantom_turret()
local long l_timer = 0;
local boolean b_sees_player = FALSE;
	//dprint( "$$$ cs_guns_hallway_ai_phantom_turret $$$" );

	cs_abort_on_alert( FALSE );
	cs_abort_on_damage( TRUE );

	// search area	
	repeat

		l_timer = timer_stamp( 1.0, 2.5 );
		
		b_sees_player = f_ai_sees_player( ai_current_actor, 5.0 );
		
		if ( not b_sees_player ) then
			//dprint( "$$$ cs_guns_hallway_ai_phantom_turret: SEARCHING... $$$" ); 

			begin_random_count( 1 )
			
				cs_aim( TRUE, ps_guns_hallway_ai_phantom.p0 );
				cs_aim( TRUE, ps_guns_hallway_ai_phantom.p1 );
				cs_aim( TRUE, ps_guns_hallway_ai_phantom.p2 );
				cs_aim( TRUE, ps_guns_hallway_ai_phantom.p3 );
				cs_aim( TRUE, ps_guns_hallway_ai_phantom.p4 );
				
			end

		else

			//dprint( "$$$ cs_guns_hallway_ai_phantom_turret: LOCKED PLAYER... $$$" );
			cs_aim_player( TRUE );
			
		end

		sleep_until( timer_expired(l_timer) or (b_sees_player != f_ai_sees_player(ai_current_actor, 5.0)), 1 );
	
	until( zoneset_current() == S_ZONESET_LOOKOUT_HALLWAYS_B, 1 );

end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// GUNS: HALLWAY: AI: HUB
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_guns_hallway_ai_hub_init::: Initialize
script dormant f_guns_hallway_ai_hub_init()
	//dprint( "::: f_guns_hallway_ai_hub_init :::" );
	
	// setup trigger
	wake( f_guns_hallway_ai_hub_trigger );

end

// === f_guns_hallway_ai_hub_deinit::: Deinitialize
script dormant f_guns_hallway_ai_hub_deinit()
	//dprint( "::: f_guns_hallway_ai_hub_deinit :::" );

	// kill functions
	kill_script( f_guns_hallway_ai_hub_init );
	kill_script( f_guns_hallway_ai_hub_trigger );
	//kill_script( f_guns_hallway_ai_hub_spawn );

end

// === f_guns_hallway_ai_hub_trigger::: Trigger
script dormant f_guns_hallway_ai_hub_trigger()
	//sleep_until( zoneset_current_active() == S_ZONESET_LOOKOUT_HALLWAYS_A, 1 );
	//dprint( "::: f_guns_hallway_ai_hub_trigger :::" );

//	wake( f_guns_hallway_ai_hub_spawn );
	ai_place( sg_guns_hallway_hub_enemies ); 

	// ai magically faces
	sleep_until( (f_guns_hallway_started() and volume_test_players(tv_guns_hallway_main_area)) or  (device_get_position(door_turret_hub_enter_maya) >= 1.0), 1 );
	if ( volume_test_players(tv_guns_hallway_main_area) ) then
		f_ai_magically_see_players( sq_guns_hallway_hub_enemies_01 );
	end

end
/*
// === f_guns_hallway_ai_hub_spawn::: Spawn
script dormant f_guns_hallway_ai_hub_spawn()
	//dprint( "::: f_guns_hallway_ai_hub_spawn :::" );

	ai_place( sg_guns_hallway_hub_enemies ); 
	
end
*/


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// GUNS: HALLWAY: AI: LOWER
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_guns_hallway_ai_lower_init::: Initialize
script dormant f_guns_hallway_ai_lower_init()
	//dprint( "::: f_guns_hallway_ai_lower_init :::" );
	
	// setup trigger
	wake( f_guns_hallway_ai_lower_trigger );

end

// === f_guns_hallway_ai_lower_deinit::: Deinitialize
script dormant f_guns_hallway_ai_lower_deinit()
	//dprint( "::: f_guns_hallway_ai_lower_deinit :::" );

	// kill functions
	kill_script( f_guns_hallway_ai_lower_init );
	kill_script( f_guns_hallway_ai_lower_trigger );
	//kill_script( f_guns_hallway_ai_lower_spawn );

end

// === f_guns_hallway_ai_lower_trigger::: Trigger
script dormant f_guns_hallway_ai_lower_trigger()
	sleep_until( f_guns_hallway_return_started(), 1 );
	//dprint( "::: f_guns_hallway_ai_lower_trigger :::" );

	//wake( f_guns_hallway_ai_lower_spawn );
	//sleep( 1 );
	ai_place( sg_guns_hallway_lower ); 

	sleep_until( door_atrium_return_enter_maya->position_open_check(), 1 );
	f_ai_magically_see_players( sg_guns_hallway_lower );

end

script command_script cs_guns_hallway_finale_follow()

	if ( unit_has_weapon(ai_current_actor, "objects\weapons\melee\storm_energy_sword\storm_energy_sword.weapon") and (not unit_has_weapon_readied(ai_current_actor, "objects\weapons\melee\storm_energy_sword\storm_energy_sword.weapon")) ) then
		local long l_timer = 0;
		ai_berserk( ai_current_actor, TRUE );
		l_timer = timer_stamp( 2.0 );
		sleep_until( unit_has_weapon_readied(ai_current_actor, "objects\weapons\melee\storm_energy_sword\storm_energy_sword.weapon") or timer_expired(l_timer), 1 );
	end

	if ( unit_has_equipment(ai_current_actor, "objects\equipment\storm_active_camo\storm_active_camo.equipment") ) then
		dprint( "cs_guns_hallway_finale_follow: CAMO ENABLED" );
		thread( f_active_camo_manager(ai_current_actor) );
	end
	
end

script command_script cs_guns_hallway_finale_showdown()

	if ( unit_has_weapon(ai_current_actor, "objects\weapons\melee\storm_energy_sword\storm_energy_sword.weapon") and (not unit_has_weapon_readied(ai_current_actor, "objects\weapons\melee\storm_energy_sword\storm_energy_sword.weapon")) ) then
		local long l_timer = 0;
		ai_berserk( ai_current_actor, TRUE );
		l_timer = timer_stamp( 2.0 );
		sleep_until( unit_has_weapon_readied(ai_current_actor, "objects\weapons\melee\storm_energy_sword\storm_energy_sword.weapon") or timer_expired(l_timer), 1 );
	end
	
end


/*
// === f_guns_hallway_ai_lower_spawn::: Spawn
script dormant f_guns_hallway_ai_lower_spawn()
	//dprint( "::: f_guns_hallway_ai_lower_spawn :::" );

	ai_place( sg_guns_hallway_lower ); 
	
end
*/


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// GUNS: HALLWAY: AI: UPPER
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_guns_hallway_ai_upper_init::: Initialize
script dormant f_guns_hallway_ai_upper_init()
	//dprint( "::: f_guns_hallway_ai_upper_init :::" );
	
	// setup trigger
	wake( f_guns_hallway_ai_upper_trigger );

end

// === f_guns_hallway_ai_upper_deinit::: Deinitialize
script dormant f_guns_hallway_ai_upper_deinit()
	//dprint( "::: f_guns_hallway_ai_upper_deinit :::" );

	// kill functions
	kill_script( f_guns_hallway_ai_upper_init );
	kill_script( f_guns_hallway_ai_upper_trigger );
	//kill_script( f_guns_hallway_ai_upper_spawn );

end

// === f_guns_hallway_ai_upper_trigger::: Trigger
script dormant f_guns_hallway_ai_upper_trigger()
	sleep_until( f_guns_hallway_return_started(), 1 );
	//dprint( "::: f_guns_hallway_ai_upper_trigger :::" );

	//wake( f_guns_hallway_ai_upper_spawn );
	//sleep( 1 );
	ai_place( sg_guns_hallway_upper ); 

end
/*
// === f_guns_hallway_ai_upper_spawn::: Spawn
script dormant f_guns_hallway_ai_upper_spawn()
	//dprint( "::: f_guns_hallway_ai_upper_spawn :::" );

	ai_place( sg_guns_hallway_upper ); 
	
end
*/
// XXX OLD VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV
script command_script cs_gunshallway_first_sniper()
	//dprint( "$$$ cs_gunshallway_first_sniper $$$" );

	cs_abort_on_damage( TRUE );
	cs_enable_moving( FALSE );
	cs_enable_looking( FALSE );
	cs_push_stance( patrol );
	cs_abort_on_combat_status( ai_combat_status_dangerous );
	sleep_until( f_ai_is_dangerous(sg_guns_hallway_hub_enemies) or (ai_living_count(sg_guns_hallway_hub_enemies) < 3) );

end
