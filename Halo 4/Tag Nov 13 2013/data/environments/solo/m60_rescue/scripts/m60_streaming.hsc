// Scripts aiding tricky streaming areas.

// CALLBACK from cin_m062_introductions cinematic
global zone_set cinOutroZS = "cin_m62_trail_dz";
script static void f_load_cin_m62_trail()
	prepare_to_switch_to_zone_set(cinOutroZS);
	// Don't bother committing the switch. We just want to avoid hitching much when loading back into gameplay
end

script dormant f_load_boulders()
	zone_set_trigger_volume_enable("begin_zone_set:boulders:scripted", TRUE);
	sleep_until(not PreparingToSwitchZoneSet(), 1);
	zone_set_trigger_volume_enable("zone_set:boulders:scripted", TRUE);
end