// =============================================================================================================================
//========= e9_m1 BREACH SPARTAN OPS SCRIPTS ========================================================
// =============================================================================================================================


//stinger for when the world starts shaking after the artifact is turned off
script static void f_e9_m1_stinger_artifact
	print ("stinger for the guards playing");
	music_set_state('Play_mus_pve_e9m1_stinger_artifact');
end

//stinger for when the beam activates
script static void f_e9_m1_stinger_beam
	if not object_valid(spops_dm_e9m1_beam_sfx) then 
		object_create(spops_dm_e9m1_beam_sfx);
	end
	print ("stinger for the guards playing");
	music_set_state('Play_mus_pve_e9m1_stinger_beam');
end

//stinger for sentinels showing up
script static void f_e9_m1_stinger_sentinel
	print ("stinger for the others playing");
	music_set_state('Play_mus_pve_e9m1_stinger_sentinel');
end


//ALL MUSIC STARTS 
//this begins at the intro
script static void f_e9_m1_music_start
	print ("all music start");
	music_start('Play_mus_pve_e9m1_start');
end

//this begins after the intro and after the player spawns
script static void f_e9_m1_event0_start
	print ("event0 music start");
	music_set_state('Play_mus_pve_e9m1_player_spawn');
	
end

//this stops when the player takes out the initial enemies, but before the phantom comes in
script static void f_e9_m1_event0_stop
	print ("event0 music stop");
	music_set_state('Play_mus_pve_e9m1_event0_stop');
end

//this begins when the phantom spawns, bringing Covenant reinforcements
script static void f_e9_m1_event1_start
	print ("event1 music start");
	music_set_state('Play_mus_pve_e9m1_defeat_covenant');
end

//this stops after all the Covenant forces are defeated
script static void f_e9_m1_event1_stop
	print ("event1 music stop");
	music_set_state('Play_mus_pve_e9m1_defeat_covenant_stop');
end

//this begins after the door dissolves, reveals more enemies
script static void f_e9_m1_event2_start
	print ("event2 music start");
	music_set_state('Play_mus_pve_e9m1_magic_door_enemies_start');
end

//this stops after the player finishes off the enemies
script static void f_e9_m1_event2_stop
	print ("event2 music stop");
	music_set_state('Play_mus_pve_e9m1_magic_door_enemies_stop');
end

//this begins after player hits the button to trace the communications
script static void f_e9_m1_event3_start
	print ("event3 music start");
	music_set_state('Play_mus_pve_e9m1_trace_comms_start');
end
	
//this stops when the player is directed toword the power source reading nearby
script static void f_e9_m1_event3_stop
	print ("event3 music stop");
	music_set_state('Play_mus_pve_e9m1_trace_comms_stop');
end

//this begins as the player encounters the promethean resistance outside the power source
script static void f_e9_m1_event4_start
	print ("event4 music start");
	music_set_state('Play_mus_pve_e9m1_promethean_attack_start');
end	

//this stops the prometheans are defeated
script static void f_e9_m1_event4_stop
	print ("event4 music stop");
	music_set_state('Play_mus_pve_e9m1_promethean_attack_stop');
end

//this begins when the player activates 3 of the defense turrets and the enemies start showing up
script static void f_e9_m1_event5_start
	print ("event5 music start");
	music_set_state('Play_mus_pve_e9m1_defense_start');
end

//this stops after the player defeats all the enemy waves
script static void f_e9_m1_event5_stop
	print ("event5 music stop");
	music_set_state('Play_mus_pve_e9m1_defense_stop');
end

//this starts as the sentinals fly up to activate the beam
script static void f_e9_m1_event6_start
	print ("event6 music start");
	music_set_state('Play_mus_pve_e9m1_sentinel_activation_start');
end

//this stops as the pelican is dispatched to pick up the player
script static void f_e9_m1_event6_stop
	print ("all music stop");
	music_stop('Play_mus_pve_e9m1_sentinel_activation_stop');
end

