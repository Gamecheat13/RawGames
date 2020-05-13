//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434
;
; Mission: 					m80_delta
;	Insertion Points:	to_guns (or itl)
;										
//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434



// ==========================================================================================================================================================
// ==========================================================================================================================================================
// ==========================================================================================================================================================
// *** GUNS: AI ***
// ==========================================================================================================================================================
// ==========================================================================================================================================================
// ==========================================================================================================================================================

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_guns_ai_init::: Initialize
script dormant f_guns_ai_init()
	//dprint( "::: f_guns_ai_init :::" );
	
	// init sub modules
	wake( f_guns_ai_music_init );
	wake( f_guns_ai_enemies_init );
	wake( f_guns_ai_phantoms_init );
	wake( f_guns_ai_turrets_init );
	wake( f_guns_ai_dead_init );
	wake( f_guns_ai_exterior_init );
	wake( f_guns_ai_scale_init );

end

// === f_guns_ai_deinit::: Deinitialize
script dormant f_guns_ai_deinit()
	//dprint( "::: f_guns_ai_deinit :::" );

	// kill functions
	kill_script( f_guns_ai_init );

	// deinit sub modules
	wake( f_guns_ai_music_deinit );
	wake( f_guns_ai_dead_deinit );
	wake( f_guns_ai_phantoms_deinit );
	wake( f_guns_ai_enemies_deinit );
	wake( f_guns_ai_turrets_deinit );
	wake( f_guns_ai_exterior_deinit );
	wake( f_guns_ai_scale_deinit );
	
	// erase AI
	ai_erase( sg_guns );

end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// GUNS: AI: SCALE
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_guns_ai_scale_init::: Init
script dormant f_guns_ai_scale_init()
	//dprint( "::: f_guns_ai_scale_init :::" );
	
	// setup trigger
	wake( f_guns_ai_scale_trigger );
	
end

// === f_guns_ai_scale_deinit::: Deinit
script dormant f_guns_ai_scale_deinit()
	//dprint( "::: f_guns_ai_scale_deinit :::" );
	
	// kill functions
	kill_script( f_guns_ai_scale_init );
	kill_script( f_guns_ai_scale_trigger );
	kill_script( f_guns_ai_scale_action );
	
end

// === f_guns_ai_scale_trigger::: Trigger
script dormant f_guns_ai_scale_trigger()
	sleep_until( zoneset_current() > S_ZONESET_LOOKOUT_EXIT, 1 );
	//dprint( "::: f_guns_ai_scale_trigger :::" );
	
	// action
	wake( f_guns_ai_scale_action );
	
end

// === f_guns_ai_scale_action::: Action
script dormant f_guns_ai_scale_action()
	//dprint( "::: f_guns_ai_scale_action :::" );

	// scale sub modules
	wake( f_guns_ai_turrets_scale );

	// deinit sub modules
	wake( f_guns_ai_music_deinit );
	wake( f_guns_ai_dead_deinit );
	wake( f_guns_ai_phantoms_deinit );
	wake( f_guns_ai_enemies_deinit );
	wake( f_guns_ai_exterior_deinit );
		
end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// GUNS: AI: MUSIC
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_guns_ai_music_init::: musicize
script dormant f_guns_ai_music_init()
	//dprint( "::: f_guns_ai_music_init :::" );
	
	// setup trigger
	wake( f_guns_ai_music_trigger );

end

// === f_guns_ai_music_deinit::: Demusicize
script dormant f_guns_ai_music_deinit()
	//dprint( "::: f_guns_ai_music_deinit :::" );

	// kill functions
	kill_script( f_guns_ai_music_init );
	kill_script( f_guns_ai_music_trigger );

end

// === f_guns_ai_music_trigger::: Trigger
script dormant f_guns_ai_music_trigger()

	sleep_until( f_ai_sees_enemy(sg_guns_start_elites), 1 );
	//dprint( "::: f_guns_ai_music_trigger: START :::" );
	//thread( f_mus_m80_e07_begin() );

	sleep_until( f_ai_is_defeated(sg_guns_start_elites), 1 );
	//dprint( "::: f_guns_ai_music_trigger: FINISH :::" );
	//thread( f_mus_m80_e07_finish() );

end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// GUNS: AI: ENEMIES
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
global boolean B_guns_elites_agro =				FALSE;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------

// === f_guns_ai_enemies_init::: Initialize
script dormant f_guns_ai_enemies_init()
	//dprint( "::: f_guns_ai_enemies_init :::" );
	
	// setup trigger
	wake( f_guns_ai_enemies_trigger );

end

// === f_guns_ai_enemies_deinit::: Deinitialize
script dormant f_guns_ai_enemies_deinit()
	//dprint( "::: f_guns_ai_enemies_deinit :::" );

	// kill functions
	kill_script( f_guns_ai_enemies_init );
	kill_script( f_guns_ai_enemies_trigger );
	kill_script( f_guns_ai_enemies_spawn );

end

// === f_guns_ai_enemies_trigger::: Trigger
script dormant f_guns_ai_enemies_trigger()
local long l_pup_id = 0;
	sleep_until( TRUE, 1 );
	//dprint( "::: f_guns_ai_enemies_trigger :::" );

	// Spawn
	f_ai_spawn_delay_wait( TRUE, -1 );
	wake( f_guns_ai_enemies_spawn );

	sleep_until( ai_living_count(sg_guns_start_elites) > 0, 1 );
	l_pup_id = pup_play_show( 'pup_guns_elite' );

	sleep_until( volume_test_players(tv_lookout_alert_elites) or (unit_get_shield(sq_guns_room_elite_01) < 1.0) or (unit_get_shield(sq_guns_room_elite_02) < 1.0) or (not pup_is_playing(l_pup_id)) );
	B_guns_elites_agro = TRUE;
	if ( pup_is_playing(l_pup_id) ) then
		pup_stop_show( l_pup_id );
	end
	ai_set_active_camo( sq_guns_room_elite_02, FALSE );
	sleep_s( 1.0 );
	ai_set_active_camo( sq_guns_room_elite_01, FALSE );
	
