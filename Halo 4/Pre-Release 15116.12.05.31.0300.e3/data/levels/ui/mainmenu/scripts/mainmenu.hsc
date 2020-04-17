/*
mainmenu.hsc
oh mainmenu script, what can you not do wrong?
"shaddap!" says mainmenu.hsc
*/

//---------- variables

/* ui location
	0 == main menu
	1 == campaign lobby
	2 == matchmaking lobby
	3 == custom games lobby
	4 == editor lobby
	5 == theater lobby
	6 == activities lobby
	7 == survival lobby ("unknown" for obfuscation purposes)
*/

global short k_titlemenu = 0;
global short k_campaign = 1;
global short k_infinity = 2;
global short k_pve = 3;
global short k_pvp = 4;
global short k_theater = 5;
global short k_forge = 6;
global short k_nowhere = 9;
global short g_location = k_titlemenu;

global short k_random_camera = 0;

global boolean at_title_menu = true;

//---------- local scripts - scripts only available for mainmenu (can only be called in here)

script static void set_location (short location)
	g_location = location;
end


script static boolean sleep_location (short location, short ticks)
 	if (location != g_location) then
 		sleep_forever();
 		 	else
 		sleep(ticks);
 	end
 	FALSE;
end

//this function takes the camera point, location of UI and sleeps at the same time
script static void set_camera_sleep (short location, cutscene_camera_point camera_point, short ticks)
	camera_set (camera_point, ticks);
	sleep_location (location, ticks);
end
// ---------- public scripts

script startup mainmenu ()
	print("mainmenu statup script");

	camera_control(on);

	appearance_characters();

	// when we enter the UI scenario, the game will start faded to black, so we need to fade in
	fade_out(0, 0, 0, 0);
	sleep(8);

	// set the default camera
	camera_set(mm_cp_title, 1);
	
	//this compensates for the 10 tick delay in camera swapping
	fade_in(0, 0, 0, 22);
	
	at_title_menu = 1;

end


// =======================================================================================================================================================================
// camera point scripts to be called in the menu camera scripts. Allows us to change which backgrounds are used in each lobby easily.
// =======================================================================================================================================================================

// takes a UI location number (see top of file)
/*
script static void camera_path_custom (short location)
 	sleep_location(location, 0);
	camera_set(custom_path_01, 0);
	sleep_location (location, 0);
	camera_set(custom_path_02, 1800);
	sleep_location(location, 1800);
	camera_set(custom_path_01, 1800);
	sleep_location(location, 1800);
end


// takes a UI location number (see top of file)
script static void camera_goto_lobby(short location, cutscene_camera_point camera)
 	//print("CAMERAPOINTNOWHERE!!");
 	//sleep_location (location, 0);
 	//set_camera_sleep(location, CP_OLDMENU, 0);
	//set_camera_sleep(location, CP_OLDMENU, 1800);
end
*/

script static void camera_path_title (short location)
	//print("camera_path_title_running");
 	
 	sleep_location (location, 0);
	
	set_camera_sleep(location, title_01, 0);
	set_camera_sleep(location, title_02, 1800);
end

// takes a UI location number (see top of file)
script static void camera_path_oldmenu(short location)
 	print("CAMERAPOINTNOWHERE!!");
 	sleep_location (location, 0);
 	set_camera_sleep(location, CP_OLDMENU, 0);
	set_camera_sleep(location, CP_OLDMENU, 1800);
end

// takes a UI location number (see top of file)
script static void camera_path_pvp (short location)
 	print("camera_path_pvp_running");
	//sleep_location (location, 0);
	//set_camera_sleep(location, test_2dbg3_00, 0);
	//set_camera_sleep(location, cp_pvp_menu00, 180);
end


// takes a UI location number (see top of file)

script static void camera_path_forge (short location)
	print("camera_path_forge_running");
 //	sleep_location (location, 0);
	//set_camera_sleep(location, cp_forge_menu00, 20);
//	set_camera_sleep(location, test_2dbg5_00, 0);
	
end


// takes a UI location number (see top of file)
script static void camera_path_theater (short location)
 	 print("camera_path_theater_running");
////	sleep_location (location, 0);
	//set_camera_sleep(location, cp_theater_menu00, 20);
	//set_camera_sleep(location, test_2dbg6_00, 0);
end

// takes a UI location number (see top of file)
script static void camera_path_infinity (short location)
  sleep_location (location, 0);
  set_camera_sleep(location, test_2dbg_02, 0);
 	set_camera_sleep(location, test_2dbg, 200);
 	set_camera_sleep(location, test_2dbg_03, 400);
 	set_camera_sleep(location, test_2dbg_02, 200);
 	//print("camera_path_infinity_running");
 	//set_camera_sleep(location, cp_infinity_menu01, 40);
 	
 	/*
 	k_random_camera = random_range(0,5);
 	print("assigned a random camera");
 	print(string(k_random_camera));
 	if(k_random_camera == 0) then
 		set_camera_sleep(location,  	, 40);
 	elseif (k_random_camera == 1) then
		set_camera_sleep(location, cp_infinity_menu01, 40);
	elseif (k_random_camera == 2) then
		set_camera_sleep(location, cp_infinity_menu02, 40);
	elseif (k_random_camera == 3) then
		set_camera_sleep(location, cp_infinity_menu03, 40);
	elseif (k_random_camera == 4) then
		set_camera_sleep(location, cp_infinity_menu04, 40);
	end*/
