// =============================================================================================================================
//========= e6_m5 BREACH SPARTAN OPS SCRIPTS ========================================================
// =============================================================================================================================


//stinger audio
script static void f_e6_m5_stinger_guards
	print ("stinger for the guards playing");
	music_set_state('Play_mus_pve_e06m5_stinger_guards');
end

//stinger audio
script static void f_e6_m5_stinger_other
	print ("stinger for the others playing");
	music_set_state('Play_mus_pve_e06m5_stinger_other');
end


//ALL MUSIC STARTS 
//this begins after the intro and after the player spawns
script static void f_e6_m5_music_start
	print ("all music start");
	music_start('Play_mus_pve_e06m5_start');
end

//this begins after the intro and after the player spawns
script static void f_e6_m5_event0_start
	print ("event0 music start");
	music_set_state('Play_mus_pve_e06m5_player_spawn');
	
end


script static void f_e6_m5_event0_stop
	print ("event0 music stop");
	music_set_state('Play_mus_pve_e06m5_event0_stop');
end

//this begins after all the IFF tags are picked up and the player needs to go back to the main room and defeat all the prometheans
script static void f_e6_m5_event1_start
	print ("event1 music start");
	music_set_state('Play_mus_pve_e06m5_defeat_prometheans');
end

//this stops after all the prometheans are defeated
script static void f_e6_m5_event1_stop
	print ("event1 music stop");
	music_set_state('Play_mus_pve_e06m5_defeat_prometheans_stop');
end

//this begins after the prometheans are defeated and before the player blows the digger legs
script static void f_e6_m5_event2_start
	print ("event2 music start");
	music_set_state('Play_mus_pve_e06m5_blow_legs');
end

//this stops after the player blows the digger legs
script static void f_e6_m5_event2_stop
	print ("event2 music stop");
	music_set_state('Play_mus_pve_e06m5_blow_legs_stop');
end

//this begins after the digger legs, the digger door opens and the covenant run out
script static void f_e6_m5_event3_start
	print ("event3 music start");
	music_set_state('Play_mus_pve_e06m5_digger_opens');
end
	
//this stops after all the covenant are defeated
script static void f_e6_m5_event3_stop
	print ("event3 music stop");
	music_set_state('Play_mus_pve_e06m5_covenant_defeated');
end

//this begins after the prometheans are defeated and before the player disables the digger
script static void f_e6_m5_event4_start
	print ("event4 music start");
	music_set_state('Play_mus_pve_e06m5_disable_digger');
end	

//this stops the digger is disabled
script static void f_e6_m5_event4_stop
	print ("event4 music stop");
	music_set_state('Play_mus_pve_e06m5_disable_digger_stop');
end

//this begins after the digger is disabled and as prometheans are attacking the players
script static void f_e6_m5_event5_start
	print ("event5 music start");
	music_set_state('Play_mus_pve_e06m5_promethean_attack');
end

//this stops after all the prometheans are defeated
script static void f_e6_m5_event5_stop
	print ("event5 music stop");
	music_set_state('Play_mus_pve_e06m5_promethean_attack_stop');
end

//this starts as the players are told to get to the LZ
script static void f_e6_m5_event6_start
	print ("event6 music start");
	music_set_state('Play_mus_pve_e06m5_get_to_lz');
end

//this stops after a player gets to the LZ
script static void f_e6_m5_music_stop
	print ("all music stop");
	music_stop('Play_mus_pve_e06m5_finish');
end