end

// === f_guns_ai_enemies_spawn::: Spawn
script dormant f_guns_ai_enemies_spawn()
	//dprint( "::: f_guns_ai_enemies_spawn :::" );

	// place
	ai_place( sg_guns_start_elites );
	ai_set_active_camo( sg_guns_start_elites, TRUE );
	ai_set_equipment_drop_rate( sq_guns_room_elite_01, 1.0 );	
	ai_set_equipment_drop_rate( sq_guns_room_elite_02, 0.0 );	

end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// GUNS: AI: DEAD
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------

// === f_guns_ai_dead_init::: Initialize
script dormant f_guns_ai_dead_init()
	//dprint( "::: f_guns_ai_dead_init :::" );
	
	// setup trigger
	wake( f_guns_ai_dead_trigger );

end

// === f_guns_ai_dead_deinit::: Deinitialize
script dormant f_guns_ai_dead_deinit()
	//dprint( "::: f_guns_ai_dead_deinit :::" );

	// kill functions
	kill_script( f_guns_ai_dead_init );
	kill_script( f_guns_ai_dead_trigger );
	kill_script( f_guns_ai_dead_spawn );

end

// === f_guns_ai_dead_trigger::: Trigger
script dormant f_guns_ai_dead_trigger()
	//dprint( "::: f_guns_ai_dead_trigger :::" );

	// Spawn
	wake( f_guns_ai_dead_spawn );

end

// === f_guns_ai_dead_spawn::: Spawn
script dormant f_guns_ai_dead_spawn()
	//dprint( "::: f_guns_ai_dead_spawn :::" );

	object_create( bpd_lookout_dead_01 );
	pup_play_show( 'pup_lookout_dead_01' ); 

	object_create( bpd_lookout_dead_02 );
	pup_play_show( 'pup_lookout_dead_02' ); 

	object_create( bpd_lookout_dead_03 );
	pup_play_show( 'pup_lookout_dead_03' ); 
	
end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// GUNS: AI: EXTERIOR
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
static short S_guns_ai_exterior_human_low =							3;
static short S_guns_ai_exterior_human_min =							4;
static short S_guns_ai_exterior_human_max	= 						6;

static short S_guns_ai_exterior_enemy_low	=							3;
static short S_guns_ai_exterior_enemy_min	=							4;
static short S_guns_ai_exterior_enemy_max	= 						6;
//static short S_guns_ai_exterior_enemy_min	=							6;
//static short S_guns_ai_exterior_enemy_max	= 						8;

global short S_guns_ai_exterior_phantom_drop_seat =			0;
global unit U_guns_ai_exterior_phantom = 								NONE;
global boolean B_guns_ai_exterior_use_phantoms =				TRUE;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_guns_ai_exterior_init::: exteriorize
script dormant f_guns_ai_exterior_init()
	//dprint( "::: f_guns_ai_exterior_init :::" );
	
	// setup trigger
	wake( f_guns_ai_exterior_trigger );

end

// === f_guns_ai_exterior_deinit::: Deexteriorize
script dormant f_guns_ai_exterior_deinit()
	//dprint( "::: f_guns_ai_exterior_deinit :::" );

	// erase ai
	ai_erase( sg_guns_exterior );

	// kill functions
	kill_script( f_guns_ai_exterior_init );
	kill_script( f_guns_ai_exterior_trigger );
	kill_script( f_guns_ai_exterior_action );
	kill_script( f_guns_ai_exterior_garbage );
	kill_script( f_guns_ai_exterior_garbage_manage );
	kill_script( f_guns_ai_exterior_recycle_humans );
	kill_script( f_guns_ai_exterior_recycle_enemies );

end

// === f_guns_ai_exterior_trigger::: Trigger
script dormant f_guns_ai_exterior_trigger()
	sleep_until( f_guns_started(), 1 );
	//dprint( "::: f_guns_ai_exterior_trigger :::" );

	wake( f_guns_ai_exterior_action );

end

// === f_guns_ai_exterior_action::: Action
script dormant f_guns_ai_exterior_action()
	//dprint( "::: f_guns_ai_exterior_action :::" );

	// start recycler
	wake( f_guns_ai_exterior_recycle_humans );
	wake( f_guns_ai_exterior_recycle_enemies );
	wake( f_guns_ai_exterior_garbage );

end

// === f_guns_ai_exterior_action::: Action
script dormant f_guns_ai_exterior_garbage()
	//dprint( "f_guns_ai_exterior_garbage" );
		
	thread( f_guns_ai_exterior_garbage_manage(tv_lookout_garbage_main, 10, 10) );
	//thread( f_guns_ai_exterior_garbage_manage(tv_lookout_garbage_right, 3, 1) );
	//thread( f_guns_ai_exterior_garbage_manage(tv_lookout_garbage_left, 3, 1) );
	thread( f_guns_ai_exterior_garbage_manage(tv_lookout_garbage_above, 0, 1) );
	thread( f_guns_ai_exterior_garbage_manage(tv_lookout_garbage_below, 0, 1) );
	//thread( f_guns_ai_exterior_garbage_manage(tv_lookout_garbage_far, 0, 1) );
	thread( f_guns_ai_exterior_garbage_manage(tv_lookout_garbage_top, 0, 1) );
	
