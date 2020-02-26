// =============================================================================================================================
/*
                                                                                                       
                                                                                                       
__________     ,6P         ___       ___                      _    ____     __________  ____   ____    
`MMMMMMMMM   6MM'          `MMb     dMM'                     dM.   `MM'     `M`MMMMMMMb.`MM'  6MMMMb   
 MM      \  6M'             MMM.   ,PMM                     ,MMb    MM       M MM    `Mb MM  8P    Y8  
 MM        6M ____          M`Mb   d'MM                     d'YM.   MM       M MM     MM MM 6M      Mb 
 MM    ,   MMMMMMMb         M YM. ,P MM      ,M            ,P `Mb   MM       M MM     MM MM MM      MM 
 MMMMMMM   MM'   `Mb        M `Mb d' MM     ,dM            d'  YM.  MM       M MM     MM MM MM      MM 
 MM    `   MM     MM        M  YM.P  MM    ,dMM           ,P   `Mb  MM       M MM     MM MM MM      MM 
 MM        MM     MM        M  `Mb'  MM   ,d MM           d'    YM. MM       M MM     MM MM MM      MM 
 MM        MM     MM        M   YP   MM  ,d  MM          ,MMMMMMMMb YM       M MM     MM MM YM      M9 
 MM      / YM.   ,M9        M   `'   MM ,d   MM          d'      YM. 8b     d8 MM    .M9 MM  8b    d8  
_MMMMMMMMM  YMMMMM9        _M_      _MM_MMMMMMMM       _dM_     _dMM_ YMMMMM9 _MMMMMMM9'_MM_  YMMMM9   
                                             MM                                                        
                                             MM                                                        
                                             MM                             

*/
// =============================================================================================================================


//==== stinger audio


// stinger for when the player blows up the first plasma well
script static void f_e6m4_stinger_plasma_1
	print ("f_e6m4_stinger_plasma_1: stinger for when the player blows up the first plasma well");
	music_set_state('Play_mus_pve_e6m4_stinger_plasma_1');
end

// stinger for when the player blows up the second plasma well
script static void f_e6m4_stinger_plasma_2
	print ("f_e6m4_stinger_plasma_2: stinger for when the player blows up the second plasma well");
	music_set_state('Play_mus_pve_e6m4_stinger_plasma_2');
end

// stinger for when the player blows up the third plasma well
script static void f_e6m4_stinger_plasma_3
	print ("f_e6m4_stinger_plasma_3: stinger for when the player blows up the third plasma well");
	music_set_state('Play_mus_pve_e6m4_stinger_plasma_3');
end

// stinger for when the central structure is finally open and the big final battle kicks off
script static void f_e6m4_stinger_central_structure_open
	print ("f_e6m4_stinger_central_structure_open: stinger for when the central structure is finally open and the big final battle kicks off");
	music_set_state('Play_mus_pve_e6m4_stinger_central_structure_open');
end

// stinger for when the nukes are discover
script static void f_e6m4_stinger_nukes_discovered
	print ("f_e6m4_stinger_nukes_discovered: stinger for when the nukes are discover");
	music_set_state('Play_mus_pve_e6m4_stinger_nukes_discovered');
end

//==ALL MUSIC START 
// this begins after the intro and after the player spawns
script static void f_e6m4_music_start
	print ("all music start");
	music_start('Play_mus_pve_e6m4_start');
end

//====== MUSIC START/STOPS
//== Geronimo
// music for initial combat sequence: players jump from phantom and start blastin'
script static void f_e6m4_music_geronimo_start
	print ("f_e6m4_music_geronimo_start: music for initial combat sequence: players jump from phantom and start blastin'");
	music_set_state('Play_mus_pve_e6m4_geronimo_start');
end

// stops once first plasma well is destroyed
script static void f_e6m4_music_geronimo_stop
	print ("f_e6m4_music_geronimo_stop: stops once first plasma well is destroyed");
	music_set_state('Play_mus_pve_e6m4_player_spawn_stop');
end

//== Camp Combat
// music for camp- go to camp location and clear it out
script static void f_e6m4_music_camp_combat_start
	print ("f_e6m4_music_camp_combat_start: music for camp- go to camp location and clear it out");
	music_set_state('Play_mus_pve_e6m4_camp_combat_start');
end

