//E8M3 Audio Scripts

////////////////////////////////////MAJOR SEQUENCES/FLOW////////////////////////////////////////////////////
// Mission Start
// Enter First Bowl
// Generators Uncloak
// Enter Beach
// Beach Encounter
// Door to Cavern Opens
// Enter Cavern
// Vehicle Bowl Encounter Begin -> Vehicle Bowl Encounter End
// Forerunner Structure Encounter Begin -> Forerunner Structure Encounter End
// Open Back Door/Ambush!
// Final Forerunner Structure Encounter Begin -> Final Forerunner Structure Encounter End
// Discover/Save Switchback
// Extraction Encounter Begin -> Extraction Encounter End
// Mission End

// Mission Start
script static void f_e8m3_music_start
	dprint("Play_mus_pve_e8m3_start");
	music_start('Play_mus_pve_e8m3_start');
end

// Enter First Bowl
script static void f_e8m3_music_first_bowl
	dprint("Play_mus_pve_e8m3_first_bowl");
	music_set_state('Play_mus_pve_e8m3_first_bowl');
end

// Generators Uncloak
script static void f_e8m3_music_generators
	dprint("Play_mus_pve_e8m3_music_generators");
	music_set_state('Play_mus_pve_e8m3_music_generators');
end

// Enter Beach
script static void f_e8m3_music_enter_beach
	dprint("Play_mus_pve_e8m3_music_enter_beach");
	music_set_state('Play_mus_pve_e8m3_music_enter_beach');
end

// Beach Encounter
script static void f_e8m3_music_beach_encounter
	dprint("Play_mus_pve_e8m3_music_beach_encounter");
	music_set_state('Play_mus_pve_e8m3_music_beach_encounter');
end

// Door to Cavern Opens
script static void f_e8m3_music_cavern_door_open
	dprint("Play_mus_pve_e8m3_music_cavern_door_open");
	music_set_state('Play_mus_pve_e8m3_music_cavern_door_open');
end

// Enter Cavern
script static void f_e8m3_music_enter_cavern
	dprint("Play_mus_pve_e8m3_music_enter_cavern");
	music_set_state('Play_mus_pve_e8m3_music_enter_cavern');
end

// Vehicle Bowl Encounter Begin -> Vehicle Bowl Encounter End
script static void f_e8m3_music_bowl_encounter_begin
	dprint("Play_mus_pve_e8m3_music_bowl_encounter_begin");
	music_set_state('Play_mus_pve_e8m3_music_bowl_encounter_begin');
end

script static void f_e8m3_music_bowl_encounter_end
	dprint("Play_mus_pve_e8m3_music_bowl_encounter_end");
	music_set_state('Play_mus_pve_e8m3_music_bowl_encounter_end');
end

// Forerunner Structure Encounter Begin -> Forerunner Structure Encounter End
script static void f_e8m3_music_forerunner_structure_begin
	dprint("Play_mus_pve_e8m3_music_forerunner_structure_begin");
	music_set_state('Play_mus_pve_e8m3_music_forerunner_structure_begin');
end

script static void f_e8m3_music_forerunner_structure_end
	dprint("Play_mus_pve_e8m3_music_forerunner_structure_end");
	music_set_state('Play_mus_pve_e8m3_music_forerunner_structure_end');
end

// Open Back Door/Ambush!
script static void f_e8m3_music_back_door_open
	dprint("Play_mus_pve_e8m3_music_back_door_open");
	music_set_state('Play_mus_pve_e8m3_music_back_door_open');
end

// Final Forerunner Structure Encounter Begin -> Final Forerunner Structure Encounter End
script static void f_e8m3_music_forerunner_structure_2_begin
	dprint("Play_mus_pve_e8m3_music_forerunner_structure_2_begin");
	music_set_state('Play_mus_pve_e8m3_music_forerunner_structure_2_begin');
end

script static void f_e8m3_music_forerunner_structure_2_end
	dprint("Play_mus_pve_e8m3_music_forerunner_structure_2_end");
	music_set_state('Play_mus_pve_e8m3_music_forerunner_structure_2_end');
end

// Discover/Save Switchback
script static void f_e8m3_music_switchback
	dprint("Play_mus_pve_e8m3_music_bowl_switchback");
	music_set_state('Play_mus_pve_e8m3_music_switchback');
end

// Extraction Encounter Begin -> Extraction Encounter End
script static void f_e8m3_music_extraction_begin
	dprint("Play_mus_pve_e8m3_music_extraction_begin");
	music_set_state('Play_mus_pve_e8m3_music_extraction_begin');
end

script static void f_e8m3_music_extraction_end
	dprint("Play_mus_pve_e8m3_music_extraction_end");
	music_set_state('Play_mus_pve_e8m3_extraction_end');
end

// Mission End
script static void f_e8m3_music_stop
	dprint("Play_mus_pve_e8m3_finish");
	music_stop('Play_mus_pve_e8m3_finish');
end