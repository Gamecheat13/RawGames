// =============================================================================================================================
//========= e6_m3 BREACH SPARTAN OPS SCRIPTS ========================================================
// =============================================================================================================================







//ALL MUSIC STARTS 
//this begins after the intro and after the player spawns
script static void f_e6_m3_music_start()
	//print ("all music start");
	music_start('Play_mus_pve_e06m3_start');
end

//this begins after the intro and after the player spawns
script static void f_e6_m3_event0_start()
	//print ("event0 music start");
	music_set_state('Play_mus_pve_e06m3_player_spawn');
	
end


script static void f_e6_m3_event0_stop()
	//print ("event0 music stop");
	music_set_state('Play_mus_pve_e06m3_event0_stop');
end

//player is told to take out grunts quietly
script static void f_e6_m3_event1_start()
	//print ("event1 music start");
	music_set_state('Play_mus_pve_e06m3_grunts_quiet');
end

//this stops if the alarm is triggered
script static void f_e6_m3_event1_stop()
	//print ("event1 music stop");
	music_set_state('Play_mus_pve_e06m3_grunts_quiet_stop');
end

//this begins if the alarm is set off
script static void f_e6_m3_event2_start()
	//print ("event2 music start");
	music_set_state('Play_mus_pve_e06m3_base_alert');
end

//this stops after the player clears the area of covenant
script static void f_e6_m3_event2_stop()
	//print ("event2 music stop");
	music_set_state('Play_mus_pve_e06m3_base_alert_stop');
end

//this begins when phantom reinforces come in
script static void f_e6_m3_event3_start()
	//print ("event3 music start");
	music_set_state('Play_mus_pve_e06m3_cov_reinforce');
end
	
//this stops after all the covenant are defeated
script static void f_e6_m3_event3_stop()
	//print ("event3 music stop");
	music_set_state('Play_mus_pve_e06m3_cov_reinforce');
end

//this begins after the player enters the secret entrance
script static void f_e6_m3_event4_start()
	//print ("event4 music start");
	music_set_state('Play_mus_pve_e06m3_secret_entrance');
end	

//this stops when the player gets surprised by a camoed zealot
script static void f_e6_m3_event4_stop()
	//print ("event4 music stop");
	music_set_state('Play_mus_pve_e06m3_secret_entrance_stop');
end

//stinger audio
script static void f_e6_m3_stinger_zealot()
	//print ("stinger for zealot");
	music_set_state('Play_mus_pve_e06m3_stinger_zealot');
end

//this begins after player enters space with zealots
script static void f_e6_m3_event5_start()
	//print ("event5 music start");
	music_set_state('Play_mus_pve_e06m3_zealots');
end

//this stops when the player reached the forerunner fortress
script static void f_e6_m3_event5_stop()
	//print ("event5 music stop");
	music_set_state('Play_mus_pve_e06m3_zealots_stop');
end



//this starts when the player start the promethean encounter
script static void f_e6_m3_event6_start()
	//print ("event6 music start");
	music_set_state('Play_mus_pve_e06m3_prometheans_attack');
end

//this stops after all the prometheans are defeated
script static void f_e6_m3_event6_stop()
	//print ("event5 music stop");
	music_set_state('Play_mus_pve_e06m3_prometheans_attack_stop');
end


//this starts when the player start the 2nd promethean encounter
script static void f_e6_m3_event7_start()
	//print ("event6 music start");
	music_set_state('Play_mus_pve_e06m3_2nd_prometheans_attack');
end

//this stops after all the prometheans are defeated
script static void f_e6_m3_event7_stop()
	//print ("event5 music stop");
	music_set_state('Play_mus_pve_e06m3_2nd_prometheans_attack_stop');
end


//this starts when the player fights out to the lz
script static void f_e6_m3_event8_start()
	//print ("event6 music start");
	music_set_state('Play_mus_pve_e06m3_fight_out');
end

//this stops after all the enemies are defeated
script static void f_e6_m3_event8_stop()
	//print ("event5 music stop");
	music_set_state('Play_mus_pve_e06m3_fight_out_stop');
end

//stinger audio for hunters
script static void f_e6_m3_stinger_hunters()
	//print ("stinger for the others playing");
	music_set_state('Play_mus_pve_e06m3_stinger_hunters');
end

//stinger audio for player finding and activating the airstrike terminal
script static void f_e6_m3_stinger_airstrike()
	//print ("stinger for the others playing");
	music_set_state('Play_mus_pve_e06m3_stinger_airstrike');
end


//this stops after a player gets to the LZ
script static void f_e6_m3_music_stop()
	//print ("all music stop");
	music_stop('Play_mus_pve_e06m3_finish');
end