end

// takes a UI location number (see top of file)
script static void camera_path_campaign (short location)
 	//print("camera_path_campaign_running");
 	
 	sleep_location (location, 0);
	set_camera_sleep(location, cp_campaign_menu00, 20);
	set_camera_sleep(location, cp_campaign_menu01, 180);
	set_camera_sleep(location, cp_campaign_menu00, 180);
	//set_camera_sleep(location, title_02, 1800);
end

// takes a UI location number (see top of file)
script static void camera_path_pve (short location)
//add camera bob!
	sleep_location (location, 0);
	//set_camera_sleep(location, cp_pve_menu00, 180);
	set_camera_sleep(location, test_2dbg4_00, 0);
	//set_camera_sleep(location, title_02, 1800);
end

/*

	(cinematic_light_object chief target_main appearance_spartan spartan_light_anchor)
	(cinematic_light_object chief_screenshot target_main appearance_spartan spartan_screenshot_light_anchor)
	(cinematic_light_object chief_armory target_main appearance_spartan spartan_armory_light_anchor)
	(cinematic_light_object chief_exit target_main appearance_spartan spartan_exit_light_anchor)
	(cinematic_light_object chief_pgcr target_main appearance_spartan spartan_pgcr_light_anchor)
	
	(cinematic_light_object elite target_main appearance_elite elite_light_anchor)
	(cinematic_light_object elite_armory target_main appearance_elite elite_armory_light_anchor)
	(cinematic_light_object elite_exit target_main appearance_elite elite_exit_light_anchor)
	(cinematic_light_object elite_pgcr target_main appearance_elite elite_pgcr_light_anchor)	
	
*/

 
// =======================================================================================================================================================================
(script static void appearance_characters
	(print "appearance characters [static script]")
	(pvs_set_object chief)
	(pvs_set_object chief_armory)
	(pvs_set_object chief_screenshot)
	(pvs_set_object chief_exit)
	(pvs_set_object chief_pgcr)
	
	(pvs_set_object elite)
	(pvs_set_object elite_armory)
	(pvs_set_object elite_exit)
	(pvs_set_object elite_pgcr)
	
	(sleep 1)

	(custom_animation_loop chief_armory objects\characters\storm_masterchief\storm_masterchief "depot:unarmed:idle" TRUE)
	(custom_animation_loop chief objects\characters\storm_masterchief\storm_masterchief "depot:rifle:roster_idle" FALSE)
	(custom_animation_loop chief_screenshot objects\characters\storm_masterchief\storm_masterchief "depot:rifle:idle" FALSE)
	(custom_animation_loop chief_exit objects\characters\storm_masterchief\storm_masterchief "depot:rifle:idle" FALSE)	
	(custom_animation_loop chief_pgcr objects\characters\storm_masterchief\storm_masterchief "depot:rifle:roster_idle" FALSE)	
	

	(object_hide (object_at_marker chief_armory primary_weapon) TRUE)
		
	(custom_animation_loop elite objects\characters\elite\elite "depot:rifle:idle" FALSE)
	(custom_animation_loop elite_armory objects\characters\elite\elite "depot:rifle:idle" FALSE)
	(custom_animation_loop elite_exit objects\characters\elite\elite "depot:rifle:idle" FALSE)
	(custom_animation_loop elite_pgcr objects\characters\elite\elite "depot:rifle:idle" FALSE)

)




// =======================================================================================================================================================================
// scripts for exit experience events
// =======================================================================================================================================================================

// spartan exit experience animations

(script static void exit_experience_flair
	(print "You didn't rank up")
		(begin_random_count 1
			(custom_animation chief_exit objects\characters\storm_masterchief\storm_masterchief "depot:rifle:end_game" TRUE)
			(custom_animation chief_exit objects\characters\storm_masterchief\storm_masterchief "depot:rifle:end_game:var1" TRUE)
			(custom_animation chief_exit objects\characters\storm_masterchief\storm_masterchief "depot:rifle:end_game:var2" TRUE)
		)
	(sleep (unit_get_custom_animation_time chief_exit))
	(unit_stop_custom_animation chief_exit)
	(custom_animation_loop chief_exit objects\characters\storm_masterchief\storm_masterchief "depot:rifle:end_idle" TRUE)

)

(script static void subrank_up
	(print "You've gone up in subrank! Spartan model")
	(custom_animation chief_exit objects\characters\storm_masterchief\storm_masterchief "depot:rifle:sub_levelup" TRUE)
	(sleep (unit_get_custom_animation_time chief_exit))
	(unit_stop_custom_animation chief_exit)
	(custom_animation_loop chief_exit objects\characters\storm_masterchief\storm_masterchief "depot:rifle:end_idle" TRUE)
)

(script static void rank_up
	(print "You've gone up in rank! Spartan model")
	(custom_animation chief_exit objects\characters\storm_masterchief\storm_masterchief "depot:rifle:levelup" TRUE)
	(sleep (unit_get_custom_animation_time chief_exit))
	(unit_stop_custom_animation chief_exit)
	(custom_animation_loop chief_exit objects\characters\storm_masterchief\storm_masterchief "depot:rifle:end_idle" TRUE)
)


// =======================================================================================================================================================================
// elite exit experience animations

