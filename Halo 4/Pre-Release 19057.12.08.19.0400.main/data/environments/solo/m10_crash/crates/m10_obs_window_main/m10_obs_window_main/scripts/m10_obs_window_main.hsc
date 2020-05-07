//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// Mission: 					m10_crash
// script for observatory windows
//										
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343

// === f_init: init function
//script startup instanced f_init()

//end
script static instanced void break(object_name shield, object_name vortex)
	object_hide (this, TRUE);
	sleep(5);
	object_create (vortex);
	thread(physics_wake());
	thread(player_bump());
	sleep(30 * 2);
	object_create(shield);
	object_destroy (vortex);
end 

script static instanced void physics_wake()
	object_wake_physics (player0);
	object_wake_physics (player1);
	object_wake_physics (player2);
	object_wake_physics (player3);
end

script static instanced void player_bump()
	object_move_by_offset (player0, 0, 0, 0, 0.01);
	object_move_by_offset (player1, 0, 0, 0, 0.01);
	object_move_by_offset (player2, 0, 0, 0, 0.01);
	object_move_by_offset (player3, 0, 0, 0, 0.01);
end