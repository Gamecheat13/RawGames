//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// Mission: 					m90_sacrifce_fx
//										
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343

// =================================================================================================
// =================================================================================================
// *** GLOBALS ***
// =================================================================================================
// =================================================================================================

//

// =================================================================================================
// =================================================================================================
// *** START-UP ***
// =================================================================================================
// =================================================================================================

script startup m90_sacrifice_fx()

	if b_debug then 
		print ("::: M90 - FX :::");
	end
	
	thread(test_fx());
end

script static void test_fx()
	print ("::: test FX :::");
	//effect_new( cinematics\cin_verticalslice\fx\rig_spark_pipe.effect, test_fx );
end


// =================================================================================================
// =================================================================================================
// *** CORTANA SPLINTER ***
// =================================================================================================
// =================================================================================================

script static void fx_cortana_splinter_start(object pup_cortana)
	dprint("------------------fx_cortana_splinter_start");
	effect_new_on_object_marker(objects\characters\storm_cortana\fx\splinter\fx_splinter_start.effect, pup_cortana, fx_pelvis);
end

script static void fx_cortana_splinter_idle(object pup_cortana)
	dprint("------------------fx_cortana_splinter_idle");
	effect_new_on_object_marker(objects\characters\storm_cortana\fx\splinter\fx_splinter_idle.effect, pup_cortana, fx_pelvis);
end

script static void fx_cortana_splinter_idle_stop(object pup_cortana)
	dprint("------------------fx_cortana_splinter_idle_stop");
	effect_stop_object_marker(objects\characters\storm_cortana\fx\splinter\fx_splinter_idle.effect, pup_cortana, fx_pelvis);
end

script static void fx_cortana_splinter_end(object pup_cortana)
	dprint("------------------fx_cortana_splinter_end");
	effect_new_on_object_marker(objects\characters\storm_cortana\fx\splinter\fx_splinter_end.effect, pup_cortana, fx_pelvis);
end

script static void fx_cortana_splinter_apart(object pup_cortana)
	dprint("------------------fx_cortana_splinter_apart");
	effect_new_on_object_marker(objects\characters\storm_cortana\fx\splinter\fx_splinter_apart.effect, pup_cortana, fx_pelvis);
end




//	Object FX Marker Command Examples
//	effect_kill_from_flag(environments\solo\m80_delta\fx\energy\atr_dmg_composer_energy_center.effect, fx_composer_center);
//	effect_new_on_object_marker(environments\solo\m80_delta\fx\energy\atr_dmg_composer_energy_center.effect, ad_object, fx_comp_eye);




// ======================================================
//	Coldant Composer Chargeup and Firing Sequence
// ======================================================

//	Coldant Composer – Didact Backside Glow
script static void fx_didact_back_glow()
	dprint("play_fx_didact_back_glow()");
	effect_new_on_object_marker(environments\solo\m90_sacrifice\fx\lens_flares\cold_ant_didact_back_glow.effect, composer, fx_composer_beam_up);
end

// ------------------------------------------------------

//	Coldant Composer – Didact Shield Lens Flare
script static void fx_didact_shield()
	dprint("play_fx_didact_shield()");

end

// ------------------------------------------------------

//	Coldant Composer – Activate - Stage 0
script static void fx_composer_activate()
	dprint("play_fx_composer_activate()");
	effect_new_on_object_marker(environments\solo\m90_sacrifice\fx\beams\cold_ant_composer_base_energy.effect, composer, fx_composer_base);
	effect_new_on_object_marker(environments\solo\m90_sacrifice\fx\lens_flares\cold_ant_composer_center_flare.effect, composer, fx_composer_eye_center);
end

// ------------------------------------------------------

//	Coldant Composer – Lens Flare and Center Beam - Stage 1
script static void fx_composer_beam_center_01()
	dprint("play_fx_composer_beam_center_01()");
	effect_new_on_object_marker(environments\solo\m90_sacrifice\fx\beams\cold_ant_comp_beam_center.effect, composer, fx_composer_beam_up);
//	effect_new_on_object_marker(environments\solo\m90_sacrifice\fx\lens_flares\cold_ant_didact_shield_flare.effect, composer, fx_composer_beam_up);

//	Kill Didact Backside Glow
	effect_kill_object_marker(environments\solo\m90_sacrifice\fx\lens_flares\cold_ant_didact_back_glow.effect, composer, fx_composer_beam_up);
end

// ------------------------------------------------------

//	Coldant Composer – Ball Glow - Stage 2 --- NOT USED, I think
script static void fx_composer_ball_glow()
	dprint("play_fx_composer_ball_glow()");
end

// ------------------------------------------------------

//	Coldant Composer – Didact Shield - Stage 2B
script static void fx_composer_didact_shield()
	dprint("play_fx_composer_didact_shield()");
end

// ------------------------------------------------------

//	Coldant Composer – Chargeup - Stage 3
script static void fx_composer_chargeup()
	dprint("play_fx_composer_chargeup()");