// stops when all enemies cleared out of camp area
script static void f_e6m4_music_camp_combat_stop
	print ("f_e6m4_music_camp_combat_stop: stops when all enemies cleared out of camp area");
	music_set_state('Play_mus_pve_e6m4_camp_combat_stop');
end

//== Camp Scan
// music for camp scan sequence- brief - player stands near some gear, suit charges up and scans surrounding equipment
script static void f_e6m4_music_camp_scan_start
	print ("f_e6m4_music_camp_scan_start: music for camp scan sequence- brief - player stands near some gear, suit charges up and scans surrounding equipment");
	music_set_state('Play_mus_pve_e6m4_camp_scan_start');
end

// stops when scan is complete
script static void f_e6m4_music_camp_scan_stop
	print ("f_e6m4_music_camp_scan_stop: stops when scan is complete");
	music_set_state('Play_mus_pve_e6m4_camp_scan_stop');
end

//== Second Plasma Well- Second Major Combat
// music for second 'destroy the plasma well' objective
script static void f_e6m4_music_second_plasma_well_start
	print ("f_e6m4_music_second_plasma_well_start:  music for second 'destroy the plasma well' objective");
	music_set_state('Play_mus_pve_e6m4_second_plasma_well_start');
end

// stops when second plasma well destroyed
script static void f_e6m4_music_second_plasma_well_stop
	print ("f_e6m4_music_second_plasma_well_stop: stops when second plasma well destroyed");
	music_set_state('Play_mus_pve_e6m4_second_plasma_well_stop');
end

//== Third Plasma Well- Third major combat segment
// music for third plasma well battle
script static void f_e6m4_music_third_plasma_well_start
	print ("f_e6m4_music_third_plasma_well_start: music for third plasma well battle");
	music_set_state('Play_mus_pve_e6m4_third_plasma_well_start');
end

// stops when third plasma well destroyed
script static void f_e6m4_music_third_plasma_well_stop
	print ("f_e6m4_music_third_plasma_well_stop: stops when third plasma well destroyed");
	music_set_state('Play_mus_pve_e6m4_third_plasma_well_stop');
end

//== CONTINGENT OBJECTIVE: Destroy Wraiths
// music for 'destroy wraiths' sub-objective
script static void f_e6m4_music_destroy_wraiths_start
	print ("f_e6m4_music_destroy_wraiths_start:  music for 'destroy wraiths' sub-objective");
	music_set_state('Play_mus_pve_e6m4_destroy_wraiths_start');
end

// stops when wraiths are destroyed
script static void f_e6m4_music_destroy_wraiths_stop
	print ("f_e6m4_music_destroy_wraiths_stop: stops when wraiths are destroyed");
	music_set_state('Play_mus_pve_e6m4_destroy_wraiths_stop');
end

//== Snipers Battle
// music for the Snipers/garage structure battle 
script static void f_e6m4_music_snipers_battle_start
	print ("f_e6m4_music_snipers_battle_start: music for the Snipers/garage structure battle ");
	music_set_state('Play_mus_pve_e6m4_snipers_battle_start');
end

// stops after the garage structure has opened and the snipers and all reinforcements are dead
script static void f_e6m4_music_snipers_battle_stop
	print ("f_e6m4_music_snipers_battle_stop: stops after the garage structure has opened and the snipers and all reinforcements are dead");
	music_set_state('Play_mus_pve_e6m4_snipers_battle_stop');
end

//== Central Structure Battle
// music for the big central battle
script static void f_e6m4_music_central_battle_start
	print ("f_e6m4_music_central_battle_start: music for the big central battle");
	music_set_state('Play_mus_pve_e6m4_central_battle_start');
end

// stops after all enemies are dead
script static void f_e6m4_music_central_battle_stop
	print ("f_e6m4_music_central_battle_stop: stops after all enemies are dead");
	music_set_state('Play_mus_pve_e6m4_central_battle_stop');
end

//==== ALL DONE
// player is headed up to the (allied) phantom
script static void f_e6m4_music_stop
	print ("all music stop");
	music_stop('Play_mus_pve_e6m4_finish');
end



/*

//==
// music for 
script static void f_e6m4_music__start
	print (": ");
	music_set_state('Play_mus_pve_e6m4__start');
end

// stops when
script static void f_e6m4_music__stop
	print (": ");
	music_set_state('Play_mus_pve_e6m4__stop');
end

*/