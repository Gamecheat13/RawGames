

script dormant f_fx_setup_core_beams()
	dprint("--------f_fx_setup_core_beams()");
	device_set_position_track(fx_cathedral_beam_left, 'm40:corebeams', 0);
	device_set_position_track(fx_cathedral_beam_right, 'm40:corebeams', 0);
	
	effect_new( environments\solo\m020\fx\beams\cathedral_beam_off.effect, fx_13_beam_infobeam);
	effect_new( environments\solo\m020\fx\beams\cathedral_beam_off.effect, fx_13_beam_inforbeam2);
	effect_new_on_object_marker(environments\solo\m020\fx\beams\datacore_beam_off.effect, fx_cathedral_beam_left, fx_arm);
	effect_new_on_object_marker(environments\solo\m020\fx\beams\datacore_beam_off.effect, fx_cathedral_beam_right, fx_arm);
end


script static void f_fx_activate_core_beam_left()
	dprint("--------f_fx_activate_core_beam_left");
	// Kill the first stage effect
	effect_kill_from_flag( environments\solo\m020\fx\beams\cathedral_beam_off.effect, fx_13_beam_inforbeam2);
	effect_kill_object_marker(environments\solo\m020\fx\beams\datacore_beam_off.effect, fx_cathedral_beam_left, fx_arm);
	
	// Activate the 2nd stage effect
	effect_new( environments\solo\m020\fx\beams\cathedral_beam_on.effect, fx_13_beam_inforbeam2);
	effect_new_on_object_marker(environments\solo\m020\fx\beams\datacore_beam_on.effect, fx_cathedral_beam_left, fx_arm);

end


script static void f_fx_activate_core_beam_right()
	dprint("--------f_fx_activate_core_beam_right");
	// Kill the first stage effect
	effect_kill_from_flag( environments\solo\m020\fx\beams\cathedral_beam_off.effect, fx_13_beam_infobeam);
	effect_kill_object_marker(environments\solo\m020\fx\beams\datacore_beam_off.effect, fx_cathedral_beam_right, fx_arm);
	
	// Activate the 2nd stage effect
	effect_new( environments\solo\m020\fx\beams\cathedral_beam_on.effect, fx_13_beam_infobeam);
	effect_new_on_object_marker(environments\solo\m020\fx\beams\datacore_beam_on.effect, fx_cathedral_beam_right, fx_arm);

end