(script static void elite_exit_experience_flair
	(print "You didn't rank up (Elite model)")
		(begin_random_count 1
			(custom_animation elite_exit objects\characters\elite\elite "depot:rifle:end_game" TRUE)
			(custom_animation elite_exit objects\characters\elite\elite "depot:rifle:end_game:var1" TRUE)
			(custom_animation elite_exit objects\characters\elite\elite "depot:rifle:end_game:var2" TRUE)
		)
	(sleep (unit_get_custom_animation_time elite_exit))
	(unit_stop_custom_animation elite_exit)
	(custom_animation_loop elite_exit objects\characters\elite\elite "depot:rifle:end_idle" TRUE)
)


(script static void elite_subrank_up
	(print "You've gone up in subrank! (Elite model)")
	(sleep 30)
	(custom_animation elite_exit objects\characters\elite\elite "depot:rifle:sub_levelup" TRUE)
	(sleep (unit_get_custom_animation_time elite_exit))
	(unit_stop_custom_animation elite_exit)
	(custom_animation_loop elite_exit objects\characters\elite\elite "depot:rifle:end_idle" TRUE)
)

(script static void elite_rank_up
	(print "You've gone up in rank! Elite model")
	(custom_animation elite_exit objects\characters\elite\elite "depot:rifle:levelup" TRUE)
	(sleep (unit_get_custom_animation_time elite_exit))
	(unit_stop_custom_animation elite_exit)
	(custom_animation_loop elite_exit objects\characters\elite\elite "depot:rifle:end_idle" TRUE)	
)


// =======================================================================================================================================================================
// SUPPLY DEPOT ANIMATIONS
// =======================================================================================================================================================================


(script static void default_idle_pose
	(print "default idle animations")
	(custom_animation_loop chief objects\characters\storm_masterchief\storm_masterchief "depot:rifle:roster_idle" FALSE)
)

//script for exit experience initialization
(script static void exit_experience_initialization
	(print "exit experience idle animations")
	(custom_animation_loop chief_exit objects\characters\storm_masterchief\storm_masterchief "depot:rifle:idle" FALSE)
)

// script for supply depot initialization
//	(sleep (unit_get_custom_animation_time chief_armory))
(script static void supply_depot_initialization
	(print "unarmed idles")
	(custom_animation_loop chief_armory objects\characters\storm_masterchief\storm_masterchief "depot:unarmed:idle" TRUE)
)



// ================================================
// scripts for supply depot specific item purchases

// HELMET SCRIPTS

(script static void anim_depot_unarmed_helmet
	(custom_animation chief_armory objects\characters\storm_masterchief\storm_masterchief "depot:unarmed:helmet" TRUE)
	(sleep (unit_get_custom_animation_time chief_armory))
	(unit_stop_custom_animation chief_armory)
)
(script static void anim_depot_unarmed_helmet_var1
	(custom_animation chief_armory objects\characters\storm_masterchief\storm_masterchief "depot:unarmed:helmet:var1" TRUE)
	(sleep (unit_get_custom_animation_time chief_armory))
	(unit_stop_custom_animation chief_armory)
)
(script static void anim_depot_unarmed_helmet_var2
	(custom_animation chief_armory objects\characters\storm_masterchief\storm_masterchief "depot:unarmed:helmet:var2" TRUE)
	(sleep (unit_get_custom_animation_time chief_armory))
	(unit_stop_custom_animation chief_armory)
)



// LEFT SHOULDER SCRIPTS

(script static void anim_depot_unarmed_left_shoulder
	(custom_animation chief_armory objects\characters\storm_masterchief\storm_masterchief "depot:unarmed:left_shoulder" TRUE)
	(sleep (unit_get_custom_animation_time chief_armory))
	(unit_stop_custom_animation chief_armory)
)

(script static void anim_depot_unarmed_left_shoulder_var1
	(custom_animation chief_armory objects\characters\storm_masterchief\storm_masterchief "depot:unarmed:left_shoulder:var1" TRUE)
	(sleep (unit_get_custom_animation_time chief_armory))
	(unit_stop_custom_animation chief_armory)
)

// RIGHT SHOULDER SCRIPTS

(script static void anim_depot_unarmed_right_shoulder
	(custom_animation chief_armory objects\characters\storm_masterchief\storm_masterchief "depot:unarmed:right_shoulder" TRUE)
	(sleep (unit_get_custom_animation_time chief_armory))
	(unit_stop_custom_animation chief_armory)
)
(script static void anim_depot_unarmed_right_shoulder_var1
	(custom_animation chief_armory objects\characters\storm_masterchief\storm_masterchief "depot:unarmed:right_shoulder" TRUE)
	(sleep (unit_get_custom_animation_time chief_armory))
	(unit_stop_custom_animation chief_armory)
)

// CHEST SCRIPTS

(script static void anim_depot_unarmed_chest
	(custom_animation chief_armory objects\characters\storm_masterchief\storm_masterchief "depot:unarmed:chest" TRUE)
	(sleep (unit_get_custom_animation_time chief_armory))
	(unit_stop_custom_animation chief_armory)
)
(script static void anim_depot_unarmed_chest_var1
	(custom_animation chief_armory objects\characters\storm_masterchief\storm_masterchief "depot:unarmed:chest:var1" TRUE)
	(sleep (unit_get_custom_animation_time chief_armory))
	(unit_stop_custom_animation chief_armory)
)
(script static void anim_depot_unarmed_chest_var2
	(custom_animation chief_armory objects\characters\storm_masterchief\storm_masterchief "depot:unarmed:chest:var2" TRUE)
	(sleep (unit_get_custom_animation_time chief_armory))
	(unit_stop_custom_animation chief_armory)
)

