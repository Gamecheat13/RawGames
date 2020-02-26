//E9M2 Audio Scripts

////////////////////////////////////MAJOR SEQUENCES/FLOW////////////////////////////////////////////////////
// Mission Start
// First Console Accessed
// Second Encounter Begin -> Second Encounter End
// Second Console Accessed
// Arrive at Third Console
// Covenant Wave
// Escalate to Forerunners
// Third Console Accessed
// OH GOD TOO MANY FORERUNNERS -> Explosion time
// Mission End

// Mission Start
script static void f_e9m2_music_start
	dprint("Play_mus_pve_e9m2_start");
	music_start('Play_mus_pve_e9m2_start');
end

// First Console Accessed
script static void f_e9m2_music_console_1
	dprint("Play_mus_pve_e9m2_console_1");
	music_set_state('Play_mus_pve_e9m2_console_1');
end

// Second Encounter Begin -> Second Encounter End
script static void f_e9m2_music_second_begin
	dprint("Play_mus_pve_e9m2_second_begin");
	music_set_state('Play_mus_pve_e9m2_second_begin');
end

script static void f_e9m2_music_second_end
	dprint("Play_mus_pve_e9m2_second_end");
	music_set_state('Play_mus_pve_e9m2_second_end');
end

// Second Console Accessed
script static void f_e9m2_music_console_2
	dprint("Play_mus_pve_e9m2_music_console_2");
	music_set_state('Play_mus_pve_e9m2_music_console_2');
end

// Arrive at Third Console
script static void f_e9m2_music_console_3_arrival
	dprint("Play_mus_pve_e9m2_music_console_3_arrival");
	music_set_state('Play_mus_pve_e9m2_music_console_3_arrival');
end

// Covenant Wave
script static void f_e9m2_music_final_covies
	dprint("Play_mus_pve_e9m2_music_final_covies");
	music_set_state('Play_mus_pve_e9m2_music_final_covies');
end

// Escalate to Forerunners
script static void f_e9m2_music_final_forerunners
	dprint("Play_mus_pve_e9m2_music_final_forerunners");
	music_set_state('Play_mus_pve_e9m2_music_final_forerunners');
end

// Third Console Accessed
script static void f_e9m2_music_console_3_accessed
	dprint("Play_mus_pve_e9m2_music_console_3_accessed");
	music_set_state('Play_mus_pve_e9m2_music_console_3_accessed');
end

// OH GOD TOO MANY FORERUNNERS -> Explosion time
script static void f_e9m2_music_overwhelm
	dprint("Play_mus_pve_e9m2_music_overwhelm");
	music_set_state('Play_mus_pve_e9m2_music_overwhelm');
end

script static void f_e9m2_music_air_strike
	dprint("Play_mus_pve_e9m2_music_air_strike");
	music_set_state('Play_mus_pve_e9m2_music_air_strike');
end

// Mission End
script static void f_e9m2_music_stop
	dprint("Play_mus_pve_e9m2_finish");
	music_stop('Play_mus_pve_e9m2_finish');
end