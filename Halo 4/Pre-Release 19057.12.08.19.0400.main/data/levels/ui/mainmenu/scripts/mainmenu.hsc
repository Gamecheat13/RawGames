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

global boolean at_title_menu = TRUE;
global boolean at_infinity_menu = FALSE;


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
	//camera_set (camera_point, ticks);
	//sleep_location (location, ticks);
	dprint ("old camera set");
	
end
// ---------- public scripts

script startup mainmenu ()
	print("mainmenu startup script");

	fade_out (0, 0, 0, 0);
	sleep(8);

	inspect (g_current_show);

	camera_control(TRUE);
	camera_attach (camera, marker1, TRUE);

	appearance_characters();

	inspect (g_current_show);
	
	// when we enter the UI scenario, the game will start faded to black, so we need to fade in
	fade_in(0, 0, 0, 45);

	thread (main_menu_logic()); 

	at_title_menu = 1;

end

global long g_current_show = 0;
global long g_spartan_show = 0;
global long g_wreckage_show = 0;

script static void play_menu_show( string_id name )
	pup_stop_show( g_current_show );
	camera_control(false);
	camera_control(true);
	g_current_show = pup_play_show (name);
end

script static void main_menu_logic()
	dprint ("player is at main menu");
	
	if g_current_show == 0 then
	
		pup_play_show ("pup_wreckage");
		play_menu_show ("pup_main_loop");
		g_location = k_titlemenu;
		inspect (g_current_show);

	end
	//play_menu_show ("next show");

end	

// ========================================================================================
// HS SCRIPT CALLS FROM CUI
// ========================================================================================

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
	//this is called when the player returns to the MAIN MENU
	print ("mainmenu camera");
	
	if g_location == k_campaign then
	
		play_menu_show ("pup_campaign_to_main");
		g_location = k_titlemenu;
		sleep_until(not pup_is_playing(g_current_show),1);
		sleep (1);
		pup_play_show ("pup_wreckage");
		play_menu_show ("pup_main_loop");
	
	elseif g_location == k_titlemenu then
	
	dprint ("already looping");
	
	else
	
		thread (menu_fade_to_white());
		pup_play_show ("pup_wreckage");
		play_menu_show ("pup_main_loop");
		g_location = k_titlemenu;
		
	
	end
	
	inspect (g_current_show);
	
end

script static void menu_fade_to_white()
		
		fade_out (1, 1, 1, 5);
		sleep (15);
		fade_in (1, 1, 1, 5);
		
end

script static void campaign_cam()
	//this fires when the selects CAMPAIGN from the MAIN MENU
	dprint("campaign camera");
		
	inspect (g_current_show);
	dprint ("starting sleep");
	sleep (1);
			
	play_menu_show ("pup_main_to_campaign");
	g_location = k_campaign;
	
	inspect (g_current_show);
	
end

script static void highlight_wargames

	dprint ("wargames highlighted");
	device_set_position_immediate (inf, 0.2);

end

script static void highlight_spartanops

	dprint ("spartan ops highlighted");
	device_set_position_immediate (inf, 0.4);

end

script static void highlight_forge

	dprint ("forge highlighted");
	device_set_position_immediate (inf, 0.6);

end

script static void highlight_theater

	dprint ("theater highlighted");
	device_set_position_immediate (inf, 0.8);

end 

script static void pvp_cam()
	
	//this is called when the player selects WAR GAMES from the INFINITY menu
	dprint("pvp_cam called");
	
	if at_infinity_menu == TRUE then
	
		play_menu_show ("pup_wargames_in");
		g_location = k_pvp;
		
	else
	
		dprint ("not into infinity yet");
		
	end
	
end

script static void forge_cam()
	
	//this is called when the player selects FORGE from the INFINITY menu
	dprint("forge_cam called");
	
	if at_infinity_menu == TRUE then
	
		play_menu_show ("pup_forge_in");
		g_location = k_forge;
		
	else	
		
		dprint ("not into infinity yet");
		
	end	
	
end

script static void theater_cam()
	
	//this is called when the player selects THEATER from the INFINITY menu
	dprint ("theater camera");

	if at_infinity_menu == TRUE then
	
		play_menu_show ("pup_theater_in");
		g_location = k_theater;
		
	else	
		
		dprint ("not into infinity yet");
		
	end	

end

script static void pve_cam()
	
	//this is called when the player selects SPARTAN OPS from the INFINITY menu
	dprint("pve_cam called");
	
	if at_infinity_menu == TRUE then
	
		play_menu_show ("pup_spops_in");
		g_location = k_pve;
		
	else	
		
		dprint ("not into infinity yet");
		
	end	

end

script static void infinity_cam()

	//this is called when the player selects INFINITY from the main menu
	
	if g_location == k_titlemenu then 
	
		dprint ("infinity cam from title menu");
		play_menu_show ("pup_main_to_infinity");
		g_spartan_show = pup_play_show ("pup_spartans");
		g_location = k_infinity;
		
	end	

	if g_location == k_pvp then
	
		dprint ("infinity cam from wargames menu");
		play_menu_show ("pup_wargames_out");
		g_spartan_show = pup_play_show ("pup_spartans");
		g_location = k_infinity;

	end

	if g_location == k_forge then
	
		dprint ("infinity cam from forge menu");
		play_menu_show ("pup_forge_out");
		g_spartan_show = pup_play_show ("pup_spartans");
		g_location = k_infinity;	
	
	end
	
	if g_location == k_theater then
	
		dprint ("infinity cam from theater menu");
		play_menu_show ("pup_theater_out");
		g_spartan_show = pup_play_show ("pup_spartans");
		g_location = k_infinity;	
	
	end
	
	if g_location == k_pve then

		dprint ("infinity cam from spops menu");
		play_menu_show ("pup_spops_out");
		g_spartan_show = pup_play_show ("pup_spartans");
		g_location = k_infinity;

	end

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


// =======================================================================================================================================================================
script static void appearance_characters()
	print ("appearance characters [static script]");

	pvs_set_object(chief);
	pvs_set_object(chief_armory);
	pvs_set_object(chief_screenshot);
	pvs_set_object(chief_exit);
	pvs_set_object(chief_pgcr);

	// Force armory chief unarmed
	unit_add_equipment(chief_armory, profile_unarmed, TRUE, FALSE);
	
	sleep(1);

	custom_animation_loop(chief_armory, objects\characters\storm_masterchief\storm_masterchief, "depot:unarmed:idle", TRUE);
	custom_animation_loop(chief, objects\characters\storm_masterchief\storm_masterchief, "depot:rifle:roster_idle", FALSE);
	custom_animation_loop(chief_screenshot, objects\characters\storm_masterchief\storm_masterchief, "depot:rifle:idle", FALSE);
	custom_animation_loop(chief_exit, objects\characters\storm_masterchief\storm_masterchief, "depot:rifle:idle", FALSE);
	custom_animation_loop(chief_pgcr, objects\characters\storm_masterchief\storm_masterchief, "depot:rifle:roster_idle", FALSE);
end

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


