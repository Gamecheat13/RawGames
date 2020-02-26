// =============================================================================================================================
/*
                                                                                                       
 _______   ___      .___  ___.  ____           ___      __    __   _______   __    ______   
|   ____| / _ \     |   \/   | |___ \         /   \    |  |  |  | |       \ |  |  /  __  \  
|  |__   | (_) |    |  \  /  |   __) |       /  ^  \   |  |  |  | |  .--.  ||  | |  |  |  | 
|   __|   \__, |    |  |\/|  |  |__ <       /  /_\  \  |  |  |  | |  |  |  ||  | |  |  |  | 
|  |____    / /     |  |  |  |  ___) |     /  _____  \ |  `--'  | |  '--'  ||  | |  `--'  | 
|_______|  /_/      |__|  |__| |____/     /__/     \__\ \______/  |_______/ |__|  \______/  
                                                                                           
*/
// =============================================================================================================================


//==== stinger audio


//-- stinger for when a barrier is destroyed
script static void f_e9m3_stinger_barrier_destroyed
	print ("f_e9m3_stinger_barrier_destroyed: stinger for when a barrier is destroyed");
	music_set_state('Play_mus_pve_e9m3_barrier_destroyed');
end

//-- stinger for when a phantom is stripped of all its guns
script static void f_e9m3_stinger_phantom_stripped
	print ("f_e9m3_stinger_phantom_stripped: stinger for when a phantom is stripped of all its guns");
	music_set_state('Play_mus_pve_e9m3_phantom_stripped');
end


//==ALL MUSIC START 
// this begins after the intro and after the player spawns
script static void f_e9m3_music_start
	print ("all music start");
	music_start('Play_mus_pve_e9m3_start');
end

//====== MUSIC START/STOPS
//== first battle
// music for first battle segment. Starts when the player spawns in
script static void f_e9m3_music_first_battle_start
	print ("f_e9m3_music_first_battle_start: music for first battle segment. Starts when the player spawns in");
	music_set_state('Play_mus_pve_e9m3_first_battle_start');
end

// stops when the player has destroyed the last enemy prior to the first barrier
script static void f_e9m3_music_first_battle_stop
	print ("f_e9m3_music_first_battle_stop: stops when the player has destroyed the last enemy prior to the first gate");
	music_set_state('Play_mus_pve_e9m3_first_battle_stop');
end

//== first barrier
// music for the first barrier interaction and the shortly thereafter. no combat.
script static void f_e9m3_music_first_barrier_start
	print ("f_e9m3_music_first barrier_start: music for the first barrier interaction and the shortly thereafter. no combat.");
	music_set_state('Play_mus_pve_e9m3_first_barrier_start');
end

// stops after the player crosses the barrier, shortly before the ambush
script static void f_e9m3_music_first_barrier_stop
	print ("f_e9m3_music_first barrier_stop: stops after the player crosses the barrier, shortly before the ambush");
	music_set_state('Play_mus_pve_e9m3_first_barrier_stop');
end

//== ambush
// music for the ambush segment. Starts when the gate goes up and the phantom pops up over the ridge.
script static void f_e9m3_music_ambush_start
	print ("f_e9m3_music_ambush_start: music for the ambush segment. Starts when the gate goes up and the phantom pops up over the ridge.");
	music_set_state('Play_mus_pve_e9m3_ambush_start');
end

// stops when objective switches to "advance on foot"
script static void f_e9m3_music_ambush_stop
	print ("f_e9m3_music_ambush_stop: stops when objective switches to 'advance on foot'");
	music_set_state('Play_mus_pve_e9m3_ambush_stop');
end

//== on_foot
// music for the on foot segment as the player makes their way up hillside 
script static void f_e9m3_music_on_foot_start
	print ("f_e9m3_music_on_foot_start: music for the on foot segment as the player makes their way up hillside");
	music_set_state('Play_mus_pve_e9m3_on_foot_start');
end

// stops during the garrison encounter when the miniboss phantom appears
script static void f_e9m3_music_on_foot_stop
	print ("f_e9m3_music_on_foot_stop: stops when players arrive at the garrison encounter with the miniboss");
	music_set_state('Play_mus_pve_e9m3_on_foot_stop');
end

//== mini_boss
// music for the mini-boss segment of the garrison encounter. starts when the miniboss phantom appears.
script static void f_e9m3_music_mini_boss_start
	print ("f_e9m3_music_mini_boss_start: music for the mini-boss segment of the garrison encounter. starts when the miniboss phantom appears.");
	music_set_state('Play_mus_pve_e9m3_mini_boss_start');
end

// stops when the garrison encounter is complete and the last enemy is dead.
script static void f_e9m3_music_mini_boss_stop
	print ("f_e9m3_music_mini_boss_stop: stops when the garrison encounter is complete and the last enemy is dead.");
	music_set_state('Play_mus_pve_e9m3_mini_boss_stop');
end

//== roll_onward
// music for traveling through the caves, up to the finale. Mysterious and anxious- What could be in store for us up there, I wonder? 
script static void f_e9m3_music_roll_onward_start
	print ("f_e9m3_music_roll_onward_start: music for traveling through the caves, up to the finale.");
	music_set_state('Play_mus_pve_e9m3_roll_onward_start');
end

// stops when players reach the aerie
script static void f_e9m3_music_roll_onward_stop
	print ("f_e9m3_music_roll_onward_stop: stops when players reach the aerie");
	music_set_state('Play_mus_pve_e9m3_roll_onward_stop');
end

//== grand_finale
// music for final battle
script static void f_e9m3_music_grand_finale_start
	print ("f_e9m3_music_grand_finale_start: music for final battle");
	music_set_state('Play_mus_pve_e9m3_grand_finale_start');
end

// stops when all enemies dead
script static void f_e9m3_music_grand_finale_stop
	print ("f_e9m3_music_grand_finale_stop: stops when all enemies dead");
	music_set_state('Play_mus_pve_e9m3_grand_finale_stop');
end

//== mop_up
// music for after final big battle. The players seek out and interact with a communications widget.
script static void f_e9m3_music_mop_up_start
	print ("f_e9m3_music_mop_up_start: music for after final big battle. The players seek out and interact with a communications widget.");
	music_set_state('Play_mus_pve_e9m3_mop_up_start');
end

// stops when mission's complete
script static void f_e9m3_music_mop_up_stop
	print ("f_e9m3_music_mop_up_stop: stops when mission's complete");
	music_set_state('Play_mus_pve_e9m3_mop_up_stop');
end


//==== ALL DONE
// player is headed up to the (allied) phantom
script static void f_e9m3_music_stop
	print ("all music stop");
	music_stop('Play_mus_pve_e9m3_finish');
end



/*  // copy & paste template ---->

//==
// music for 
script static void f_e9m3_music__start
	print (": ");
	music_set_state('Play_mus_pve_e9m3__start');
end

// stops when
script static void f_e9m3_music__stop
	print (": ");
	music_set_state('Play_mus_pve_e9m3__stop');
end

*/