// WRIST SCRIPTS

(script static void anim_depot_unarmed_wrist
	(custom_animation chief_armory objects\characters\storm_masterchief\storm_masterchief "depot:unarmed:wrist" TRUE)
	(sleep (unit_get_custom_animation_time chief_armory))
	(unit_stop_custom_animation chief_armory)
)
(script static void anim_depot_unarmed_wrist_var1
	(custom_animation chief_armory objects\characters\storm_masterchief\storm_masterchief "depot:unarmed:wrist:var1" TRUE)
	(sleep (unit_get_custom_animation_time chief_armory))
	(unit_stop_custom_animation chief_armory)
)

// UTILITY SCRIPTS

(script static void anim_depot_unarmed_utility
	(custom_animation chief_armory objects\characters\storm_masterchief\storm_masterchief "depot:unarmed:thigh" TRUE)
	(sleep (unit_get_custom_animation_time chief_armory))
	(unit_stop_custom_animation chief_armory)
)

// VISOR SCRIPTS

(script static void anim_depot_unarmed_visor
	(custom_animation chief_armory objects\characters\storm_masterchief\storm_masterchief "depot:unarmed:visor_equip" TRUE)
	(sleep (unit_get_custom_animation_time chief_armory))
	(unit_stop_custom_animation chief_armory)
)

// KNEE SCRIPTS

(script static void anim_depot_unarmed_knee
	(custom_animation chief_armory objects\characters\storm_masterchief\storm_masterchief "depot:unarmed:knee" TRUE)
	(sleep (unit_get_custom_animation_time chief_armory))
	(unit_stop_custom_animation chief_armory)
)

//===================================================================================================
//===================================================================================================
//****************************************************************************************
// new animation functions

// NEW CHEST SCRIPTS

(script static void depot_unarmed_chest
	(custom_animation chief_armory objects\characters\storm_masterchief\storm_masterchief "depot:unarmed:chest" TRUE)
	(sleep (unit_get_custom_animation_time chief_armory))
	(unit_stop_custom_animation chief_armory)
)

(script static void depot_unarmed_chest_var1
	(custom_animation chief_armory objects\characters\storm_masterchief\storm_masterchief "depot:unarmed:chest:var1" TRUE)
	(sleep (unit_get_custom_animation_time chief_armory))
	(unit_stop_custom_animation chief_armory)
)

(script static void depot_unarmed_chest_var2
	(custom_animation chief_armory objects\characters\storm_masterchief\storm_masterchief "depot:unarmed:chest:var2" TRUE)
	(sleep (unit_get_custom_animation_time chief_armory))
	(unit_stop_custom_animation chief_armory)
)

// NEW HELMET SCRIPTS

(script static void depot_unarmed_helmet
	(custom_animation chief_armory objects\characters\storm_masterchief\storm_masterchief "depot:unarmed:helmet" TRUE)
	(sleep (unit_get_custom_animation_time chief_armory))
	(unit_stop_custom_animation chief_armory)
)

(script static void depot_unarmed_helmet_var1
	(custom_animation chief_armory objects\characters\storm_masterchief\storm_masterchief "depot:unarmed:helmet:var1" TRUE)
	(sleep (unit_get_custom_animation_time chief_armory))
	(unit_stop_custom_animation chief_armory)
)

(script static void depot_unarmed_helmet_var2
	(custom_animation chief_armory objects\characters\storm_masterchief\storm_masterchief "depot:unarmed:helmet:var2" TRUE)
	(sleep (unit_get_custom_animation_time chief_armory))
	(unit_stop_custom_animation chief_armory)
)

// NEW LEFT SHOULDER SCRIPTS

(script static void depot_unarmed_left_shoulder
	(custom_animation chief_armory objects\characters\storm_masterchief\storm_masterchief "depot:unarmed:left_shoulder" TRUE)
	(sleep (unit_get_custom_animation_time chief_armory))
	(unit_stop_custom_animation chief_armory)
)

(script static void depot_unarmed_left_shoulder_var1
	(custom_animation chief_armory objects\characters\storm_masterchief\storm_masterchief "depot:unarmed:left_shoulder:var1" TRUE)
	(sleep (unit_get_custom_animation_time chief_armory))
	(unit_stop_custom_animation chief_armory)
)



// NEW RIGHT SHOULDER SCRIPTS

(script static void depot_unarmed_right_shoulder
	(custom_animation chief_armory objects\characters\storm_masterchief\storm_masterchief "depot:unarmed:right_shoulder" TRUE)
	(sleep (unit_get_custom_animation_time chief_armory))
	(unit_stop_custom_animation chief_armory)
)

(script static void depot_unarmed_right_shoulder_var1
	(custom_animation chief_armory objects\characters\storm_masterchief\storm_masterchief "depot:unarmed:right_shoulder:var1" TRUE)
	(sleep (unit_get_custom_animation_time chief_armory))
	(unit_stop_custom_animation chief_armory)
)



// NEW WRIST SCRIPTS

(script static void depot_unarmed_wrist
	(custom_animation chief_armory objects\characters\storm_masterchief\storm_masterchief "depot:unarmed:wrist" TRUE)
	(sleep (unit_get_custom_animation_time chief_armory))
	(unit_stop_custom_animation chief_armory)
)

