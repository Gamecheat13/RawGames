//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434
//
// 	Mission: 					SPARTAN OPS: E8M2 - Artillery
//										
//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** E8M2: RENDEZVOUS ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// DEFINES --------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_e8_m2_rendezvous_init::: Init
script dormant f_e8_m2_rendezvous_init()
	dprint( "f_e8_m2_rendezvous_init" );
	
	// initialize sub-modules
	
	// setup trigger
	wake( f_e8_m2_rendezvous_trigger );

end

// === f_e8_m2_rendezvous_trigger::: Trigger
script dormant f_e8_m2_rendezvous_trigger()
local long l_blip = 0;
	dprint( "f_e8_m2_rendezvous_trigger" );
	
	// ARTILLERY COMPLETE
	sleep_until( S_e8m2_artillery_state == DEF_E8M2_ARTILLERY_STATE_COMPLETE, 1 );
	wake( f_e8_m2_dialog_rendezvous_start );

	// RENDEZVOUS LZ
	sleep_until( f_e8_m2_rendezvous_state() >= DEF_E8M2_RENDEZVOUS_STATE_START, 1 );
	l_blip = spops_blip_auto_flag_trigger( flg_e8_m2_rendezvous_lz_loc, "default", tv_e8_m2_lz_area, FALSE );
	wake( f_e8_m2_ai_phantom_lz_start );
	if ( not volume_test_players(tv_e8_m2_lz_area) ) then	// don't show objective if they're already there
		local long l_timer = timer_stamp( 60.0 );
		f_e8_m2_objective( R_e8_m2_objective_lz_rendezvous );
		sleep_until( volume_test_players(tv_e8_m2_lz_area) or (ai_living_count(gr_e8_m2_enemy_unit_all) <= 0) or timer_expired(l_timer), 1 );
		f_e8_m2_rendezvous_state( DEF_E8M2_RENDEZVOUS_STATE_PHANTOMS );
		
		sleep_until( volume_test_players(tv_e8_m2_lz_area) or (S_e8_m2_ai_phantom_lz_delivering > 0), 1 );
	end

	f_e8_m2_rendezvous_state( DEF_E8M2_RENDEZVOUS_STATE_PHANTOMS );
	if ( volume_test_players(tv_e8_m2_lz_area) ) then
		f_e8_m2_rendezvous_state( DEF_E8M2_RENDEZVOUS_STATE_AT_LZ );
	end
	
	// RENDEZVOUS RETURN
	object_create_folder_anew( fld_e8_m2_spawn_rendezvous_lz );
	wake( f_e8_m2_dialog_rendezvous_fight );

end

script static boolean f_e8_m2_rendezvous_complete()
	f_e8_m2_ai_phantom_lz_complete() and B_e8_m2_ai_lz_watchers_complete;
end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** E8M2: rendezvous: STATE ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// DEFINES --------------------------------------------------------------------------------------------------------------------------------------------------
global short DEF_E8M2_RENDEZVOUS_STATE_NONE = 											0;
global short DEF_E8M2_RENDEZVOUS_STATE_START = 											1;
global short DEF_E8M2_RENDEZVOUS_STATE_PHANTOMS = 									2;
global short DEF_E8M2_RENDEZVOUS_STATE_AT_LZ = 											3;
global short DEF_E8M2_RENDEZVOUS_STATE_ATTACK = 										4;

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
static short S_e8m2_rendezvous_state = 															DEF_E8M2_RENDEZVOUS_STATE_NONE;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_e8_m2_rendezvous_state::: Sets the state of the rendezvous
script static void f_e8_m2_rendezvous_state( short s_state )

	if ( s_state > S_e8m2_rendezvous_state ) then
		dprint( "f_e8_m2_rendezvous_state" );
		//inspect( s_state );
		S_e8m2_rendezvous_state = s_state;
	end
	
end

// === f_e8_m2_rendezvous_state::: Gets the state of the rendezvous
script static short f_e8_m2_rendezvous_state()
	S_e8m2_rendezvous_state;
end