end

script static void f_guns_ai_exterior_garbage_manage( trigger_volume tv_garbage, long l_cnt, long l_time )

	repeat
		//dprint( "f_guns_ai_exterior_garbage_manage" );
		add_recycling_volume( tv_garbage, l_cnt, l_time );
		sleep_s( l_time );
		
	until( zoneset_current() > S_ZONESET_LOOKOUT_HALLWAYS_B, 1 );

end


// === f_guns_ai_exterior_recycle_humans::: Recycler
script dormant f_guns_ai_exterior_recycle_humans()
local short s_team_min = 0;
local ai ai_spawn = NONE;
	//dprint( "::: f_guns_ai_exterior_recycle_humans :::" );

	// set allegiance
	//ai_allegiance( player, human );

	repeat

		// wait for min threshold
		sleep_until( ai_living_count(sg_guns_exterior_humans) <= S_guns_ai_exterior_human_low, 1 );
	
		// collect garbage
		//garbage_collect_now(); XXX
		
		// humans
		s_team_min = random_range( S_guns_ai_exterior_human_min, S_guns_ai_exterior_human_max + f_ai_killed_cnt(sg_guns_start_elites) );
		
		if ( ai_living_count(sg_guns_exterior_humans) < s_team_min ) then
		
			// populate ai
			repeat
				// find a free ai
				begin_random_count( 1 )
					ai_spawn = f_guns_ai_exterior_spawn( sq_guns_exterior_marines_01 );
					ai_spawn = f_guns_ai_exterior_spawn( sq_guns_exterior_marines_02 );
					ai_spawn = f_guns_ai_exterior_spawn( sq_guns_exterior_marines_03 );
					ai_spawn = f_guns_ai_exterior_spawn( sq_guns_exterior_marines_04 );
				end

				// place ai
				if ( ai_spawn != NONE ) then
					f_ai_spawn_delay_wait( TRUE, -1 );
					ai_place( ai_spawn, 2 );
				end
				
			until ( ai_living_count(sg_guns_exterior_humans) >= s_team_min, f_ai_spawn_delay_default_get() );
		end
	
	until ( FALSE, 1 );

end

// === f_guns_ai_exterior_recycle_enemies::: Recycler
script dormant f_guns_ai_exterior_recycle_enemies()
local short s_team_min = 0;
local ai ai_spawn = NONE;
local boolean b_squad_01_spawned = FALSE;
local boolean b_squad_02_spawned = FALSE;
local boolean b_squad_03_spawned = FALSE;
local boolean b_squad_04_spawned = FALSE;
local boolean b_squad_05_spawned = FALSE;
local long l_phantom_timeout = 0;
	//dprint( "::: f_guns_ai_exterior_recycle_enemies :::" );

	// wait for the first drop to finish
	sleep_until( ai_living_count(sg_guns_start_phantoms) <= 0, 1 );
	
	repeat

		// wait for min threshold
		sleep_until( (ai_vehicle_count(sg_guns_exterior_phantoms) <= 0) and (ai_living_count(sg_guns_exterior_enemies) <= S_guns_ai_exterior_enemy_low), 1 );
		
		// collect garbage
		// garbage_collect_now(); XXX
	
		// enemies
		s_team_min = random_range( S_guns_ai_exterior_enemy_min, S_guns_ai_exterior_enemy_max ) - ai_living_count( sg_guns_exterior_enemies );

		if ( s_team_min > 0 ) then

			// create a new phantom
			if ( B_guns_ai_exterior_use_phantoms ) then
			
				//dprint( "::: f_guns_ai_exterior_recycle_enemies: PHANTOM :::" );
				
				// wait for delay timer
				f_ai_spawn_delay_wait( TRUE, -1 );
				
				// reset variables
				U_guns_ai_exterior_phantom = NONE;
				
				begin_random_count( 1 )
					begin
						ai_place( sq_guns_exterior_phantom_01 );
	//dprint( "SET TEAM: f_guns_ai_exterior_recycle_enemies" );
						ai_set_team( sq_guns_exterior_phantom_01, covenant );
					end
					begin
						ai_place( sq_guns_exterior_phantom_02 );
	//dprint( "SET TEAM: f_guns_ai_exterior_recycle_enemies" );
						ai_set_team( sq_guns_exterior_phantom_02, covenant );
					end
				end
				
				// start timeout timer
				l_phantom_timeout = timer_stamp( 3.0 );
					
				// wait for the vehicle to become valid
				sleep_until( (U_guns_ai_exterior_phantom != NONE) or timer_expired(l_phantom_timeout), 1 );
				
			end

			// reset spawned
			b_squad_01_spawned = FALSE;
			b_squad_02_spawned = FALSE;
			b_squad_03_spawned = FALSE;
			b_squad_04_spawned = FALSE;
			b_squad_05_spawned = FALSE;
	
			// place ai
			repeat

				ai_spawn = NONE;

				begin_random_count( 1 )
					begin
						if ( not b_squad_01_spawned ) then
							ai_spawn = f_guns_ai_exterior_spawn( sq_guns_exterior_enemies_01 );
							b_squad_01_spawned = TRUE;
						end
					end
					begin
						if ( not b_squad_02_spawned ) then
							ai_spawn = f_guns_ai_exterior_spawn( sq_guns_exterior_enemies_02 );
							b_squad_02_spawned = TRUE;
						end
					end
					begin
						if ( not b_squad_03_spawned ) then
							ai_spawn = f_guns_ai_exterior_spawn( sq_guns_exterior_enemies_03 );
							b_squad_03_spawned = TRUE;
						end
					end
					begin
						if ( not b_squad_04_spawned ) then
							ai_spawn = f_guns_ai_exterior_spawn( sq_guns_exterior_enemies_04 );
							b_squad_04_spawned = TRUE;
						end
					end
					begin
						if ( not b_squad_05_spawned ) then
							ai_spawn = f_guns_ai_exterior_spawn( sq_guns_exterior_enemies_05 );
							b_squad_05_spawned = TRUE;
						end
					end
				end

				if ( ai_spawn != NONE ) then

					f_ai_spawn_delay_wait( TRUE, -1 );

					// load the ai
					if ( (U_guns_ai_exterior_phantom != NONE) and (S_guns_ai_exterior_phantom_drop_seat < 4) ) then
						//dprint( "::: f_guns_ai_exterior_recycle_enemies: LOADING :::" );
	
						S_guns_ai_exterior_phantom_drop_seat = S_guns_ai_exterior_phantom_drop_seat + 1;
				
						if ( S_guns_ai_exterior_phantom_drop_seat == 1 ) then
							//dprint( "::: f_guns_ai_exterior_recycle_enemies: LOADING: 1 :::" );
							f_load_phantom_dual( U_guns_ai_exterior_phantom, ai_spawn, NONE, NONE, NONE, TRUE );
						end
						if ( S_guns_ai_exterior_phantom_drop_seat == 2 ) then
							//dprint( "::: f_guns_ai_exterior_recycle_enemies: LOADING: 2 :::" );
							f_load_phantom_dual( U_guns_ai_exterior_phantom, NONE, ai_spawn, NONE, NONE, TRUE );
						end
						if ( S_guns_ai_exterior_phantom_drop_seat == 3 ) then
							//dprint( "::: f_guns_ai_exterior_recycle_enemies: LOADING: 3 :::" );
							f_load_phantom_dual( U_guns_ai_exterior_phantom, NONE, NONE, ai_spawn, NONE, TRUE );
						end
						if ( S_guns_ai_exterior_phantom_drop_seat == 4 ) then
							//dprint( "::: f_guns_ai_exterior_recycle_enemies: LOADING: 4 :::" );
							f_load_phantom_dual( U_guns_ai_exterior_phantom, NONE, NONE, NONE, ai_spawn, TRUE );
						end
					
					else
						//dprint( "::: f_guns_ai_exterior_recycle_enemies: PLACING :::" );
						
						ai_place( ai_spawn );
						
					end

					// decrement counter
					s_team_min = s_team_min - 3;

				end
					
			until ( s_team_min <= 0, 1 );

			// tell the phantom he no longer needs to wait
			//B_guns_ai_exterior_phantom_wait = FALSE;
			
		end
	
	until ( FALSE, 1 );