(script static void depot_unarmed_wrist_var1
	(custom_animation chief_armory objects\characters\storm_masterchief\storm_masterchief "depot:unarmed:wrist:var1" TRUE)
	(sleep (unit_get_custom_animation_time chief_armory))
	(unit_stop_custom_animation chief_armory)
)

// NEW THIGH SCRIPTS

(script static void depot_unarmed_thigh
	(custom_animation chief_armory objects\characters\storm_masterchief\storm_masterchief "depot:unarmed:thigh" TRUE)
	(sleep (unit_get_custom_animation_time chief_armory))
	(unit_stop_custom_animation chief_armory)
)

// NEW KNEE SCRIPTS

(script static void depot_unarmed_knee
	(custom_animation chief_armory objects\characters\storm_masterchief\storm_masterchief "depot:unarmed:knee" TRUE)
	(sleep (unit_get_custom_animation_time chief_armory))
	(unit_stop_custom_animation chief_armory)
)

// NEW UTILITY SCRIPTS

(script static void depot_unarmed_utility
	(custom_animation chief_armory objects\characters\storm_masterchief\storm_masterchief "depot:unarmed:utility" TRUE)
	(sleep (unit_get_custom_animation_time chief_armory))
	(unit_stop_custom_animation chief_armory)
)

// NEW VISOR SCRIPTS

(script static void depot_unarmed_visor_equip
	(custom_animation chief_armory objects\characters\storm_masterchief\storm_masterchief "depot:unarmed:visor_equip" TRUE)
	(sleep (unit_get_custom_animation_time chief_armory))
	(unit_stop_custom_animation chief_armory)
)

(script static void depot_unarmed_visor_equip_var1
	(custom_animation chief_armory objects\characters\storm_masterchief\storm_masterchief "depot:unarmed:visor_equip:var1" TRUE)
	(sleep (unit_get_custom_animation_time chief_armory))
	(unit_stop_custom_animation chief_armory)
)

// NEW IDLE SCRIPTS

(script static void depot_unarmed_idle
	(custom_animation chief_armory objects\characters\storm_masterchief\storm_masterchief "depot:unarmed:idle" TRUE)
	(sleep (unit_get_custom_animation_time chief_armory))
	(unit_stop_custom_animation chief_armory)
)

(script static void depot_unarmed_idle_var1
	(custom_animation chief_armory objects\characters\storm_masterchief\storm_masterchief "depot:unarmed:idle:var1" TRUE)
	(sleep (unit_get_custom_animation_time chief_armory))
	(unit_stop_custom_animation chief_armory)
)

(script static void depot_unarmed_idle_var2
	(custom_animation chief_armory objects\characters\storm_masterchief\storm_masterchief "depot:unarmed:idle:var2" TRUE)
	(sleep (unit_get_custom_animation_time chief_armory))
	(unit_stop_custom_animation chief_armory)
)

(script static void depot_unarmed_idle_var3
	(custom_animation chief_armory objects\characters\storm_masterchief\storm_masterchief "depot:unarmed:idle:var3" TRUE)
	(sleep (unit_get_custom_animation_time chief_armory))
	(unit_stop_custom_animation chief_armory)
)

// NEW PLAYER SELECTABLE SPARTAN POSES

(script static void depot_spartan_idle_02
	(custom_animation chief_armory objects\characters\storm_masterchief\storm_masterchief "depot:spartan_idle_02" TRUE)
	(sleep (unit_get_custom_animation_time chief_armory))
	(unit_stop_custom_animation chief_armory)
)

(script static void depot_spartan_idle_03
	(custom_animation chief_armory objects\characters\storm_masterchief\storm_masterchief "depot:spartan_idle_03" TRUE)
	(sleep (unit_get_custom_animation_time chief_armory))
	(unit_stop_custom_animation chief_armory)
)

(script static void depot_spartan_idle_04
	(custom_animation chief_armory objects\characters\storm_masterchief\storm_masterchief "depot:spartan_idle_04" TRUE)
	(sleep (unit_get_custom_animation_time chief_armory))
	(unit_stop_custom_animation chief_armory)
)

(script static void depot_spartan_idle_05
	(custom_animation chief_armory objects\characters\storm_masterchief\storm_masterchief "depot:spartan_idle_05" TRUE)
	(sleep (unit_get_custom_animation_time chief_armory))
	(unit_stop_custom_animation chief_armory)
)

(script static void depot_spartan_idle_06
	(custom_animation chief_armory objects\characters\storm_masterchief\storm_masterchief "depot:spartan_idle_06" TRUE)
	(sleep (unit_get_custom_animation_time chief_armory))
	(unit_stop_custom_animation chief_armory)
)

(script static void depot_spartan_idle_07
	(custom_animation chief_armory objects\characters\storm_masterchief\storm_masterchief "depot:spartan_idle_07" TRUE)
	(sleep (unit_get_custom_animation_time chief_armory))
	(unit_stop_custom_animation chief_armory)
)

(script static void depot_spartan_idle_08
	(custom_animation chief_armory objects\characters\storm_masterchief\storm_masterchief "depot:spartan_idle_08" TRUE)
	(sleep (unit_get_custom_animation_time chief_armory))
	(unit_stop_custom_animation chief_armory)
)

