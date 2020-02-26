//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// Mission: 							m10_crash_elevator_ICS
//	Insertion Points:			XXX							- Drop pod
//										
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343

// =================================================================================================
// =================================================================================================
// Elevator ICS
// =================================================================================================
// =================================================================================================
// variables
global boolean b_elevator_ICS_started							= FALSE;
global unit g_ics_player													= NONE;
global boolean b_elevator_ICS_player						  = FALSE;
global boolean b_elevator_ICS_player_moved        = FALSE;
global boolean b_elevator_ICS_done                = FALSE;


// functions
// === f_elevator_ICS_startup::: Area main initialization
script startup f_elevator_ICS_startup()
	sleep_until( b_mission_started == TRUE );
	//dprint( "::: f_elevator_ICS_startup :::" );

	// setup ICS trigger
	wake( f_elevator_ICS_trigger );

end

script static boolean f_B_elevator_ICS_started()
	b_elevator_ICS_started;
end
	
script static void f_m10_elevator_trigger( object trigger, unit activator )
	g_ics_player = activator;
	b_elevator_ICS_player = TRUE;
end

// === f_elevator_ICS_trigger::: Trigger drop pod ICS setup
script dormant f_elevator_ICS_trigger()
	sleep_until (volume_test_players(tv_elevator_room), 1);
	dprint( "::: f_elevator_ICS_trigger :::" );
	
	//datamine
	data_mine_set_mission_segment( "m10_ICS_elevator" );

	//object_create(sn_elevator_ics_crate);
	
	// set the door objective
	thread (f_objective_blip( DEF_R_OBJECTIVE_ACTIVATE_ELEVATOR, TRUE, TRUE ));

	local long show=0;
repeat
	g_ics_player = NONE;
	b_elevator_ICS_player = FALSE;
	
	// wait for a player to trigger the control
	sleep_until( g_ics_player != NONE, 1 );
		sleep_until( b_elevator_ICS_player != FALSE, 1 );
	print( "::: f_elevator_ICS_activated :::" );
	
	volume_teleport_players_not_inside(tv_elevator_lobby, tp_to_lobby_flag);
	sleep(1);


	// open the elevator door
	show=pup_play_show(elevator);
	sleep(5);
until(pup_is_playing(show),1);
	b_elevator_ICS_started = TRUE;
	// destroy the handle
	object_destroy( dc_elevator_ics_button );
	// unblip the handle
	thread (f_objective_blip( DEF_R_OBJECTIVE_ACTIVATE_ELEVATOR, FALSE, TRUE ));
	sleep_until(not pup_is_playing(show),1);
	game_save();
end




//////////////////////////////////////
//		ELEVATOR ICS
/////////////////////////////////////

script dormant f_start_elevator_fx()
	sleep(50);
	//Pause space dust effect
	fx_camera_pause( TRUE );
	fx_08_elevator();
	fx_08_elevator_door();

end

script dormant f_end_elevator_fx()
	sleep(10);
	//Pause space dust effect
	fx_camera_pause( FALSE );
	fx_08_elev_exit();


end

script static void f_debris_hit()
	damage_players(objects\characters\monitor\damage_effects\first_hit.damage_effect);
	camera_shake_all_coop_players( 0.1, 0.2, 1, 0.1);
end

script static void f_debris_release_shake()
	camera_shake_all_coop_players( 0.4, 0.3, 1, 0.2);
end

global short g_elevator_be_careful=0;
global boolean g_elevator_slam=false;

script static void f_elevator_be_careful()
	if g_elevator_be_careful==0 then
		g_elevator_be_careful=1;
		dprint("Cortana : Chief, be careful");
		sound_impulse_start ('sound\dialog\mission\m10\m10_elevator_ics_pry_00100', NONE, 1);
		sleep(sound_impulse_time('sound\dialog\mission\m10\m10_elevator_ics_pry_00100')+90);
		g_elevator_be_careful=2;
	end
end

script static void f_elevator_because()
	if g_elevator_be_careful==1 then
		dprint("Cortana : because some areas might have lost pressure");
		sound_impulse_start('sound\dialog\mission\m10\m10_elevator_ics_00100', NONE, 1);
		sleep(sound_impulse_time('sound\dialog\mission\m10\m10_elevator_ics_00100'));

		dprint("Master Chief : Right.");
		sound_impulse_start('sound\dialog\mission\m10\m10_elevator_ics_00101', NONE, 1);
	end
end

script static void f_elevator_slam()
	if g_elevator_slam then
		sound_impulse_start('sound\environments\solo\m010\ics\ics_m10_door_pry_close', NONE, 1.0);
	end
	g_elevator_slam=true;
end
script static void f_move_check_setup()
	if
		(game_is_cooperative() == TRUE) AND (b_elevator_ICS_done == FALSE)
	then
		thread(f_elevator_ics_move_check());
		thread(f_elevator_ics_b_set());
	end
	
end

script static void f_elevator_ics_move_check()
	sleep_s(120);

	if
		(b_elevator_ICS_player_moved == FALSE) AND (b_elevator_ICS_done == FALSE)
	then
	unit_kill(g_ics_player);
	sleep_s(1);
	fade_out(0,0,0,20);
	sleep(15);
	game_revert();
	else
		thread(f_move_check_setup());
	end

end

script static void f_elevator_ics_b_set()

	b_elevator_ICS_player_moved = FALSE;
	unit_action_test_reset(g_ics_player);
	sleep_until(unit_action_test_look_relative_all_directions (g_ics_player));
	b_elevator_ICS_player_moved = TRUE;
	
end