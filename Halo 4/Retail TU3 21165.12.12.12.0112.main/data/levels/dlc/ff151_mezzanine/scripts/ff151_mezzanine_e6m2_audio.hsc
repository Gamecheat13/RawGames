//=============================================================================================================================
//============================================ E6M2 MEZZANINE NARRATIVE SCRIPT ================================================
//=============================================================================================================================

//	Music Start/Music for the into Puppeteer cinematic
script static void aud_e6m2_music_start()
	print ("all music start");
	music_start('Play_mus_pve_e06_m2_start');
end


//	Music for Player Spawn
script static void aud_e6m2_player_start()
	print ("Player Spawn music start");
	music_set_state('Play_mus_pve_e06_m2_playerspawn_start');
end


//	Player has cleared out all enemies from initial encounter
script static void aud_e6m2_init_enemies_dead()
	print ("initial enemies dead music start");
	music_set_state('Play_mus_pve_e06_m2_enemies_dead');
end


//	Player has entered a Forerunner structure with enemies already inside
script static void aud_e6m2_structure_enter()
	print ("Occupied structure is opened music start");
	music_set_state('Play_mus_pve_e06_m2_structure_open');
end


//	Player has cleared structure of all enemies
script static void aud_e6m2_structure_cleared()
	print ("Structure is cleared out music start");
	music_set_state('Play_mus_pve_e06_m2_structure_cleared');
end


//	Player access covenant computer inside structure that installs a virus into covenant database
script static void aud_e6m2_cpu01_hit()
	print ("Cov CPU 01 Accessed music start");
	music_set_state('Play_mus_pve_e06_m2_covcpu01_reached');
end


//	Reinforcements arrive!
script static void aud_e6m2_reinforcements01()
	print ("1st reinforcements music start");
	music_set_state('Play_mus_pve_e06_m2_reinforcements01');
end


//	Player accesses Covenant Computer 02
script static void aud_e6m2_cpu02_hit()
	print ("Cov CPU 02 Accessed music start");
	music_set_state('Play_mus_pve_e06_m2_covcpu02_reached');
end


//	More reinforcements arrive
script static void aud_e6m2_reinforcements02()
	print ("2nd reinforcements music start");
	music_set_state('Play_mus_pve_e06_m2_reinforcements02');
end


//	Player accesses Covenant Computer 3, which fails and alerts nearby covenant that Crimson is attacking (Panic moment)
script static void aud_e6m2_cpu03_hit()
	print ("Cov CPU 03 Accessed music start");
	music_set_state('Play_mus_pve_e06_m2_covcpu03_reached_alert');
end


//	Even more reinforcements arrive!
script static void aud_e6m2_reinforcements03()
	print ("3rd reinforcements music start");
	music_set_state('Play_mus_pve_e06_m2_reinforcements03');
end


//	Roland figures out how to stop the alert from broadcasting
script static void aud_e6m2_takedown_comms()
	print ("Comms Revealed music start");
	music_set_state('Play_mus_pve_e06_m2_comms_revealed');
end


//	A Drop pod arrives
script static void aud_e6m2_droppod()
	print ("droppod music start");
	music_set_state('Play_mus_pve_e06_m2_droppod_start');
end


//	Phantom carrying 4 Hunters arrives
script static void aud_e6m2_phantomhunters()
	print ("phantom music start");
	music_set_state('Play_mus_pve_e06_m2_phantom_4hunters');
end


//	Enemies killed and objective achieved
script static void aud_e6m2_allclear()
	print ("enemies defeated music start");
	music_set_state('Play_mus_pve_e06_m2_allclear_start');
end


//	Friendly Phantom Arrives to pick up Crimson
script static void aud_e6m2_rideishere()
	print ("evac music start");
	music_set_state('Play_mus_pve_e06_m2_evac_start');
end


//	End/Stop Music
script static void aud_e6m2_stop_music()
	print ("all music stop");
	music_stop('Play_mus_pve_e06_m2_finish');
end