// NEW END GAME SPARTAN SCRIPTS


(script static void depot_rifle_end_game
	(custom_animation chief_armory objects\characters\storm_masterchief\storm_masterchief "depot:rifle:end_game" TRUE)
	(sleep (unit_get_custom_animation_time chief_armory))
	(unit_stop_custom_animation chief_armory)
)

(script static void depot_rifle_end_game_var1
	(custom_animation chief_armory objects\characters\storm_masterchief\storm_masterchief "depot:rifle:end_game:var1" TRUE)
	(sleep (unit_get_custom_animation_time chief_armory))
	(unit_stop_custom_animation chief_armory)
)
(script static void depot_rifle_end_game_var2
	(custom_animation chief_armory objects\characters\storm_masterchief\storm_masterchief "depot:rifle:end_game:var2" TRUE)
	(sleep (unit_get_custom_animation_time chief_armory))
	(unit_stop_custom_animation chief_armory)
)

(script static void depot_rifle_levelup
	(custom_animation chief_armory objects\characters\storm_masterchief\storm_masterchief "depot:rifle:levelup" TRUE)
	(sleep (unit_get_custom_animation_time chief_armory))
	(unit_stop_custom_animation chief_armory)
)

(script static void depot_rifle_sub_levelup
	(custom_animation chief_armory objects\characters\storm_masterchief\storm_masterchief "depot:rifle:sub_levelup" TRUE)
	(sleep (unit_get_custom_animation_time chief_armory))
	(unit_stop_custom_animation chief_armory)
)

// SPARTAN IDLE SCRIPTS


(script static void depot_rifle_roster_idle
	(custom_animation chief_armory objects\characters\storm_masterchief\storm_masterchief "depot:rifle:roster_idle" TRUE)
	(sleep (unit_get_custom_animation_time chief_armory))
	(unit_stop_custom_animation chief_armory)
)

(script static void depot_rifle_idle
	(custom_animation chief_armory objects\characters\storm_masterchief\storm_masterchief "depot:rifle:idle" TRUE)
	(sleep (unit_get_custom_animation_time chief_armory))
	(unit_stop_custom_animation chief_armory)
)


//****************************************************************************************

// ================================================
// Purchase category scripts

(script static void helmet_purchase
	(print "You purchased/wore a helmet SUPER SUPER SUPER!")
	(begin_random_count 1
		(depot_unarmed_helmet)
		(depot_unarmed_helmet_var1)
		(depot_unarmed_helmet_var2)
	)
	(supply_depot_initialization)
)

(script static void left_shoulder_purchase
	(print "You purchased/wore a left shoulder!")
	(begin_random_count 1
		(depot_unarmed_left_shoulder)
		(depot_unarmed_left_shoulder_var1)
	)
	(supply_depot_initialization)
)

(script static void right_shoulder_purchase
	(print "You purchased/wore a right shoulder!")
	(begin_random_count 1
		(depot_unarmed_right_shoulder)
		(depot_unarmed_right_shoulder_var1)
	)
	(supply_depot_initialization)
)

(script static void chest_purchase
	(print "You purchased/wore a chest piece!")
	(begin_random_count 1
		(depot_unarmed_chest)
		(depot_unarmed_chest_var1)
		(depot_unarmed_chest_var2)
	)
	(supply_depot_initialization)
)

(script static void wrist_purchase
	(print "You purchased/wore a wrist piece!")
	(begin_random_count 1
		(depot_unarmed_wrist)
		(depot_unarmed_wrist_var1)
	)
	(supply_depot_initialization)
)

(script static void utility_purchase
	(print "You purchased/wore a leg plating!")
	(begin_random_count 1
			(depot_unarmed_knee)
			(depot_unarmed_thigh)
			(depot_unarmed_utility)
	)
	(supply_depot_initialization)
)

(script static void visor_purchase
	(print "You purchased/wore a visor color!")
	(begin_random_count 1
		(depot_unarmed_visor_equip)
		(depot_unarmed_visor_equip_var1)
	)
	(supply_depot_initialization)
)

(script static void knee_purchase
	(print "You purchased/wore a knee piece!")
	(begin_random_count 1
		(anim_depot_unarmed_utility)
		(anim_depot_unarmed_knee)
	)
	(supply_depot_initialization)
)

// =====================================================================================================
//****************************************************************************************

//new scripts for animators to view in game UI

(script static void new_depot_unarmed_chest
	(print "chest purchase animation")
	(begin_random_count 1
		(depot_unarmed_chest)
	)
	(supply_depot_initialization)
)

(script static void new_depot_unarmed_chest_var1
	(print "chest purchase animation variation 1")
	(begin_random_count 1
		(depot_unarmed_chest_var1)
	)
	(supply_depot_initialization)
)
(script static void new_depot_unarmed_chest_var2
	(print "chest purchase animation variation 2")
	(begin_random_count 1
		(depot_unarmed_chest_var2)
	)
	(supply_depot_initialization)
)

(script static void new_depot_unarmed_helmet
	(print "helmet purchase animation")
	(begin_random_count 1
		(depot_unarmed_helmet)
	)
	(supply_depot_initialization)
)

(script static void new_depot_unarmed_helmet_var1
	(print "helmet purchase animation variation 1")
	(begin_random_count 1
		(depot_unarmed_helmet_var1)
	)
	(supply_depot_initialization)
)
(script static void new_depot_unarmed_helmet_var2
	(print "helmet purchase animation variation 2")
	(begin_random_count 1
		(depot_unarmed_helmet_var2)
	)
	(supply_depot_initialization)
)