end

// === f_guns_ai_exterior_spawn::: Checks if the AI can be spawned
script static ai f_guns_ai_exterior_spawn( ai ai_squad )
local ai ai_return = NONE;
	//dprint( "::: f_guns_ai_exterior_spawn :::" );

	// check if needs to be spawned
	if ( ai_living_count(ai_squad) <= 0 ) then
		//dprint( "::: f_guns_ai_exterior_spawn :::" );
		ai_return = ai_squad;
	end
	
	// return
	ai_return;
	
end

// === f_guns_ai_exterior_spawn::: Checks if the AI can be spawned
script static void f_guns_ai_exterior_phantom_enemy_set( ai ai_phantom, real r_chance, real r_delay_min, real r_delay_max )
	//dprint( "::: f_guns_ai_exterior_phantom_enemy_set :::" );

	if ( r_chance < 0.0 ) then
		r_chance = 50.0;
	end
	if ( r_delay_min < 0.0 ) then
		r_delay_min = 0.0;
	end
	if ( r_delay_max < 0.0 ) then
		r_delay_max = 2.5;
	end

	if ( f_chance(r_chance) ) then
		local long l_timer = timer_stamp( r_delay_min, r_delay_max );

		sleep_until( timer_expired(l_timer) or (ai_living_count(ai_phantom) <= 0), 1 );
		if ( ai_living_count(ai_phantom) > 0 ) then
			//dprint( "::: f_guns_ai_exterior_phantom_enemy_set: SET :::" );
			ai_set_team( ai_phantom, mule );
		end
	end

end

// COMMAND_SCRIPTS ------------------------------------------------------------------------------------------------------------------------------------------
// === cs_guns_ai_exterior_init::: Command AI
script command_script cs_guns_ai_exterior_init()
	//dprint( "$$$ cs_guns_ai_exterior_init $$$" );
	unit_doesnt_drop_items( ai_get_unit(ai_current_actor) );
end

// === cs_guns_ai_exterior_phantom_01::: Command AI
script command_script cs_guns_ai_exterior_phantom_01()
local boolean b_drop = FALSE;
	//dprint( "$$$ cs_guns_ai_exterior_phantom_01 $$$" );

	// set the phantom object
	//B_guns_ai_exterior_phantom_wait = TRUE;
	S_guns_ai_exterior_phantom_drop_seat = 0;
	U_guns_ai_exterior_phantom = ai_vehicle_get( ai_current_actor );

