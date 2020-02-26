//E8M5 Audio Scripts

////////////////////////////////////MAJOR SEQUENCES/FLOW////////////////////////////////////////////////////
// Mission Start
// First Encounter Begin -> First Encounter End
// Second Encounter Begin -> Second Encounter End
// Major Encounter (Player Proceeds to all Locations, this all kind of flows together, no strong beginnings or ends) -> Major Encounter Ends
// Final Encounter (Player activates everything, last wave comes in) -> Final Encounter End
// Phantoms/Wraiths Enter (Phantoms get shot down by AA guns, drop Wraiths in process) -> Wraith Fight -> Level End

// Mission Start
script static void f_e8m5_music_start
	dprint("Play_mus_pve_e8m5_start");
	music_start('Play_mus_pve_e8m5_start');
end

// First Encounter Begin -> First Encounter End
script static void f_e8m5_music_first_begin
	dprint("Play_mus_pve_e8m5_first_begin");
	music_set_state('Play_mus_pve_e8m5_first_begin');
end

script static void f_e8m5_music_first_end
	dprint("Play_mus_pve_e8m5_first_end");
	music_set_state('Play_mus_pve_e8m5_first_end');
end

// Second Encounter Begin -> Second Encounter End
script static void f_e8m5_music_second_begin
	dprint("Play_mus_pve_e8m5_second_begin");
	music_set_state('Play_mus_pve_e8m5_second_begin');
end

script static void f_e8m5_music_second_end
	dprint("Play_mus_pve_e8m5_second_end");
	music_set_state('Play_mus_pve_e8m5_second_end');
end

// Major Encounter (Player Proceeds to all Locations, this all kind of flows together, no strong beginnings or ends) -> Major Encounter Ends
script static void f_e8m5_music_major_begin
	dprint("Play_mus_pve_e8m5_major_begin");
	music_set_state('Play_mus_pve_e8m5_major_begin');
end

script static void f_e8m5_music_major_end
	dprint("Play_mus_pve_e8m5_major_end");
	music_set_state('Play_mus_pve_e8m5_major_end');
end

// Final Encounter (Player activates everything, last wave comes in) -> Final Encounter End
script static void f_e8m5_music_final_begin
	dprint("Play_mus_pve_e8m5_final_begin");
	music_set_state('Play_mus_pve_e8m5_final_begin');
end

script static void f_e8m5_music_final_end
	dprint("Play_mus_pve_e8m5_final_end");
	music_set_state('Play_mus_pve_e8m5_final_end');
end

// Phantoms/Wraiths Enter (Phantoms get shot down by AA guns, drop Wraiths in process) -> Wraith Fight -> Level End
script static void f_e8m5_music_phantoms
	dprint("Play_mus_pve_e8m5_phantoms");
	music_set_state('Play_mus_pve_e8m5_phantoms');
end

script static void f_e8m5_music_wraiths
	dprint("Play_mus_pve_e8m5_wraiths");
	music_set_state('Play_mus_pve_e8m5_wraiths');
end

script static void f_e8m5_music_final_wraiths_destroyed
	dprint("Play_mus_pve_e8m5_wraiths_destroyed");
	music_set_state('Play_mus_pve_e8m5_wraiths_destroyed');
end

script static void f_e8m5_music_stop
	dprint("Play_mus_pve_e8m5_finish");
	music_stop('Play_mus_pve_e8m5_finish');
end