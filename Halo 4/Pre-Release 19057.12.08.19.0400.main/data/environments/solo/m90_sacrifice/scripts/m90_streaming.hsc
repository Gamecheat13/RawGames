

// Scripted load of eye zoneset, which includes cin_m91_sacrifice so we avoid
// a blocking load once the player completes the area. We use the begin_zone_set trigger to initiate the load,
// which handles player teleports automatically, then we script the commit so checkpoints become available again
// as soon as possible.
script dormant f_load_eye_zoneset()
	// Sleep until we've begun loading the eye zoneset
	sleep_until(current_zone_set() == s_eye_idx);

	dprint("Eye zoneset loading begun");
	
	// Wait until we've completely loaded it
	sleep_until(not PreparingToSwitchZoneSet());
	
	// Commit the switch so checkpoints are usable again.
	switch_zone_set(eye);
end