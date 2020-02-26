// =============================================================================================================================
//========= e10_m5 BREACH SPARTAN OPS SCRIPTS ========================================================
// =============================================================================================================================


//stinger for when the world starts shaking after the artifact is turned off
script static void f_e10_m5_stinger_artifact
	print ("stinger for the guards playing");
	music_set_state('Play_mus_pve_e10m5_stinger_artifact');
end

//stinger for when the gravity goes wonky
script static void f_e10_m5_stinger_gfravity
	print ("stinger for the guards playing");
	music_set_state('Play_mus_pve_e10m5_stinger_gravity');
end

//stinger audio
script static void f_e10_m5_stinger_other
	print ("stinger for the others playing");
	music_set_state('Play_mus_pve_e10m5_stinger_other');
end


//ALL MUSIC STARTS 
//this begins at the intro
script static void f_e10_m5_music_start
	print ("all music start");
	music_start('Play_mus_pve_e10m5_start');
end

//this begins after the intro and after the player spawns
script static void f_e10_m5_event0_start
	print ("event0 music start");
	music_set_state('Play_mus_pve_e10m5_player_spawn');
	
end

//this stops when the player reaches the rock wall
script static void f_e10_m5_event0_stop
	print ("event0 music stop");
	music_set_state('Play_mus_pve_e10m5_event0_stop');
end

//this begins when the player engages the Covenant forces on the way to the Harvester
script static void f_e10_m5_event1_start
	print ("event1 music start");
	music_set_state('Play_mus_pve_e10m5_defeat_covenant');
end

//this stops after all the Covenant forces are defeated
script static void f_e10_m5_event1_stop
	print ("event1 music stop");
	music_set_state('Play_mus_pve_e10m5_defeat_covenant_stop');
end

//this begins after the covenant are defeated and the player is told to power up the Harvester
script static void f_e10_m5_event2_start
	print ("event2 music start");
	music_set_state('Play_mus_pve_e10m5_powerup_harvester');
end

//this stops after the player powers up the harvesters and the door to the firing chamber opens
script static void f_e10_m5_event2_stop
	print ("event2 music stop");
	music_set_state('Play_mus_pve_e10m5_powerup_harvester_stop');
end

//this begins after player presses the button to begin the harvester vignette
script static void f_e10_m5_event3_start
	print ("event3 music start");
	music_set_state('Play_mus_pve_e10m5_harvester_fires');
end
	
//this stops after the harvester firing vignette is complete
script static void f_e10_m5_event3_stop
	print ("event3 music stop");
	music_set_state('Play_mus_pve_e10m5_harvester_fires_stop');
end

//this begins as the player encounters the promethean resistance inside the cave
script static void f_e10_m5_event4_start
	print ("event4 music start");
	music_set_state('Play_mus_pve_e10m5_cave_battle_start');
end	

//this stops the prometheans are defeated
script static void f_e10_m5_event4_stop
	print ("event4 music stop");
	music_set_state('Play_mus_pve_e10m5_cave_battle_stop');
end

//this begins when the player is told to head down to turn on the power to the artifact entrance
script static void f_e10_m5_event5_start
	print ("event5 music start");
	music_set_state('Play_mus_pve_e10m5_door_power_attack_start');
end

//this stops after the player powers up the artifact entrance
script static void f_e10_m5_event5_stop
	print ("event5 music stop");
	music_set_state('Play_mus_pve_e10m5_door_power_attack_stop');
end

//this starts as the players enter the artifact chamber
script static void f_e10_m5_event6_start
	print ("event6 music start");
	music_set_state('Play_mus_pve_e10m5_artifact_start');
end

//this stops as the player activates the artifact
script static void f_e10_m5_event6_stop
	print ("all music stop");
	music_stop('Play_mus_pve_e10m5_artifact_stop');
end

//this starts as the world starts shaking and the player is directed to escape
script static void f_e10_m5_event7_start
	print ("event6 music start");
	music_set_state('Play_mus_pve_e10m5_exit_requium_start');
end

//this stops as the player enters the lower cave
script static void f_e10_m5_event7_stop
	print ("event6 music start");
	music_set_state('Play_mus_pve_e10m5_exit_requium_stop');
end

//this starts as the final contingent of Covenant zealots attack the player
script static void f_e10_m5_event8_start
	print ("event6 music start");
	music_set_state('Play_mus_pve_e10m5_zealot_attack_start');
end

//this stops after the player kills all of the Covenant zealots
script static void f_e10_m5_event8_stop
	print ("event6 music start");
	music_set_state('Play_mus_pve_e10m5_zealot_attack_stop');
end

//this starts when the player is waiting for the Pelican to arrive and pick them up
script static void f_e10_m5_event9_start
	print ("event6 music start");
	music_set_state('Play_mus_pve_e10m5_need_a_ride_start');
end

//this stop as the player enters the pelican
script static void f_e10_m5_event9_stop
	print ("event6 music start");
	music_set_state('Play_mus_pve_e10m5_need_a_ride_stop');
end

//this plays as the outro vignette starts
script static void f_e10_m5_event10_start
	print ("event6 music start");
	music_set_state('Play_mus_pve_e10m5_outro_start');
end

//this stops as the outro ends
script static void f_e10_m5_event10_stop
	print ("event6 music start");
	music_set_state('Play_mus_pve_e10m5_outro_stop');
end