(script static void new_depot_unarmed_left_shoulder
	(print "left_shoulder purchase animation")
	(begin_random_count 1
		(depot_unarmed_left_shoulder)
	)
	(supply_depot_initialization)
)

(script static void new_depot_unarmed_left_shoulder_var1
	(print "left_shoulder purchase animation variation 1")
	(begin_random_count 1
		(depot_unarmed_left_shoulder_var1)
	)
	(supply_depot_initialization)
)

(script static void new_depot_unarmed_right_shoulder
	(print "right_shoulder purchase animation")
	(begin_random_count 1
		(depot_unarmed_right_shoulder)
	)
	(supply_depot_initialization)
)

(script static void new_depot_unarmed_right_shoulder_var1
	(print "right_shoulder purchase animation variation 1")
	(begin_random_count 1
		(depot_unarmed_right_shoulder_var1)
	)
	(supply_depot_initialization)
)


(script static void new_depot_unarmed_wrist
	(print "wrist purchase animation")
	(begin_random_count 1
		(depot_unarmed_wrist)
	)
	(supply_depot_initialization)
)

(script static void new_depot_unarmed_wrist_var1
	(print "wrist purchase animation variation 1")
	(begin_random_count 1
		(depot_unarmed_wrist_var1)
	)
	(supply_depot_initialization)
)

(script static void new_depot_unarmed_thigh
	(print "thigh purchase animation")
	(begin_random_count 1
		(depot_unarmed_thigh)
	)
	(supply_depot_initialization)
)

(script static void new_depot_unarmed_knee
	(print "knee purchase animation")
	(begin_random_count 1
		(depot_unarmed_knee)
	)
	(supply_depot_initialization)
)

(script static void new_depot_unarmed_utility
	(print "utility purchase animation")
	(begin_random_count 1
		(depot_unarmed_utility)
	)
	(supply_depot_initialization)
)

(script static void new_depot_unarmed_visor_equip
	(print "visor purchase animation")
	(begin_random_count 1
		(depot_unarmed_visor_equip)
	)
	(supply_depot_initialization)
)

(script static void new_depot_unarmed_visor_equip_var1
	(print "visor purchase animation variation 1")
	(begin_random_count 1
		(depot_unarmed_visor_equip_var1)
	)
	(supply_depot_initialization)
)

(script static void new_depot_unarmed_idle
	(print "idle equip animation ")
	(begin_random_count 1
		(depot_unarmed_idle)
	)
	(supply_depot_initialization)
)

(script static void new_depot_unarmed_idle_var1
	(print "idle equip animation variation 1 ")
	(begin_random_count 1
		(depot_unarmed_idle_var1)
	)
	(supply_depot_initialization)
)
(script static void new_depot_unarmed_idle_var2
	(print "idle equip animation variation 2")
	(begin_random_count 1
		(depot_unarmed_idle_var2)
	)
	(supply_depot_initialization)
)
(script static void new_depot_unarmed_idle_var3
	(print "idle equip animation variation 3")
	(begin_random_count 1
		(depot_unarmed_idle_var3)
	)
	(supply_depot_initialization)
)

(script static void new_depot_spartan_idle_02
	(print "spartan portrait idle 02")
	(begin_random_count 1
		(depot_spartan_idle_02)
	)
	(supply_depot_initialization)
)

(script static void new_depot_spartan_idle_03
	(print "spartan portrait idle 03")
	(begin_random_count 1
		(depot_spartan_idle_03)
	)
	(supply_depot_initialization)
)

(script static void new_depot_spartan_idle_04
	(print "spartan portrait idle 04")
	(begin_random_count 1
		(depot_spartan_idle_04)
	)
	(supply_depot_initialization)
)

(script static void new_depot_spartan_idle_05
	(print "spartan portrait idle 05")
	(begin_random_count 1
		(depot_spartan_idle_05)
	)
	(supply_depot_initialization)
)

(script static void new_depot_spartan_idle_06
	(print "spartan portrait idle 06")
	(begin_random_count 1
		(depot_spartan_idle_06)
	)
	(supply_depot_initialization)
)

(script static void new_depot_spartan_idle_07
	(print "spartan portrait idle 07")
	(begin_random_count 1
		(depot_spartan_idle_07)
	)
	(supply_depot_initialization)
)

(script static void new_depot_spartan_idle_08
	(print "spartan portrait idle 08")
	(begin_random_count 1
		(depot_spartan_idle_08)
	)
	(supply_depot_initialization)
)

(script static void new_rifle_end_game
	(print "Spartan rifle animation during exit experience")
	(begin_random_count 1
		(depot_rifle_end_game)
	)
	(supply_depot_initialization)
)

(script static void new_rifle_end_game_var1
	(print "Spartan rifle varient 1 animation during exit experience")
	(begin_random_count 1
		(depot_rifle_end_game_var1)
	)
	(supply_depot_initialization)
)

(script static void new_rifle_end_game_var2
	(print "Spartan rifle varient 2 animation during exit experience")
	(begin_random_count 1
		(depot_rifle_end_game_var2)
	)
	(supply_depot_initialization)
)

