//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// Mission: 					m70
//
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343

// =================================================================================================
// =================================================================================================
// spire_03_INT_FX
// =================================================================================================
// =================================================================================================
// variables

// functions
// === f_spire_03_INT_FX_init::: Initialize
script dormant f_spire_03_FX_init()
	dprint( "::: f_spire_03_INT_FX_init :::" );

	// initialize modules

	// initialize sub modules
	//wake( f_spire_03_INT_FX_CCC_init );

end

// === f_spire_03_INT_FX_deinit::: Deinitialize
script dormant f_spire_03_FX_deinit()
	dprint( "::: f_spire_03_INT_FX_deinit :::" );

	// kill functions
	sleep_forever( f_spire_03_FX_init );

	// deinitialize modules

	// deinitialize sub modules
	//wake( f_spire_03_INT_FX_CCC_deinit );

end


// Placeholder for the spire collision debris effects. The effect tag may change, once it does we can just move this into the puppeteer.
script static void fx_debris(point_reference fxPoint)
	dprint("-------------------------fx_debris()");
	effect_new_at_ai_point(environments\solo\m70_liftoff\fx\dust\dust_backdraft_large_goingright.effect, fxPoint);
end


script static void f_sp03_fx_grav_lift_01()
	dprint("f_sp03_fx_grav_lift_01");
	effect_new_between_points(environments\solo\m70_liftoff\fx\energy\gravlift_tube.effect, fx_14_gravlift_1_start, fx_14_gravlift_1_end);
	sleep_until(volume_test_players(tv_sp03_grav_lift_01), 1);
	thread(f_grav_lift_01_gaze_correct());
	thread(f_grav_lift_effect_on_player(tv_sp03_grav_lift_01, player0));
	thread(f_grav_lift_effect_on_player(tv_sp03_grav_lift_01, player1));
	thread(f_grav_lift_effect_on_player(tv_sp03_grav_lift_01, player2));
	thread(f_grav_lift_effect_on_player(tv_sp03_grav_lift_01, player3));

end

script static void f_sp03_fx_grav_lift_disable()
	dprint("f_sp03_fx_grav_lift_disable");
	effect_kill_from_flag(environments\solo\m70_liftoff\fx\energy\gravlift_base.effect, fx_14_gravlift_2_start);
end

script static void f_sp03_fx_grav_lift_enable()
	dprint("f_sp03_fx_grav_lift_enable");
	effect_new( environments\solo\m70_liftoff\fx\energy\gravlift_base.effect, fx_14_gravlift_2_start);
end
//effect_kill_from_flag(effect , flag);
script static void f_sp03_fx_grav_lift_02()
		effect_new_between_points(environments\solo\m70_liftoff\fx\energy\gravlift_tube.effect, fx_14_gravlift_2_start, fx_14_gravlift_2_end);
		sleep_until(volume_test_players(tv_sp03_grav_lift_02), 1);
		thread(f_grav_lift_02_gaze_correct());
		
		thread(f_grav_lift_effect_on_player(tv_grav_lift_02_loop_effect, player0));
		thread(f_grav_lift_effect_on_player(tv_grav_lift_02_loop_effect, player1));
		thread(f_grav_lift_effect_on_player(tv_grav_lift_02_loop_effect, player2));
		thread(f_grav_lift_effect_on_player(tv_grav_lift_02_loop_effect, player3));
end

script static void f_grav_lift_effect_on_player(trigger_volume tv_gravlift, player p_player)
	sleep_until(volume_test_object(tv_gravlift, p_player), 1);
	sleep_s(0.25);
	dprint("f_sp03_fx_grav_lift_01");
	effect_new_on_object_marker(environments\solo\m70_liftoff\fx\energy\gravlift_inside.effect, p_player, "fx_shield_core");
	sleep_until(not volume_test_object(tv_gravlift, p_player), 1);
	effect_kill_object_marker(environments\solo\m70_liftoff\fx\energy\gravlift_inside.effect, p_player, "fx_shield_core ");
end
//	effect_new_on_object_marker_loop <effect> <object> <string_id>
// effect_new_on_object_marker(environments\solo\m70_liftoff\fx\energy\gravlift_inside.effect, player0, "fx_shield_core");
//	effect_new_on_object_marker_loop(environments\solo\m70_liftoff\fx\energy\gravlift_inside.effect, player0, "fx_shield_core ");
//	effect_stop_object_marker(environments\solo\m70_liftoff\fx\energy\gravlift_inside.effect, player0, "fx_shield_core ");
//effect_kill_object_marker(environments\solo\m70_liftoff\fx\energy\gravlift_inside.effect, player0, "fx_shield_core ");


//vehicle_set_player_interaction(flight_pelican_sp01, "" TRUE, TRUE);
//vehicle_test_seat(flight_pelican_sp01, "pelican_d");
//vehicle_test_seat_unit(flight_pelican_sp01, "pelican_d", player0)