//	sleep_until( (not B_guns_ai_exterior_phantom_wait) and (S_guns_ai_exterior_phantom_drop_seat != 0), 1 );
	sleep_until( S_guns_ai_exterior_phantom_drop_seat != 0, 1 );
	b_drop = TRUE;

	cs_fly_to( ps_guns_exterior_phantom_01.p0 );	
	
	// initial chance to set the phantom to be an enemy of the turrets
	//thread( f_guns_ai_exterior_phantom_enemy_set(ai_get_squad(ai_current_actor), 10.0, -1.0, -1.0) );

	cs_fly_by( ps_guns_exterior_phantom_01.p1 );
	begin_random_count( 1 )
		cs_fly_to( ps_guns_exterior_phantom_01.p2_a );
		cs_fly_to( ps_guns_exterior_phantom_01.p2_b );
	end
	
	if ( b_drop and (zoneset_current() < S_ZONESET_LOOKOUT_HALLWAYS_A) ) then
		S_guns_ai_exterior_phantom_drop_seat = 5;
		sleep_s( 0.25, 0.75 );
		f_unload_phantom ( ai_vehicle_get(ai_current_actor), "dual" );
		sleep_s( 0.25, 0.75 );
	end
	
	// set the phantom to be an enemy of the turrets
	thread( f_guns_ai_exterior_phantom_enemy_set(ai_get_squad(ai_current_actor), -1.0, -1.0, -1.0) );
	
	cs_fly_to( ps_guns_exterior_phantom_01.p3 );	
	f_guns_ai_exterior_phantom_enemy_set( ai_get_squad(ai_current_actor), 100.0, 0.0, 0.0 );
	cs_fly_by( ps_guns_exterior_phantom_01.p4 );
	cs_fly_by( ps_guns_exterior_phantom_01.p5 );
	cs_fly_to( ps_guns_exterior_phantom_01.p6 );
	object_destroy( ai_vehicle_get(ai_current_actor) );

end

// === cs_guns_ai_exterior_phantom_02::: Command AI
script command_script cs_guns_ai_exterior_phantom_02()
local boolean b_drop = FALSE;
	//dprint( "$$$ cs_guns_ai_exterior_phantom_02 $$$" );

	// set the phantom object
	//B_guns_ai_exterior_phantom_wait = TRUE;
	S_guns_ai_exterior_phantom_drop_seat = 0;
	U_guns_ai_exterior_phantom = ai_vehicle_get( ai_current_actor );

//	sleep_until( (not B_guns_ai_exterior_phantom_wait) and (S_guns_ai_exterior_phantom_drop_seat != 0), 1 );
	sleep_until( S_guns_ai_exterior_phantom_drop_seat != 0, 1 );
	b_drop = TRUE;

	cs_fly_to( ps_guns_exterior_phantom_02.p0 );	
	
	// initial chance to set the phantom to be an enemy of the turrets
	//thread( f_guns_ai_exterior_phantom_enemy_set(ai_get_squad(ai_current_actor), 10.0, -1.0, -1.0) );

	cs_fly_by( ps_guns_exterior_phantom_02.p1 );
	begin_random_count( 1 )
		cs_fly_to( ps_guns_exterior_phantom_02.p2_a );
		cs_fly_to( ps_guns_exterior_phantom_02.p2_b );
		cs_fly_to( ps_guns_exterior_phantom_02.p2_c );
	end

	if ( b_drop and (zoneset_current() < S_ZONESET_LOOKOUT_HALLWAYS_A) ) then
		S_guns_ai_exterior_phantom_drop_seat = 5;
		sleep_s( 0.25, 0.75 );
		f_unload_phantom ( ai_vehicle_get(ai_current_actor), "dual" );
		sleep_s( 0.25, 0.75 );
	end
	
	// set the phantom to be an enemy of the turrets
	thread( f_guns_ai_exterior_phantom_enemy_set(ai_get_squad(ai_current_actor), -1.0, -1.0, -1.0) );
	
	cs_fly_by( ps_guns_exterior_phantom_02.p3 );
	f_guns_ai_exterior_phantom_enemy_set( ai_get_squad(ai_current_actor), 100.0, 0.0, 0.0 );
	begin_random_count( 1 )
		cs_fly_to( ps_guns_exterior_phantom_02.p4_a );	
		cs_fly_to( ps_guns_exterior_phantom_02.p4_b );	
	end
	cs_fly_by( ps_guns_exterior_phantom_02.p5 );
	cs_fly_to( ps_guns_exterior_phantom_02.p6 );
	object_destroy( ai_vehicle_get(ai_current_actor) );

end

// === cs_guns_ai_exterior_phantom_gunner_init::: Command AI
script command_script cs_guns_ai_exterior_phantom_gunner_init()
	//dprint( "$$$ cs_guns_ai_exterior_phantom_gunner_init $$$" );
	ai_cannot_die( ai_current_actor, TRUE );
end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// GUNS: AI: PHANTOMS
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
static boolean B_guns_ai_phantoms_start = FALSE;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_guns_ai_phantoms_init::: Initialize
script dormant f_guns_ai_phantoms_init()
	//dprint( "::: f_guns_ai_phantoms_init :::" );
	
	// setup trigger
	wake( f_guns_ai_phantoms_trigger );

end

// === f_guns_ai_phantoms_deinit::: Deinitialize
script dormant f_guns_ai_phantoms_deinit()
	//dprint( "::: f_guns_ai_phantoms_deinit :::" );

	// kill functions
	kill_script( f_guns_ai_phantoms_init );
	kill_script( f_guns_ai_phantoms_trigger );
	kill_script( f_guns_ai_phantoms_spawn );

end

// === f_guns_ai_phantoms_trigger::: Trigger
script dormant f_guns_ai_phantoms_trigger()
	//sleep_until( f_guns_started(), 1 );
	//dprint( "::: f_guns_ai_phantoms_trigger :::" );

	wake( f_guns_ai_phantoms_spawn );

end