(script static void new_rifle_levelup
	(print "Spartan rifle level up animation during exit experience")
	(begin_random_count 1
		(depot_rifle_levelup)
	)
	(supply_depot_initialization)
)

(script static void new_rifle_sub_levelup
	(print "Spartan rifle level up sub animation during exit experience")
	(begin_random_count 1
		(depot_rifle_sub_levelup)
	)
	(supply_depot_initialization)
)

(script static void rifle_roster_idle
	(print "Spartan rifle roster idle")
	(begin_random_count 1
		(depot_rifle_roster_idle)
	)
	(supply_depot_initialization)
)

(script static void rifle_idle
	(print "Spartan rifle idle")
	(begin_random_count 1
		(depot_rifle_idle)
	)
	(supply_depot_initialization)
)

//****************************************************************************************








/*
// =======================================================================================================================================================================
// rain scripts

(script static void rain_title_start
	(print "title screen rain start")
	(weather_animate_force rain_title 1 0)
//	(sleep_until
//		(begin
//			(weather_animate_force rain_title 1 (random_range 5 15))
//			(sleep 
//				(random_range 
//					(* 30 20) 
//					(* 30 30)
//				)
//			)
//			
//			(weather_animate_force off 1 (random_range 5 15))
//			(sleep 
//				(random_range 
//					(* 30 60) 
//					(* 30 90)
//				)
//			)
//			
//			FALSE
//		)
//	)	
)

(script static void rain_act2_start
	(print "act2 rain start")
	(weather_animate_force rain_act2 1 0)
	
)

(script static void rain_theater_start
	(print "theater rain start")
	(weather_animate_force rain_theater 1 0)
//		(sleep_until
//		(begin
//			(weather_animate_force rain_theater 1 (random_range 5 15))
//			(sleep 
//				(random_range 
//					(* 30 20) 
//					(* 30 30)
//				)
//			)
//			
//			(weather_animate_force off 1 (random_range 5 15))
//			(sleep 
//				(random_range 
//					(* 30 60) 
//					(* 30 90)
//				)
//			)
//			
//			FALSE
//		)
//	)	
)

(script static void rain_stop
	(print "rain stop")
	(weather_animate_force off 1 0)
)

*/


/// ========================================================================================
// 3D SPACES BACKGROUND SCRIPTS
// =======================================================================================================================================================================

script static void pvp_camera_bob()
	print("threading test");
end

// ========================================================================================
// HS SCRIPT CALLS FROM CUI
// =======================================================================================================================================================================
//THIS F IS TO SEE THE BOGUS SCREEN THAT EVERYONE ELSE SEES LOLOLOL!
script static void oldmainmenu_cam()
	print("campaign camera act 1");
	set_location(k_nowhere);
	repeat
		camera_path_oldmenu(k_nowhere);
	until(FALSE,0);
end

// this script is intended to be run by the sign in and title screen when it loads
script static void titlemenu_cam()
	print ("mainmenu camera");
	camera_set(mm_cp_title, 2000);
	at_title_menu = 1;
	render_depth_of_field_enable (false);
end


// this script is intended to be run by the campaign lobby ui screen when it loads
script static void campaign_cam()
	print("campaign camera - none");
end

// this script is intended to be run by the matchmaking lobby ui screen when it loads
script static void pvp_cam()
	print("pvp_cam called");
	camera_set(mm_cp_pvp, 2000);
	sleep(1);
	render_depth_of_field_enable (true);
		
	//set_location(k_pvp);
	//set_camera_sleep(k_pvp, cp_pvp_menu00, 35);
	//thread(pvp_camera_bob());
	//custom_animation(menu_spartan, 'objects/characters/spartans/spartans.model_animation_graph', 'warthog_d:enter', 1);
	//custom_animation(civilian_female, 'objects/characters/storm_civilian_female/storm_storm_civilian_female.model_animation_graph', 'combat:missile:jump_forward_long', 1);
	//print("played animation");
	//repeat
	//	camera_path_pvp(k_pvp);
	//until(FALSE,0);	
end

// this script is intended to be run by the main menu lobby ui screen when it loads
script static void forge_cam()
	print("forge_cam called");
//	set_location(k_forge);
//	repeat/
//			camera_path_forge(k_forge);
//	until(FALSE,0);		
end

// this script is intended to be run by the main menu lobby ui screen when it loads
script static void temp_theater_cam()
	print ("theater camera");
	//set_location(k_theater);
	//repeat
	//		camera_path_theater(k_theater);
	//until(FALSE,0);		
end

// this script is intended to be run by the main menu lobby ui screen when it loads
script static void infinity_cam()

	
	print("infinity_cam called");

 	if (at_title_menu) then
 		camera_set(mm_cp_infinity, 2000);
 	else
		camera_set(mm_cp_infinity, 2000);
		sleep(1);
 	end

	at_title_menu = 0;
	
	render_depth_of_field_enable (true);
		
	//set_location(k_infinity);
	//repeat
	//		camera_path_infinity(k_infinity);
	//until(FALSE,0);		
end

// this script is intended to be run by the main menu lobby ui screen when it loads
script static void pve_cam()
	print("pve_cam called");
	camera_set(mm_cp_pvp, 2000);
	sleep(10);
	render_depth_of_field_enable (true);
		
	//set_location(k_pve);
///	set_camera_sleep(k_pve, cp_pve_menu00, 600);
	//repeat
//			camera_path_pve(k_pve);
//	until(FALSE,0);		
end
