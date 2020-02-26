// =============================================================================================================================
//========= e10_m3 BREACH SPARTAN OPS SCRIPTS ========================================================
// =============================================================================================================================




//ALL MUSIC STARTS 
//this begins after the intro and after the player spawns
script static void f_e10_m3_music_start
	//print ("all music start");
	music_start('Play_mus_pve_e10m3_start');
end

//this begins after the intro and after the player spawns
script static void f_e10_m3_event0_start
	//print ("event0 music start");
	music_set_state('Play_mus_pve_e10m3_player_spawn');
	
end


script static void f_e10_m3_event0_stop
	//print ("event0 music stop");
	music_set_state('Play_mus_pve_e10m3_event0_stop');
end

//this begins after the player exit the intro structure
script static void f_e10_m3_event1_start
	//print ("event1 music start");
	music_set_state('Play_mus_pve_e10m3_enter_apex');
end

//this stops when the player reaches the first encounter
script static void f_e10_m3_event1_stop
	//print ("event1 music stop");
	music_set_state('Play_mus_pve_e10m3_enter_apex_stop');
end

//this begins after the player start the first cov fights at the door
script static void f_e10_m3_event2_start
	//print ("event2 music start");
	music_set_state('Play_mus_pve_e10m3_cov_door');
end

//the clears the door of enemies
script static void f_e10_m3_event2_stop
	//print ("event2 music stop");
	music_set_state('Play_mus_pve_e10m3_cov_door_stop');
end

//this player enters basin and encounter ghosts
script static void f_e10_m3_event3_start
	//print ("event3 music start");
	music_set_state('Play_mus_pve_e10m3_ghosts');
end
	
//this stops after all the covenant are defeated
script static void f_e10_m3_event3_stop
	//print ("event3 music stop");
	music_set_state('Play_mus_pve_e10m3_ghosts_stop');
end

//knight fight in the forerunner structure
script static void f_e10_m3_event4_start
	//print ("event4 music start");
	music_set_state('Play_mus_pve_e10m3_knight_fight');
end	

//knight fight complete
script static void f_e10_m3_event4_stop
	//print ("event4 music stop");
	music_set_state('Play_mus_pve_e10m3_knight_fight_stop');
end

//lich enters
script static void f_e10_m3_event5_start
	//print ("event5 music start");
	music_set_state('Play_mus_pve_e10m3_lich_begin');
end

//lich fight escalates
script static void f_e10_m3_event5_stop
	//print ("event5 music stop");
	music_set_state('Play_mus_pve_e10m3_lich_begin_stop');
end

//lich fight escalates
script static void f_e10_m3_event6_start
	//print ("event6 music start");
	music_set_state('Play_mus_pve_e10m3_lich_escalation');
end

//this stops when lich moves to broadside defensive position
script static void f_e10_m3_event6_stop
	//print ("event5 music stop");
	music_set_state('Play_mus_pve_e10m3_lich_escalation_stop');
end

//lich is 
script static void f_e10_m3_event7_start
	//print ("event6 music start");
	music_set_state('Play_mus_pve_e10m3_lich_broadside');
end

//this stops when lich moves to broadside defensive position
script static void f_e10_m3_event7_stop
	//print ("event5 music stop");
	music_set_state('Play_mus_pve_e10m3_lich_escalation_stop');
end

//player is on the lich
script static void f_e10_m3_event8_start
	//print ("event6 music start");
	music_set_state('Play_mus_pve_e10m3_lich_onboard');
end

//player is off the lich
script static void f_e10_m3_event8_stop
	//print ("event5 music stop");
	music_set_state('Play_mus_pve_e10m3_lich_onboard_stop');
end

//player races down the hill to the exit
script static void f_e10_m3_event9_start
	//print ("event6 music start");
	music_set_state('Play_mus_pve_e10m3_lich_escape');
end

//player reaches exit
script static void f_e10_m3_event9_stop
	//print ("event5 music stop");
	music_set_state('Play_mus_pve_e10m3_lich_escape_stop');
end

//this stops after a player gets to exit
script static void f_e10_m3_music_stop
	//print ("all music stop");
	music_stop('Play_mus_pve_e10m3_finish');
end

//stinger audio for lich appearance
script static void f_e10_m3_stinger_lich
	//print ("stinger for lich");
	music_set_state('Play_mus_pve_e10m3_stinger_lich');
end

//stinger audio
script static void f_e10_m3_stinger_other
	//print ("stinger for the others playing");
	music_set_state('Play_mus_pve_e10m3_stinger_other');
end
