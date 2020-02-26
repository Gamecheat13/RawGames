//=============================================================================================================================
//============================================ E10M4 CAVERNS AUDIO SCRIPT ================================================
//=============================================================================================================================

//	Music Start
script static void aud_e10m4_music_start()
	print ("all music start");
	music_start('Play_mus_pve_e10_m4_start');
end


//	Music for Player Spawn
script static void aud_e10m4_player_start()
	print ("Player Spawn music start");
	music_set_state('Play_mus_pve_e10_m4_playerspawn_start');
end


//	Player is told of the downed Pelican and Mantis available
script static void aud_e10m4_pelican_mantis()
	print ("Player must get to downed pelican and mantis music start");
	music_set_state('Play_mus_pve_e10_m4_pelican_mantis');
end


//	Player enters Mantis
script static void aud_e10m4_mantis_enter()
	print ("Player enters Mantis");
	music_set_state('Play_mus_pve_e10_m4_enter_mantis');
end


//	Phantom arrives and drops off troops
script static void aud_e10m4_phantom_arrives()
	print ("Phantom arrives music start");
	music_set_state('Play_mus_pve_e10_m4_phantom_arrives');
end


//	Enemy Drop pod arrives
script static void aud_e10m4_droppod()
	print ("droppod music start");
	music_set_state('Play_mus_pve_e10_m4_droppod');
end


//	Forerunner reinforcements arrive 01
script static void aud_e10m4_fore_reinforcements01()
	print ("Forerunner reinforcements music start");
	music_set_state('Play_mus_pve_e10_m4_fore_reinforcements01');
end


//	Forerunner reinforcements arrive 02
script static void aud_e10m4_fore_reinforcements02()
	print ("Forerunner reinforcements 02 music start");
	music_set_state('Play_mus_pve_e10_m4_fore_reinforcements02');
end


//	Bishop reinforcements 01
script static void aud_e10m4_bish_reinforcements01()
	print ("1st Bishops arrive music start");
	music_set_state('Play_mus_pve_e10_m4_bish_reinforcements01');
end


//	Bishop reinforcements 02
script static void aud_e10m4_bish_reinforcements02()
	print ("2nd Bishops arrive music start");
	music_set_state('Play_mus_pve_e10_m4_bish_reinforcements02');
end


//	Bishop reinforcements 03
script static void aud_e10m4_bish_reinforcements03()
	print ("3rd Bishops arrive music start");
	music_set_state('Play_mus_pve_e10_m4_bish_reinforcements03');
end


//	Bishop reinforcements 04
script static void aud_e10m4_bish_reinforcements04()
	print ("4th Bishops arrive music start");
	music_set_state('Play_mus_pve_e10_m4_bish_reinforcements04');
end


//	Bishop reinforcements 05
script static void aud_e10m4_bish_reinforcements05()
	print ("5th Bishops arrive music start");
	music_set_state('Play_mus_pve_e10_m4_bish_reinforcements05');
end


//	Bishop reinforcements 06
script static void aud_e10m4_bish_reinforcements06()
	print ("6th Bishops arrive music start");
	music_set_state('Play_mus_pve_e10_m4_bish_reinforcements06');
end


//	Bishop reinforcements 07
script static void aud_e10m4_bish_reinforcements07()
	print ("7th Bishops arrive music start");
	music_set_state('Play_mus_pve_e10_m4_bish_reinforcements07');
end


//	Player is told to destroy two orbs
script static void aud_e10m4_orbs()
	print ("Destroy orbs music start");
	music_set_state('Play_mus_pve_e10_m4_destroy_orbs');
end


//	Two orbs destroyed, final object revealed
script static void aud_e10m4_final_object()
	print ("Final object destroy music start");
	music_set_state('Play_mus_pve_e10_m4_final_object');
end


//	Final object destroyed
script static void aud_e10m4_all_destroyed()
	print ("all objects destroyed music start");
	music_set_state('Play_mus_pve_e10_m4_objects_destroyed');
end


//	Pawn reinforcements
script static void aud_e10m4_pawns()
	print ("pawns reinforcement music start");
	music_set_state('Play_mus_pve_e10_m4_pawns');
end


//	Player discovers locked door
script static void aud_e10m4_lockeddoor()
	print ("Locked door music start");
	music_set_state('Play_mus_pve_e10_m4_lockeddoor');
end


//	Enemy reinforcements
script static void aud_e10m4_enemy_reinforcements()
	print ("mixed enemy reinforcements music start");
	music_set_state('Play_mus_pve_e10_m4_enemy_reinforcements');
end


//	Player unlocks door
script static void aud_e10m4_door_opened()
	print ("Door opened music start");
	music_set_state('Play_mus_pve_e10_m4_door_opened');
end


//	Pelican Arrives during firefight
script static void aud_e10m4_pelican_arrives()
	print ("pelican_arrives music start");
	music_set_state('Play_mus_pve_e10_m4_pelican_arrives');
end


//	All AI killed
script static void aud_e10m4_ai_dead()
	print ("All AI is dead music start");
	music_set_state('Play_mus_pve_e10_m4_ai_dead');
end


//	Pelican is ready for Evac
script static void aud_e10m4_evac()
	print ("Evac ready music start");
	music_set_state('Play_mus_pve_e10_m4_evac');
end


//	Music stop
script static void aud_e10m4_stop_music()
	print ("all music stop");
	music_stop('Play_mus_pve_e10_m4_finish');
end