// === f_guns_ai_phantoms_spawn::: Spawn
script dormant f_guns_ai_phantoms_spawn()
	//dprint( "::: f_guns_ai_phantoms_spawn :::" );

	// Spawn Phantom
	f_ai_spawn_delay_wait( TRUE, seconds_to_frames(0.5) );
	ai_place( sq_guns_phantom_start_01 );

	f_ai_spawn_delay_wait( TRUE, seconds_to_frames(0.5) );
	ai_place( sq_guns_phantom_start_02 );

//	f_ai_spawn_delay_wait( TRUE, seconds_to_frames(0.5) );
//	ai_place( sq_guns_phantom_start_03 );
	
end

// COMMAND_SCRIPTS ------------------------------------------------------------------------------------------------------------------------------------------
// === cs_lookout_phantom1::: Command AI
script command_script cs_lookout_phantom1()
	//dprint( "$$$ cs_lookout_phantom1 $$$" );

	// Load Phantom 01
	f_ai_spawn_delay_wait( TRUE, -1 );
	f_load_phantom_dual( ai_vehicle_get(ai_current_actor), sq_guns_exterior_enemies_01.elite_01, sq_guns_exterior_enemies_02.jackal_01, sq_guns_exterior_enemies_02.elite_01, sq_guns_exterior_enemies_01.grunt_01, TRUE );

	sleep_until( B_guns_ai_phantoms_start or f_guns_entered() or objects_can_see_object(Players(),ai_vehicle_get(ai_current_actor), 15.0), 1 );
	B_guns_ai_phantoms_start = TRUE;
	sleep_s( 0.25, 0.75 );
	f_unload_phantom ( ai_vehicle_get(ai_current_actor), "dual" );
	sleep_s( 1.0, 1.5 );
	cs_fly_to( ps_lookout_phantom1.p0 );	
	cs_fly_by( ps_lookout_phantom1.p1 );
	f_guns_ai_exterior_phantom_enemy_set( ai_get_squad(ai_current_actor), 100.0, 0.0, 0.0 );
	cs_fly_to( ps_lookout_phantom1.p2 );
	object_destroy( ai_vehicle_get(ai_current_actor) );

end

// === cs_lookout_phantom2::: Command AI
script command_script cs_lookout_phantom2()
	//dprint( "$$$ cs_lookout_phantom2 $$$" );

	// Load Phantom 02
	f_ai_spawn_delay_wait( TRUE, -1 );
	f_load_phantom_left( ai_vehicle_get(ai_current_actor), sq_guns_exterior_enemies_03.elite_01, sq_guns_exterior_enemies_03.jackal_01, sq_guns_exterior_enemies_04.jackal_01, sq_guns_exterior_enemies_04.grunt_01, TRUE );

	sleep_until( B_guns_ai_phantoms_start or f_guns_entered() or objects_can_see_object(Players(),ai_vehicle_get(ai_current_actor), 15.0), 1 );
	B_guns_ai_phantoms_start = TRUE;
	sleep_s( 1.5, 2.5 );
	f_unload_phantom ( ai_vehicle_get(ai_current_actor), "left" );
	sleep_s( 1.5, 2.5 );
	cs_fly_to_and_face( ps_lookout_phantom2.p0, ps_lookout_phantom2.p0_face );
	cs_fly_to_and_face( ps_lookout_phantom2.p0, ps_lookout_phantom2.p1 );
	sleep_s( 0.5 );
	cs_fly_by( ps_lookout_phantom2.p1 );
	cs_fly_to( ps_lookout_phantom2.p2 );
	cs_fly_by( ps_lookout_phantom2.p3 );
	f_guns_ai_exterior_phantom_enemy_set( ai_get_squad(ai_current_actor), 100.0, 0.0, 0.0 );
	cs_fly_to( ps_lookout_phantom2.p4 );
	object_destroy( ai_vehicle_get( ai_current_actor ) );

end

// === cs_lookout_phantom3::: Command AI
script command_script cs_lookout_phantom3()
	//dprint( "$$$ cs_lookout_phantom3 $$$" );

	sleep_until( B_guns_ai_phantoms_start or f_guns_entered(), 1 );
	B_guns_ai_phantoms_start = TRUE;
	object_set_scale( ai_vehicle_get( ai_current_actor ), 0.01, 0 );
	sleep_s( 6.5 );
	object_set_scale( ai_vehicle_get( ai_current_actor ), 1.0, 120 );
	cs_fly_by( ps_lookout_phantom3.p0 );	
	cs_fly_to( ps_lookout_phantom3.p1 );
	cs_fly_by( ps_lookout_phantom3.p2 );	
	f_guns_ai_exterior_phantom_enemy_set( ai_get_squad(ai_current_actor), 100.0, 0.0, 0.0 );
	cs_fly_to( ps_lookout_phantom3.p3 );
	object_destroy( ai_vehicle_get( ai_current_actor ) );

end

	

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// GUNS: AI: TURRETS
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
global boolean B_guns_turrets_reactivated = 						FALSE;
global boolean B_guns_turrets_fired = 									FALSE;
global short s_guns_turrets_target_lives = 							-1;
global short s_guns_turrets_target_min =								2;
global short s_guns_turrets_target_max =								3;
global real s_guns_turrets_target_delay_min =						0.75;
global real s_guns_turrets_target_delay_max =						1.50;
global real R_guns_turrets_load_delay_min = 						1.0;
global real R_guns_turrets_load_delay_max = 						1.5;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------

// === f_guns_ai_turrets_init::: Initialize
script dormant f_guns_ai_turrets_init()
	//dprint( "::: f_guns_ai_turrets_init :::" );

	// force early turret allegiance
	ai_allegiance( spare, player );
	
	// setup trigger
	wake( f_guns_ai_turrets_trigger );

end

