// =============================================================================================================================
//========= e10_m1 BREACH SPARTAN OPS SCRIPTS ========================================================
// =============================================================================================================================

//ALL MUSIC STARTS 
//this begins after the intro and after the player spawns
script static void f_e10_m1_music_start
	print ("all music start");
	music_start('Play_mus_pve_e010m1_start');
end




//this begins after the intro and after the player spawns
script static void f_e10_m1_event0_start
	print ("event0 music start");
	music_set_state('Play_mus_pve_e010m1_player_spawn');
end

//this stops when the player reaches the rock wall
script static void f_e10_m1_event0_stop
	print ("event0 music stop");
	music_set_state('Play_mus_pve_e010m1_event0_stop');
end




//this begins when the 1st drop pods fall
script static void f_e10_m1_event1_start
	print ("event1 music start");
	music_set_state('Play_mus_pve_e010m1_drop_pods');
end

//this stops when the objective changes to go up the hill
script static void f_e10_m1_event1_stop
	print ("event1 music stop");
	music_set_state('Play_mus_pve_e010m1_drop_pods_stop');
end




//this starts when the player starts to go up the hill towards the AA
script static void f_e10_m1_event2_start
	print ("event2 music start");
	music_set_state('Play_mus_pve_e010m1_go_to_aa');
end

//this stops when the player gets to the AA
script static void f_e10_m1_event2_stop
	print ("event2 music stop");
	music_set_state('Play_mus_pve_e010m1_go_to_aa_stop');
end




//this begins when the shields to the AA guns go down.
script static void f_e10_m1_event3_start
	print ("event3 music start");
	music_set_state('Play_mus_pve_e010m1_shields_down');
end
	
//this stops after the 1st 2 guns are down
script static void f_e10_m1_event3_stop
	print ("event3 music stop");
	music_set_state('Play_mus_pve_e010m1_shields_down_stop');
end




//this begins after the player is told to get the next AA gun
script static void f_e10_m1_event4_start
	print ("event4 music start");
	music_set_state('Play_mus_pve_e010m1_next_aa');
end	

//this stops when the 3rd AA gun is down
script static void f_e10_m1_event4_stop
	print ("event4 music stop");
	music_set_state('Play_mus_pve_e010m1_next_aa_stop');
end




//this begins after the player is told to go back to the harvester
script static void f_e10_m1_event5_start
	print ("event5 music start");
	music_set_state('Play_mus_pve_e010m1_back_to_harvester');
end

//this stops after the player arrives at the harvester
script static void f_e10_m1_event5_stop
	print ("event5 music stop");
	music_set_state('Play_mus_pve_e010m1_back_to_harvester_stop');
end




//this starts as the Pelican flies in to blow up the door
script static void f_e10_m1_event6_start
	print ("event6 music start");
	music_set_state('Play_mus_pve_e010m1_blow_door');
end

//this stops after the door is blow and the player is told to go in the harvester
script static void f_e10_m1_event6_stop
	print ("event6 music stop");
	music_set_state('Play_mus_pve_e010m1_blow_door_stop');
end




//this starts as the Player enters the harvester
script static void f_e10_m1_event7_start
	print ("event7 music start");
	music_set_state('Play_mus_pve_e010m1_enter_harvester');
end

//this stops when all enemies are dead
script static void f_e10_m1_event7_stop
	print ("event7 music stop");
	music_set_state('Play_mus_pve_e010m1_enter_harvester_stop');
end




//this starts as the scientist tell Crimson to check out the power
script static void f_e10_m1_event8_start
	print ("event8 music start");
	music_set_state('Play_mus_pve_e010m1_look_at_power');
end

//this stops when Crimosn leaves the harvester
script static void f_e10_m1_event8_stop
	print ("event8 music stop");
	music_set_state('Play_mus_pve_e010m1_look_at_power_stop');
end




//stinger audio - For the phantom that drops off 2 hunters at AA gun3
script static void f_e10_m1_stinger_hunters
	print ("stinger for the guards playing");
	music_set_state('Play_mus_pve_e010m1_stinger_hunters');
end




//stinger audio - for the shield door blowing up
script static void f_e10_m1_stinger_door
	print ("stinger for the others playing");
	music_set_state('Play_mus_pve_e010m1_stinger_door');
end




//this stops after a player gets to the LZ
script static void f_e10_m1_music_stop
	print ("all music stop");
	music_stop('Play_mus_pve_e010m1_finish');
end