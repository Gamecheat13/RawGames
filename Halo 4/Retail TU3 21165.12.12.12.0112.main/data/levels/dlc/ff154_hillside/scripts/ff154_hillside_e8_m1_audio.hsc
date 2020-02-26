// =============================================================================================================================
// =============================================================================================================================


//stinger audio
//script static void f_e8_m1_stinger_guards
//	print ("stinger for the guards playing");
//	music_set_state('Play_mus_pve_e08_m1_stinger_guards');
//end

////stinger audio
//script static void f_e8_m1_stinger_other
//	print ("stinger for the others playing");
//	music_set_state('Play_mus_pve_e08_m1_stinger_other');
//end


//ALL MUSIC STARTS 
//this begins after the intro and after the player spawns
script static void f_e8_m1_music_start
	print ("all music start");
	music_start('Play_mus_pve_e08_m1_start');
end

//this begins after the intro and after the player spawns
script static void f_e8_m1_event0_start
	print ("event0 music start");
	music_set_state('Play_mus_pve_e08_m1_player_spawn');
	
end


script static void f_e8_m1_event0_stop
	print ("event0 music stop");
	music_set_state('Play_mus_pve_e08_m1_player_spawn_stop');
end

//all guys are dead and the cave switch is marked
script static void f_e8_m1_event1_start
	print ("event1 music start");
	music_set_state('Play_mus_pve_e08_m1_blow_barrier');
end

//cave switch is pushed, barrier isn't broken yet
script static void f_e8_m1_event1_stop
	print ("event1 music stop");
	music_set_state('Play_mus_pve_e08_m1_blow_barrier_stop');
end

//player is told to go through cave and shut down first portal
script static void f_e8_m1_event2_start
	print ("event2 music start");
	music_set_state('Play_mus_pve_e08_m1_first_portal_start');
end

//player has shut down the first portal, before portal machine closes
script static void f_e8_m1_event2_stop
	print ("event2 music stop");
	music_set_state('Play_mus_pve_e08_m1_first_portal_down');
end

//player is told to shut down second portal
script static void f_e8_m1_event3_start
	print ("event3 music start");
	music_set_state('Play_mus_pve_e08_m1_second_portal_start');
end
	
//player has shut down the second portal, before portal machine closes
script static void f_e8_m1_event3_stop
	print ("event3 music stop");
	music_set_state('Play_mus_pve_e08_m1_second_portal_down');
end

//player is told to shut down third portal
script static void f_e8_m1_event4_start
	print ("event4 music start");
	music_set_state('Play_mus_pve_e08_m1_third_portal_start');
end	

//player has shut down the third portal, before portal machine closes
script static void f_e8_m1_event4_stop
	print ("event4 music stop");
	music_set_state('Play_mus_pve_e08_m1_third_portal_down');
end

//player is told to fight wraith
script static void f_e8_m1_event5_start
	print ("event5 music start");
	music_set_state('Play_mus_pve_e08_m1_wraith_fight_start');
end

//wraith is dead, 
script static void f_e8_m1_event5_stop
	print ("event5 music stop");
	music_set_state('Play_mus_pve_e08_m1_wraith_defeated');
end

//players are told to go mark forerunner area
script static void f_e8_m1_event6_start
	print ("event6 music start");
	music_set_state('Play_mus_pve_e08_m1_mark_forerunner_area');
end

//forerunner area is marked, drop pods aren't down yet
script static void f_e8_m1_event6_stop
	print ("event5 music stop");
	music_set_state('Play_mus_pve_e08_m1_area_marked');
end

//drop pods have fallen, player is told to kill all the enemies
script static void f_e8_m1_event7_start
	print ("event5 music start");
	music_set_state('Play_mus_pve_e08_m1_kill_all_enemies_start');
end

//all enemies are killed
script static void f_e8_m1_event7_stop
	print ("event5 music stop");
	music_set_state('Play_mus_pve_e08_m1_all_enemies_killed');
end

//player is told to mark the LZ
script static void f_e8_m1_event8_start
	print ("event5 music start");
	music_set_state('Play_mus_pve_e08_m1_mark_lz');
end

//this stops after a player marks the LZ
script static void f_e8_m1_music_stop
	print ("all music stop");
	music_stop('Play_mus_pve_e08_m1_finish');
end