// === f_guns_ai_turrets_deinit::: Deinitialize
script dormant f_guns_ai_turrets_deinit()
	//dprint( "::: f_guns_ai_turrets_deinit :::" );
	
	// kill functions
	kill_script( f_guns_ai_turrets_init );
	kill_script( f_guns_ai_turrets_trigger );
	kill_script( f_guns_ai_turrets_spawn );
//	kill_script( f_guns_ai_turrets_spawn_near );
//	kill_script( f_guns_ai_turrets_spawn_far );
	kill_script( f_guns_ai_turrets_action );
	kill_script( f_guns_ai_turrets_scale );

end

// === f_guns_ai_turrets_scale::: Scale
script dormant f_guns_ai_turrets_scale()
	//dprint( "::: f_guns_ai_turrets_scale :::" );

	// scale down some variables
	s_guns_turrets_target_lives = 10;
	s_guns_turrets_target_min =		1;
	s_guns_turrets_target_max =		2;
	s_guns_turrets_target_delay_min = s_guns_turrets_target_delay_min * 3;
	s_guns_turrets_target_delay_max = s_guns_turrets_target_delay_max * 5;

end

// === f_guns_ai_turrets_trigger::: Trigger
script dormant f_guns_ai_turrets_trigger()
	sleep_until( B_guns_turrets_reactivated, 1 );
	//dprint( "::: f_guns_ai_turrets_trigger :::" );

	// Spawn
	wake( f_guns_ai_turrets_spawn );

end

// === f_guns_ai_turrets_spawn_load::: Spawn and Load
script static void f_guns_ai_turrets_spawn_load( ai ai_gunner, vehicle v_turret )

	ai_place( ai_gunner );
	object_cannot_take_damage( ai_actors(ai_gunner) );
	object_cannot_take_damage( v_turret );
	sleep_s( R_guns_turrets_load_delay_min, R_guns_turrets_load_delay_min );
	unit_enter_vehicle_immediate( ai_gunner, v_turret, 'mac_d' );

end

// === f_guns_ai_turrets_spawn::: Spawn
script dormant f_guns_ai_turrets_spawn()
	//dprint( "::: f_guns_ai_turrets_spawn :::" );

/*
	wake( f_guns_ai_turrets_spawn_near );
	wake( f_guns_ai_turrets_spawn_far );
*/

	f_ai_spawn_delay_wait( TRUE, -1 );

	// near
	f_guns_ai_turrets_spawn_load( sq_guns_turret_gunner_01.gunner, v_guns_turret_back_left_01 );
	//f_guns_ai_turrets_spawn_load( sq_guns_turret_gunner_02.gunner, v_guns_turret_back_mid_01 );
	f_guns_ai_turrets_spawn_load( sq_guns_turret_gunner_03.gunner, v_guns_turret_back_right_01 );

	// distance
	f_guns_ai_turrets_spawn_load( sq_guns_turret_gunner_04.gunner, v_guns_turret_front_left_01 );
	//f_guns_ai_turrets_spawn_load( sq_guns_turret_gunner_01.gun2, v_guns_turret_front_left_02 );
	f_guns_ai_turrets_spawn_load( sq_guns_turret_gunner_05.gunner, v_guns_turret_front_right_01 );
	
end

/*
// === f_guns_ai_turrets_spawn_near::: Spawn
script dormant f_guns_ai_turrets_spawn_near()
	//dprint( "::: f_guns_ai_turrets_spawn_far :::" );

	f_ai_spawn_delay_wait( TRUE, -1 );

	f_guns_ai_turrets_spawn_load( sq_guns_turret_gunner_01.gun1, v_guns_turret_front_left_01 );
	//f_guns_ai_turrets_spawn_load( sq_guns_turret_gunner_01.gun2, v_guns_turret_front_left_02 );
	f_guns_ai_turrets_spawn_load( sq_guns_turret_gunner_01.gun3, v_guns_turret_front_right_01 );

end

// === f_guns_ai_turrets_spawn_far::: Spawn
script dormant f_guns_ai_turrets_spawn_far()
	//dprint( "::: f_guns_ai_turrets_spawn_far :::" );

	f_ai_spawn_delay_wait( TRUE, -1 );

	f_guns_ai_turrets_spawn_load( sq_guns_turret_gunner_02.gun4, v_guns_turret_back_left_01 );
	f_guns_ai_turrets_spawn_load( sq_guns_turret_gunner_02.gun5, v_guns_turret_back_mid_01 );
	f_guns_ai_turrets_spawn_load( sq_guns_turret_gunner_02.gun6, v_guns_turret_back_right_01 );
end
*/