//	Composer Chargeup
	effect_new_on_object_marker(environments\solo\m90_sacrifice\fx\beams\cold_ant_composer_chargeup_03.effect, composer, fx_composer_ball);
end

// ------------------------------------------------------

//	Coldant Composer – Fire Beam - Stage 4
script static void fx_composer_fire()
	dprint("play_fx_composer_chargeup_and_fire_beam()");

//	Composer Fire
	effect_new_on_object_marker(environments\solo\m90_sacrifice\fx\beams\cold_ant_composer_fire.effect, composer, fx_composer_beam_fire);
	effect_new_on_object_marker(environments\solo\m90_sacrifice\fx\beams\cold_ant_comp_planet_impact.effect, composer, fx_composer_beam_fire);

//	Kill Composer Primer Beam
	effect_kill_object_marker(environments\solo\m90_sacrifice\fx\beams\cold_ant_comp_beam_center.effect, composer, fx_composer_beam_up);
	effect_kill_object_marker(environments\solo\m90_sacrifice\fx\lens_flares\cold_ant_didact_back_glow.effect, composer, fx_composer_beam_up);

//	Composer Digitize Beam
	sleep(110);
	effect_new_on_object_marker(environments\solo\m90_sacrifice\fx\beams\cold_ant_comp_beam_up_digitize.effect, composer, fx_composer_beam_fire);
	sleep(60);
	effect_new_on_object_marker(environments\solo\m90_sacrifice\fx\beams\cold_ant_comp_beam_mid_digitize.effect, composer, fx_composer_beam_up);
	sleep(60);
	effect_new_on_object_marker(environments\solo\m90_sacrifice\fx\beams\cold_ant_comp_beam_down_digitize.effect, composer, fx_composer_beam_down);
	object_set_function_variable(composer, slipspace_stew, 1, 0.0);
	effect_new_on_object_marker(environments\solo\m90_sacrifice\fx\rift\rift_beam_lensflare.effect, composer, fx_slipspace_rift_link);
end

// ------------------------------------------------------

//	Coldant Composer – Digitize Beam - Stage 5 --- MOVED to Composer Fire Beam trigger
script static void fx_composer_digitize()
	dprint("play_fx_composer_digitize_beam()");
end

script static void fx_engine_room_beams()
	print ("--- engine room beams ---");
	effect_new_between_points(environments\solo\m90_sacrifice\fx\beams\generator_room_beam.effect, fx_atr_beam_lt_01, fx_atr_beam_lb_01);
	effect_new_between_points(environments\solo\m90_sacrifice\fx\beams\generator_room_beam.effect, fx_atr_beam_lt_02, fx_atr_beam_lb_02);
	effect_new_between_points(environments\solo\m90_sacrifice\fx\beams\generator_room_beam.effect, fx_atr_beam_lt_03, fx_atr_beam_lb_03);
	effect_new_between_points(environments\solo\m90_sacrifice\fx\beams\generator_room_beam.effect, fx_atr_beam_lt_04, fx_atr_beam_lb_04);
	effect_new_between_points(environments\solo\m90_sacrifice\fx\beams\generator_room_beam.effect, fx_atr_beam_lt_05, fx_atr_beam_lb_05);
	effect_new_between_points(environments\solo\m90_sacrifice\fx\beams\generator_room_beam.effect, fx_atr_beam_lt_06, fx_atr_beam_lb_06);
	effect_new_between_points(environments\solo\m90_sacrifice\fx\beams\generator_room_beam.effect, fx_atr_beam_lt_07, fx_atr_beam_lb_07);
	effect_new_between_points(environments\solo\m90_sacrifice\fx\beams\generator_room_beam.effect, fx_atr_beam_lt_08, fx_atr_beam_lb_08);
	effect_new_between_points(environments\solo\m90_sacrifice\fx\beams\generator_room_beam.effect, fx_atr_beam_lt_09, fx_atr_beam_lb_09);
	effect_new_between_points(environments\solo\m90_sacrifice\fx\beams\generator_room_beam.effect, fx_atr_beam_lt_10, fx_atr_beam_lb_10);
	effect_new_between_points(environments\solo\m90_sacrifice\fx\beams\generator_room_beam.effect, fx_atr_beam_rt_01, fx_atr_beam_rb_01);
	effect_new_between_points(environments\solo\m90_sacrifice\fx\beams\generator_room_beam.effect, fx_atr_beam_rt_02, fx_atr_beam_rb_02);
	effect_new_between_points(environments\solo\m90_sacrifice\fx\beams\generator_room_beam.effect, fx_atr_beam_rt_03, fx_atr_beam_rb_03);
	effect_new_between_points(environments\solo\m90_sacrifice\fx\beams\generator_room_beam.effect, fx_atr_beam_rt_04, fx_atr_beam_rb_04);
	effect_new_between_points(environments\solo\m90_sacrifice\fx\beams\generator_room_beam.effect, fx_atr_beam_rt_05, fx_atr_beam_rb_05);
	effect_new_between_points(environments\solo\m90_sacrifice\fx\beams\generator_room_beam.effect, fx_atr_beam_rt_06, fx_atr_beam_rb_06);
	effect_new_between_points(environments\solo\m90_sacrifice\fx\beams\generator_room_beam.effect, fx_atr_beam_rt_07, fx_atr_beam_rb_07);
	effect_new_between_points(environments\solo\m90_sacrifice\fx\beams\generator_room_beam.effect, fx_atr_beam_rt_08, fx_atr_beam_rb_08);
	effect_new_between_points(environments\solo\m90_sacrifice\fx\beams\generator_room_beam.effect, fx_atr_beam_rt_09, fx_atr_beam_rb_09);
	effect_new_between_points(environments\solo\m90_sacrifice\fx\beams\generator_room_beam.effect, fx_atr_beam_rt_10, fx_atr_beam_rb_10);
