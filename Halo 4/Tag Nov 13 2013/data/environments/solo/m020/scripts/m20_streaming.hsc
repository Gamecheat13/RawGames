// Scripts to govern special case streaming areas, patching up problems that aren't easily handled with the built-in behavior.

script startup InitializeStreamingScripts()
	local long toCathThreadId = thread(ToCathedralTransition());
	local long wreckageThreadId = thread(WreckageATeleportPlug());
	local long fieldThreadId = thread(FieldLean());
	local long toCathTeleportThreadId = thread(ToCathedralTeleportPlug());
	
	sleep_until(current_zone_set() == s_zoneset_cathedral_int);
	kill_thread(toCathThreadId);
	kill_thread(wreckageThreadId);
	kill_thread(fieldThreadId);
	kill_thread(toCathTeleportThreadId);
end

// Once users have moved significantly into cathedral_ext, we load s_zoneset_cathedral_ext, unloading field. 
// When this happens, disable the forward progression volumes, and enable triggers that will reload field.
// This is able to work because we won't unload anything while backtracking, so triggering a load of field and then
// immediately cancelling it by walking back into cathedral_ext is acceptable.
script static void ToCathedralTransition()
	zone_set_trigger_volume_enable("zone_set:12_field_to_cathedral:*:backtrack", FALSE);
	zone_set_trigger_volume_enable("zone_set:12_field_to_cathedral:*", TRUE);
	
	repeat
		sleep_until(current_zone_set_fully_active() == s_zoneset_cathedral_ext, 1);
		zone_set_trigger_volume_enable("zone_set:12_field_to_cathedral:*", FALSE);
		zone_set_trigger_volume_enable("zone_set:12_field_to_cathedral:*:backtrack", TRUE);
		
		// Re-enable forward progression when players return to field_lean zoneset (unloading cathedral_ext)
		sleep_until(current_zone_set_fully_active() == s_zoneset_field_lean, 1);
		zone_set_trigger_volume_enable("zone_set:12_field_to_cathedral:*:backtrack", FALSE);
		zone_set_trigger_volume_enable("zone_set:12_field_to_cathedral:*", TRUE);
	until(false, 1);	

end

script static void FieldLean()
	zone_set_trigger_volume_enable("zone_set:09_field:*:back", FALSE);
	
	repeat
		sleep_until(current_zone_set_fully_active() == s_zoneset_field_lean, 1);
		zone_set_trigger_volume_enable("zone_set:09_field:*", FALSE);
		zone_set_trigger_volume_enable("zone_set:09_field:*:back", TRUE);
		
		sleep_until(current_zone_set_fully_active() == s_zoneset_field, 1);
		zone_set_trigger_volume_enable("zone_set:09_field:*", TRUE);
		zone_set_trigger_volume_enable("zone_set:09_field:*:back", FALSE);
	until(false, 1);	
end

// Enable/disable the plug volume that sits over the seam between 04_to_wreckage and 05_wreckage_a so
// that we can avoid OOE sight problems while also keeping good distance between the "usual" volumes to
// prevent excessive teleports in co-op.
script static void WreckageATeleportPlug
	zone_set_trigger_volume_enable("begin_zone_set:05_wreckage_a:*:scripted", FALSE);
	zone_set_trigger_volume_enable("begin_zone_set:08_to_field:*:forward", FALSE);

	// Need to start with the to_field trigger disabled for technical reasons. hs_update is early in game_tick, 
	// the zone switch code is late, with object updates and moves in between. Script may be a frame later than
	// zone switch code in detecting entry into a volume. 
	
	repeat
		// Using volume_test_objects to be completely consistent with the automatic zone switching tests
		
		sleep_until(volume_test_objects("begin_zone_set:08_to_field:*:forward", players()), 1);
		zone_set_trigger_volume_enable("begin_zone_set:08_to_field:*:forward", TRUE);
		zone_set_trigger_volume_enable("begin_zone_set:05_wreckage_a:*:scripted", TRUE);
		sleep_until(volume_test_objects("begin_zone_set:04_to_wreckage:*:back", players()), 1);
		zone_set_trigger_volume_enable("begin_zone_set:05_wreckage_a:*:scripted", FALSE);
		zone_set_trigger_volume_enable("begin_zone_set:08_to_field:*:forward", FALSE);
	until(false, 1);	
end

script static void ToCathedralTeleportPlug()
	
	repeat
		// Turn it off when no one is in field rear.
		sleep_until(not volume_test_players("tv_streaming_field_rear"), 1);
		zone_set_trigger_volume_enable("begin_zone_set:12_field_to_cathedral:*:scripted", FALSE);
		
		// Turn it back on when we move back into field
		sleep_until(volume_test_players("tv_streaming_field_rear"), 1);
		zone_set_trigger_volume_enable("begin_zone_set:12_field_to_cathedral:*:scripted", TRUE);
	until(false, 2);

end