// === f_guns_ai_turrets_action::: Action
// 	NOTE: Triggered in puppeteer
script dormant f_guns_ai_turrets_action()
local short s_target_cnt =		0;
local ai ai_spawn = 					NONE;
	//dprint( "::: f_guns_ai_turrets_action :::" );

	// Increase AI LOD	
	ai_lod_full_detail_actors( 24 );

	// set allegiance
	ai_allegiance( spare, human );
	ai_allegiance( spare, covenant );
	ai_allegiance( spare, player );
	ai_allegiance( mule, covenant );
	
	// watch for the turrets to fire
	thread( f_guns_ai_turrets_fired_watch() );

	repeat

		// wait for the need to spawn
		sleep_until( ai_living_count(sg_guns_turrets_targets) < s_guns_turrets_target_min, 1 );

		// collect garbage
		// garbage_collect_now(); XXX
		
		s_target_cnt = random_range( s_guns_turrets_target_min, s_guns_turrets_target_max ) - ai_living_count( sg_guns_turrets_targets );
		repeat

			if ( ai_spawn_count(sg_guns_turrets_targets) > 0 ) then
				sleep_s( s_guns_turrets_target_delay_min, s_guns_turrets_target_delay_max );
			end
			
			// spawn while preventing double spawning the same one
			begin_random_count( 1 )
				ai_spawn = f_guns_ai_exterior_spawn( sq_guns_turret_targets_01.01 );
				ai_spawn = f_guns_ai_exterior_spawn( sq_guns_turret_targets_01.02 );
				ai_spawn = f_guns_ai_exterior_spawn( sq_guns_turret_targets_01.03 );
				ai_spawn = f_guns_ai_exterior_spawn( sq_guns_turret_targets_01.04 );
				ai_spawn = f_guns_ai_exterior_spawn( sq_guns_turret_targets_01.05 );
				ai_spawn = f_guns_ai_exterior_spawn( sq_guns_turret_targets_01.06 );
				ai_spawn = f_guns_ai_exterior_spawn( sq_guns_turret_targets_01.07 );
				ai_spawn = f_guns_ai_exterior_spawn( sq_guns_turret_targets_01.08 );
			end
		
			if ( ai_spawn != NONE ) then
				// place a targets
				ai_place( ai_spawn );
				s_target_cnt = s_target_cnt - 1;
			
				// decrement lives counter
				if ( s_guns_turrets_target_lives > 0 ) then
					s_guns_turrets_target_lives = s_guns_turrets_target_lives - 1;
				end
			end
			
		until( (s_target_cnt <= 0) or (s_guns_turrets_target_lives == 0), 1 );
	
	until( s_guns_turrets_target_lives == 0, 1 );

end

// === f_guns_ai_turrets_target::: AI
script command_script f_guns_ai_turrets_target()
local real r_time = real_random_range( 2.0, 3.0 );
	//dprint( "$$$ f_guns_ai_turrets_target $$$" );

	// temporarily disregard me
	ai_disregard( ai_vehicle_get(ai_current_actor), TRUE );
	object_cannot_die( ai_vehicle_get(ai_current_actor), TRUE );

	// scale down
	object_set_scale( ai_vehicle_get(ai_current_actor), 0.01, 0 );

	// delay start
	sleep_s( 0.5, 2.5 );
	
	// scale in
	object_set_scale( ai_vehicle_get( ai_current_actor ), 1.0, seconds_to_frames( r_time ) );
	sleep_s( r_time * 0.25 );

	thread( f_guns_ai_target_make_vulnerable( ai_current_actor, 1.5, 2.5) );
	/*
	if ( B_guns_turrets_fired ) then
		thread( f_guns_ai_target_make_vulnerable( ai_current_actor, 0.0, 0.0) );
	else
	end
	*/

	// fly by mid point
	begin_random_count( 1 )
		cs_fly_by( ps_guns_ai_target_destinations.mid_01 );
		cs_fly_by( ps_guns_ai_target_destinations.mid_02 );
		cs_fly_by( ps_guns_ai_target_destinations.mid_03 );
		cs_fly_by( ps_guns_ai_target_destinations.mid_04 );
		cs_fly_by( ps_guns_ai_target_destinations.mid_05 );
		cs_fly_by( ps_guns_ai_target_destinations.mid_06 );
		cs_fly_by( ps_guns_ai_target_destinations.mid_07 );
	end

	// fly to end point
	begin_random_count( 1 )
		cs_fly_to( ps_guns_ai_target_destinations.end_01 );
		cs_fly_to( ps_guns_ai_target_destinations.end_02 );
		cs_fly_to( ps_guns_ai_target_destinations.end_03 );
		cs_fly_to( ps_guns_ai_target_destinations.end_04 );
		cs_fly_to( ps_guns_ai_target_destinations.end_05 );
	end

	// force phantom destruction
	sleep_s( 0.5, 2.5 );
	f_phantom_destroy( ai_vehicle_get(ai_current_actor) );

end

script static void f_guns_ai_target_make_vulnerable( ai ai_target, real r_time_min, real r_time_max )

	// delay
	//sleep_s( r_time_min, r_time_max );
	//dprint( "::: f_guns_ai_target_make_vulnerable :::" );
	//inspect( 

	//dprint( "SET TEAM: f_guns_ai_target_make_vulnerable" );
	ai_set_team( ai_get_squad(ai_target), mule );
	
	// force magic sees
	ai_magically_see( ai_target, sg_guns_turrets );
	ai_magically_see( sg_guns_turrets, ai_target );
	
	// regard me
	ai_disregard( ai_vehicle_get(ai_target), FALSE );
	object_cannot_die( ai_vehicle_get(ai_target), FALSE );
	
	if ( not B_guns_turrets_fired ) then
		local real r_health = object_get_health( ai_vehicle_get(ai_target) );
		sleep_until( B_guns_turrets_fired or (object_get_health(ai_vehicle_get(ai_target)) < r_health), 1 );
		if ( not B_guns_turrets_fired ) then
			B_guns_turrets_fired = TRUE;
			f_audio_asteroid_guns_set( DEF_R_AUDIO_ASTEROID_GUNS_IMMEDIATE() );
		end
	end

end

// === cs_lookout_asteroidguns::: AI
script command_script cs_lookout_asteroidguns()
	dprint( "$$$ f_guns_ai_turrets_spawn $$$" );

end


script static void f_guns_ai_turrets_fired_watch()
	sleep_until( f_ai_killed_cnt(sg_guns_turrets_targets) > 0, 1 );
	//dprint( "::: f_guns_ai_turrets_fired_watch :::" );
	
	B_guns_turrets_fired = TRUE;
end
