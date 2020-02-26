// =============================================================================================================================
//========= e10_m2 CAVERNS SPARTAN OPS SCRIPTS ========================================================
// =============================================================================================================================

//ALL MUSIC STARTS 
//this begins after the intro and after the player spawns
script static void f_e10_m2_music_start
	print ("all music start");
	music_start('Play_mus_pve_e010m2_start');
end




//this begins after the intro and after the player spawns
script static void f_e10_m2_event0_start
	print ("event0 music start");
	music_set_state('Play_mus_pve_e010m2_player_spawn');
end

//this stops when the door gets unlocked
script static void f_e10_m2_event0_stop
	print ("event0 music stop");
	music_set_state('Play_mus_pve_e010m2_event0_stop');
end




//this begins when the player enters cave
script static void f_e10_m2_event1_start
	print ("event1 music start");
	music_set_state('Play_mus_pve_e010m2_enter_caves');
end

//this stops when the player gets to the back door
script static void f_e10_m2_event1_stop
	print ("event1 music stop");
	music_set_state('Play_mus_pve_e010m2_enter_caves_stop');
end




//this starts when the player is told to turn on the lightbridges
script static void f_e10_m2_event2_start
	print ("event2 music start");
	music_set_state('Play_mus_pve_e010m2_lightbridge');
end

//this stops when the player reaches the top power control room
script static void f_e10_m2_event2_stop
	print ("event2 music stop");
	music_set_state('Play_mus_pve_e010m2_lightbridge_stop');
end




//this begins when the player turns on the main power switch
script static void f_e10_m2_event3_start
	print ("event3 music start");
	music_set_state('Play_mus_pve_e010m2_main_power');
end
	
//this stops when the player reaches the 2nd power area
script static void f_e10_m2_event3_stop
	print ("event3 music stop");
	music_set_state('Play_mus_pve_e010m2_main_power_stop');
end




//this begins after player gets to 2nd power area
script static void f_e10_m2_event4_start
	print ("event4 music start");
	music_set_state('Play_mus_pve_e010m2_power_area2');
end	

//this stops when the player reaches the 1st power area
script static void f_e10_m2_event4_stop
	print ("event4 music stop");
	music_set_state('Play_mus_pve_e010m2_power_area2_stop');
end




//this begins after player gets to 1st power area
script static void f_e10_m2_event5_start
	print ("event5 music start");
	music_set_state('Play_mus_pve_e010m2_power_area1');
end

//this stops when the power is on at all 3 and the switch is back
script static void f_e10_m2_event5_stop
	print ("event5 music stop");
	music_set_state('Play_mus_pve_e010m2_power_area1_stop');
end




//this starts when the player is going to the final button
script static void f_e10_m2_event6_start
	print ("event6 music start");
	music_set_state('Play_mus_pve_e010m2_final_button');
end

//this stops after the back door is open
script static void f_e10_m2_event6_stop
	print ("event6 music stop");
	music_set_state('Play_mus_pve_e010m2_final_button_stop');
end




//this starts when the final sprint to the door is active
script static void f_e10_m2_event7_start
	print ("event7 music start");
	music_set_state('Play_mus_pve_e010m2_door_open');
end

//this stops when the player reaches the exit trigger
script static void f_e10_m2_event7_stop
	print ("event7 music stop");
	music_set_state('Play_mus_pve_e010m2_door_open_stop');
end






//stinger audio - For the derezzed switch
script static void f_e10_m2_stinger_derezzed_switch
	print ("stinger for the guards playing");
	music_set_state('Play_mus_pve_e010m2_stinger_switch');
end




//stinger audio - for power core main
script static void f_e10_m2_stinger_power_core_main
	print ("stinger for the others playing");
	music_set_state('Play_mus_pve_e010m2_stinger_main_power');
end




//stinger audio - for power core 1
script static void f_e10_m2_stinger_power_core_1
	print ("stinger for the others playing");
	music_set_state('Play_mus_pve_e010m2_stinger_power_1');
end



//stinger audio - for power core 2
script static void f_e10_m2_stinger_power_core_2
	print ("stinger for the others playing");
	music_set_state('Play_mus_pve_e010m2_stinger_power_2');
end




//this stops after a player gets to the back door
script static void f_e10_m2_music_stop
	print ("all music stop");
	music_stop('Play_mus_pve_e010m2_finish');
end