end

// =================================================================================================
// =================================================================================================
// *** DIDACT SHIELD AND BEAMS ***
// =================================================================================================
// =================================================================================================

script static void f_fx_activate_beams()
	dprint("f_fx_activate_beams()");
	object_set_function_variable(dm_composerbeam1, beam_state, 1, 0);
	object_set_function_variable(dm_composerbeam2, beam_state, 1, 0);
end

script static void f_fx_deactivate_beam(object beam)
	dprint("f_fx_deactivate_beam()");
	object_set_function_variable(beam, beam_state, 0, 3);
	sleep(3*30);
	effect_kill_object_marker(environments\solo\m90_sacrifice\fx\beams\composer_beams.effect, beam, fx_arm);
	object_destroy(beam);
end

script static void f_fx_deactivate_shield()
	dprint("f_fx_deactivate_shield()");
	object_set_function_variable(dm_composer_shield, shield_state, 1, 1);
	sleep(1*30);
	effect_kill_object_marker(environments\solo\m90_sacrifice\fx\shields\composer_shield.effect, dm_composer_shield, fx_arm);
	object_destroy(dm_composer_shield);
end

script static void f_fx_shield_cleanup()
	// Used before the cinematic to clean these effects out of the bsp
	object_destroy(dm_composerbeam1);
	object_destroy(dm_composerbeam2);
	object_destroy(dm_composer_shield);
end

// =================================================================================================
// =================================================================================================
// *** pup_didact_ics ***
// =================================================================================================
// =================================================================================================

script static void f_create_restraints
	effect_new_on_object_marker("objects\characters\storm_cortana\fx\restraint\fx_beam_restraint_left",did_octopus,marker5);
	effect_new_on_object_marker("objects\characters\storm_cortana\fx\restraint\fx_beam_restraint_right",did_octopus,marker7);
	
	effect_new_on_object_marker(objects\characters\storm_cortana\fx\restraint\fx_restraint_arm.effect, pup_didact, fx_right_forearm);
	effect_new_on_object_marker(objects\characters\storm_cortana\fx\restraint\fx_restraint_arm.effect, pup_didact, fx_left_forearm);
	effect_new_on_object_marker(objects\characters\storm_cortana\fx\restraint\fx_restraint_calf.effect, pup_didact, fx_left_calf);
	effect_new_on_object_marker(objects\characters\storm_cortana\fx\restraint\fx_restraint_thigh.effect, pup_didact, fx_right_thigh);
end

script static void f_break_restraints_l
	dprint("f_break_restraints_l");
	effect_new_on_object_marker("objects\characters\storm_cortana\fx\restraint\fx_restraint_fail",pup_didact,fx_left_forearm);
	effect_kill_object_marker(objects\characters\storm_cortana\fx\restraint\fx_restraint_arm.effect, pup_didact, fx_left_forearm);
	effect_kill_object_marker("objects\characters\storm_cortana\fx\restraint\fx_beam_restraint_left",did_octopus,marker5);
end

script static void f_break_restraints_r
	dprint("f_break_restraints_r");
	effect_new_on_object_marker("objects\characters\storm_cortana\fx\restraint\fx_restraint_fail",pup_didact,fx_right_forearm);
	effect_kill_object_marker(objects\characters\storm_cortana\fx\restraint\fx_restraint_arm.effect, pup_didact, fx_right_forearm);
	effect_kill_object_marker("objects\characters\storm_cortana\fx\restraint\fx_beam_restraint_right",did_octopus,marker7);
end

script static void f_didact_open
	dprint("f_didact_open");
	effect_new_on_object_marker("objects\characters\storm_didact\fx\chestweakness",pup_didact,fx_chest_cavity);
end

script static void f_didact_close
	dprint("f_didact_close");
	effect_kill_object_marker("objects\characters\storm_didact\fx\chestweakness",pup_didact,fx_chest_cavity);
end

script static void f_remove_leg_restraints
	dprint("f_remove_leg_restraints");
	effect_kill_object_marker(objects\characters\storm_cortana\fx\restraint\fx_restraint_calf.effect, pup_didact, fx_left_calf);
	effect_kill_object_marker(objects\characters\storm_cortana\fx\restraint\fx_restraint_thigh.effect, pup_didact, fx_right_thigh);
end

