#include common_scripts\utility;
#include maps\_utility;
#include maps\_anim;

main()
{
	anim_playerview();
	anim_human();
	anim_vehicles();
	sas_leader();
	radio();
}

#using_animtree( "player" );
anim_playerview()
{
	level.scr_model[ "player_rig_tunnel_crash" ] 					= "viewhands_player_sas";
	level.scr_anim[ "player_rig_tunnel_crash" ][ "train_crash" ] 	= %london_player_bail;

	level.scr_model[ "player_mount_truck" ] 					= "viewhands_player_sas";
	level.scr_anim[ "player_mount_truck" ][ "truck_mount" ] 	= %london_utilitytruck_player_mount;
	level.scr_animtree[ "player_mount_truck" ] 					= #animtree;

    addNotetrack_startFXonTag( "player_rig_tunnel_crash", "dirt_kickup_hands_start", "train_crash", "dirt_kickup_hands", "J_wrist_RI" );
    addNotetrack_startFXonTag( "player_rig_tunnel_crash", "dirt_kickup_hands_start", "train_crash", "dirt_kickup_hands", "J_wrist_LE" );
    addNotetrack_stopFXonTag( "player_rig_tunnel_crash", "dirt_kickup_hands_stop", "train_crash", "dirt_kickup_hands", "J_wrist_RI" );
    addNotetrack_stopFXonTag( "player_rig_tunnel_crash", "dirt_kickup_hands_stop", "train_crash", "dirt_kickup_hands", "J_wrist_LE" );
    addNotetrack_startFXonTag( "player_rig_tunnel_crash", "dirt_kickup_hands_light_start", "train_crash", "dirt_kickup_hands_light", "J_wrist_RI" );
    addNotetrack_startFXonTag( "player_rig_tunnel_crash", "dirt_kickup_hands_light_start", "train_crash", "dirt_kickup_hands_light", "J_wrist_LE" );
    addNotetrack_stopFXonTag( "player_rig_tunnel_crash", "dirt_kickup_hands_light_stop", "train_crash", "dirt_kickup_hands_light", "J_wrist_RI" );
    addNotetrack_stopFXonTag( "player_rig_tunnel_crash", "dirt_kickup_hands_light_stop", "train_crash", "dirt_kickup_hands_light", "J_wrist_LE" );
    addNotetrack_startFXonTag( "player_rig_tunnel_crash", "dirt_kickup_head_start", "train_crash", "dirt_kickup_head", "TAG_CAMERA" );
    addNotetrack_stopFXonTag( "player_rig_tunnel_crash", "dirt_kickup_head_stop", "train_crash", "dirt_kickup_head", "TAG_CAMERA" );

	level.scr_animtree[ "player_rig_tunnel_crash" ] = #animtree;

	level.scr_model[ "player_rig_tunnel_crash_teleport" ] 					= "viewhands_player_sas";
	level.scr_anim[ "player_rig_tunnel_crash_teleport" ][ "train_crash" ] 	= %london_player_bail;
    addNotetrack_flag( "player_rig_tunnel_crash_teleport", "dirt_kickup_hands_light_start", "smoke_fill", "train_crash" );

	addNotetrack_customFunction( "player_rig_tunnel_crash_teleport", "dirt_kickup_head_start", maps\westminster_code::level_end, "train_crash" ); 
	addNotetrack_customFunction( "player_rig_tunnel_crash_teleport", "transition", maps\westminster_code::player_teleports, "train_crash" );
	addNotetrack_customFunction( "player_rig_tunnel_crash_teleport", "dirt_kickup_head_start", maps\westminster_code::slide, "train_crash" );
    addNotetrack_startFXonTag( "player_rig_tunnel_crash_teleport", "dirt_kickup_hands_start", "train_crash", "dirt_kickup_hands", "J_wrist_RI" );
    addNotetrack_startFXonTag( "player_rig_tunnel_crash_teleport", "dirt_kickup_hands_start", "train_crash", "dirt_kickup_hands", "J_wrist_LE" );
    addNotetrack_stopFXonTag( "player_rig_tunnel_crash_teleport", "dirt_kickup_hands_stop", "train_crash", "dirt_kickup_hands", "J_wrist_RI" );
    addNotetrack_stopFXonTag( "player_rig_tunnel_crash_teleport", "dirt_kickup_hands_stop", "train_crash", "dirt_kickup_hands", "J_wrist_LE" );
    addNotetrack_startFXonTag( "player_rig_tunnel_crash_teleport", "dirt_kickup_hands_light_start", "train_crash", "dirt_kickup_hands_light", "J_wrist_RI" );
    addNotetrack_startFXonTag( "player_rig_tunnel_crash_teleport", "dirt_kickup_hands_light_start", "train_crash", "dirt_kickup_hands_light", "J_wrist_LE" );
    addNotetrack_stopFXonTag( "player_rig_tunnel_crash_teleport", "dirt_kickup_hands_light_stop", "train_crash", "dirt_kickup_hands_light", "J_wrist_RI" );
    addNotetrack_stopFXonTag( "player_rig_tunnel_crash_teleport", "dirt_kickup_hands_light_stop", "train_crash", "dirt_kickup_hands_light", "J_wrist_LE" );
    addNotetrack_startFXonTag( "player_rig_tunnel_crash_teleport", "dirt_kickup_head_start", "train_crash" ,"dirt_kickup_head", "TAG_CAMERA" );
    addNotetrack_stopFXonTag( "player_rig_tunnel_crash_teleport", "dirt_kickup_head_stop", "train_crash", "dirt_kickup_head", "TAG_CAMERA" );
    addNotetrack_flag( "player_rig_tunnel_crash_teleport", "dirt_kickup_hands_stop", "train_crash_tumble_stops", "train_crash" );

	level.scr_animtree[ "player_rig_tunnel_crash_teleport" ] = #animtree;
}

#using_animtree( "generic_human" );
anim_human()
{
    level.scr_anim[ "london_station_civ1" ][ "idle" ][ 0 ] = %london_station_civ1_idle;
    level.scr_anim[ "london_station_civ1" ][ "reaction" ] = %london_station_civ1_reaction;
    level.scr_anim[ "london_station_civ2" ][ "idle" ][ 0 ] = %london_station_civ2_idle;
    level.scr_anim[ "london_station_civ2" ][ "reaction" ] = %london_station_civ2_reaction;
    level.scr_anim[ "london_station_civ3" ][ "reaction" ] = %london_station_civ3_reaction;
    level.scr_anim[ "london_station_civ4" ][ "idle" ][ 0 ] = %london_station_civ4_idle;
    level.scr_anim[ "london_station_civ4" ][ "reaction" ] = %london_station_civ4_reaction;
    level.scr_anim[ "london_station_civ5" ][ "idle" ][ 0 ] = %london_station_civ5_idle;
    level.scr_anim[ "london_station_civ5" ][ "reaction" ] = %london_station_civ5_reaction;
    level.scr_anim[ "london_station_civ6" ][ "idle" ][ 0 ] = %london_station_civ6_idle;
    level.scr_anim[ "london_station_civ6" ][ "reaction" ] = %london_station_civ6_reaction;
    level.scr_anim[ "london_station_civ7" ][ "idle" ][ 0 ] = %london_station_civ7_idle;
    level.scr_anim[ "london_station_civ7" ][ "reaction" ] = %london_station_civ7_reaction;
    level.scr_anim[ "london_station_civ8" ][ "reaction" ] = %london_station_civ8_reaction;
    level.scr_anim[ "london_station_civ9a" ][ "reaction" ] = %london_station_civ9a_reaction;
    level.scr_anim[ "london_station_civ9b" ][ "reaction" ] = %london_station_civ9b_reaction;
    level.scr_anim[ "london_station_civ10a" ][ "reaction" ] = %london_station_civ10a_reaction;
    level.scr_anim[ "london_station_civ10b" ][ "reaction" ] = %london_station_civ10b_reaction;
    level.scr_anim[ "london_station_civ11" ][ "idle" ][ 0 ] = %london_station_civ11_idle;
    level.scr_anim[ "london_station_civ11" ][ "reaction" ] = %london_station_civ11_reaction;

    level.scr_anim[ "generic" ][ "death_in_place" ] = %death_stand_dropinplace;

    level.scr_anim[ "generic" ][ "run_lowready_reload" ] = %run_lowready_reload;
    level.scr_anim[ "generic" ][ "run_n_gun_l_120" ] = %run_n_gun_l_120;
    level.scr_anim[ "generic" ][ "run_n_gun_l" ] = %run_n_gun_l;
    level.scr_anim[ "generic" ][ "heat_run_loop" ] = %heat_run_loop;

    level.scr_anim[ "truck_gunner" ][ "train_crash" ] = %london_truck_crash_guy;
    level.scr_anim[ "truck_gunner" ][ "idle_loop" ] = [ %exposed_crouch_idle_twitch_v2, %exposed_crouch_idle_twitch_v3 ];

    level.scr_anim[ "generic" ][ "utility_driver_mount" ] = %london_utilitytruck_driver_mount;

    level.scr_anim[ "generic" ][ "crouch2stand"] = %crouch2stand;
    level.scr_anim[ "generic" ][ "sandman_stumble"] = %london_truckcrash_crawl;
    
}

sas_leader()
{
	// Beginning TrainStation -----------------------------
	
	// "Everyone in the trucks, now!"
	level.scr_sound[ "sas_leader" ][ "london_ldr_inthetrucks" ] = "london_ldr_inthetrucks";

	// "Burns - get in the truck NOW!"
	level.scr_sound[ "sas_leader" ][ "london_ldr_burnsintruck" ] = "london_ldr_burnsintruck";
	// "Get your arse in the truck!  They're getting away!"
	level.scr_sound[ "sas_leader" ][ "london_ldr_arseintruck" ] = "london_ldr_arseintruck";

	// After Train Crash ----------------------------------
	// "*cough*...Burns…burns…you alright??"
	level.scr_sound[ "sas_leader" ][ "london_ldr_burnsalright" ] 	= "london_ldr_burnsalright";
	// "Burns…*cough*…Burns… Burns, you alright??"
	level.scr_sound[ "sas_leader" ][ "london_ldr_burnsalright" ] 	= "london_ldr_burnsalright";
	// "The train's done in under Westminster.  Those bastards were using it for transport."
	level.scr_sound[ "sas_leader" ][ "london_ldr_scrapmetal2" ] 	= "london_ldr_scrapmetal2";
	// "<sigh> Copy.  Come on, Burns.  It looks like it's just us now."
	level.scr_sound[ "sas_leader" ][ "london_ldr_nothingwecando" ] 	= "london_ldr_nothingwecando";
}

radio()
{
	// Beginning Trainstation -----------------------------
	// "Those bastards aren't skivin outta 'dis!"
	level.scr_radio[ "london_gfn_skivin" ] 			= "london_gfn_skivin";
	// "Hold on!"
	level.scr_radio[ "london_ldr_holdon" ] 			= "london_ldr_holdon";

	// Before Civilian Station ----------------------------
	// "RPG!!!!!!!!!!!!!!"
	level.scr_radio[ "train_ride_rpg" ] 		= "london_gfn_rpg";

	// "Try and get along side it!"
	level.scr_radio[ "london_ldr_alongside" ] 		= "london_ldr_alongside";

	// "Incoming train!!  Go right!  Go right!!"
	level.scr_radio[ "london_sasl_incomingtrain" ] 	= "london_sasl_incomingtrain";

	level.scr_radio[ "littleclose" ] 					= [ "london_ldr_littleclose", "london_gfn_inonepiece", "london_ldr_keepsteady" ];
	// "A little close there, mate!"
	level.scr_radio[ "london_ldr_littleclose" ]			= "london_ldr_littleclose";
	// "Sod off!  We're still in one piece!"
	level.scr_radio[ "london_gfn_inonepiece" ]			= "london_gfn_inonepiece";
	// "Just keep her steady!"
	level.scr_radio[ "london_ldr_keepsteady" ]			= "london_ldr_keepsteady";

	// Civilian Station ----------------------------
	// "Watch your fire!!  Civvies up ahead!!"
	level.scr_radio[ "london_ldr_civviesahead" ] 		= "london_ldr_civviesahead";

	// After Civilian Station ---------------------------
	level.scr_radio[ "wheretheyheaded" ] = [ "london_ldr_throughtube", "london_com_metroexits" ];
	// "Baseplate - we're tracking hostiles through the tube.  We need to know where they're headed!"
	level.scr_radio[ "london_ldr_throughtube" ] = "london_ldr_throughtube";
	// "Bravo Six, all metro exits from your location are located in the city, over."
	level.scr_radio[ "london_com_metroexits" ] = "london_com_metroexits";

	level.scr_radio[ "outside_help" ] = [ "london_ldr_whereareyou", "london_hp2_inboundandhot" ];
	// "Vulture 2, where the hell are you?!"
	level.scr_radio[ "london_ldr_whereareyou" ] = "london_ldr_whereareyou";
	// "Got your position, got the target.  Inbound and hot."
	level.scr_radio[ "london_hp2_inboundandhot" ] = "london_hp2_inboundandhot";



	// After Open Section ----------------------------
	level.scr_radio[ "stillbreathing" ] = [ "london_ldr_stillkickin", "london_sasl_cantgetashot" ];
	// "Why's that driver still breathin'?!"
	level.scr_radio[ "london_ldr_stillkickin" ] = "london_ldr_stillkickin";
	// "<grunt> -- Can't get a shot!!"
	level.scr_radio[ "london_sasl_cantgetashot" ] = "london_sasl_cantgetashot";

	// Ghost Station --------------------------------------
	// "This line goes straight to Westminster!  We have to stop this thing, NOW!!!"
	level.scr_radio[ "london_ldr_stoptrainnow2" ] = "london_ldr_stoptrainnow2";

	// Train Crash ----------------------------------------
	// "I see the driver!  Taking the sho…"
	level.scr_radio[ "london_sasl_seethedriver" ] 	= "london_sasl_seethedriver";
    //Man down! Man Dow...
    level.scr_radio[ "london_sas2_pierceisdown" ]   = "london_sas2_pierceisdown";
	// "Ohh F--KING HELLLLLL!!!!!!!!!!"
	level.scr_radio[ "london_ldr_finghell" ] 		= "london_ldr_finghell";
	// "HOLD OOOONNNNN!!!!"
	level.scr_radio[ "london_ldr_holdon2" ] 		= "london_ldr_holdon2";

	// After Train Crash ----------------------------------
//	// "Bravo Six, come in….Bravo Six, do you copy?"
//	level.scr_radio[ "london_com_doyoucopy" ] 	= "london_com_doyoucopy";
//	// "Bravo Six, what's your status?"
//	level.scr_radio[ "london_com_status" ] 		= "london_com_status";
//	// "Be advised, Bravo Six, the trucks are headed in your direction.  Get topside and RV with Bravo Two."
//	level.scr_radio[ "london_com_rendevous" ] 	= "london_com_rendevous";
}


#using_animtree( "vehicles" );
anim_vehicles()
{
	level.scr_anim[ "generic" ][ "subway_doors_root" ] = %subway_cart;
	level.scr_anim[ "generic" ][ "subway_doors_open" ] = %subway_cart_doors_open;
	level.scr_anim[ "generic" ][ "subway_doors_close" ] = %subway_cart_doors_close;
	level.scr_anim[ "generic" ][ "subway_doors_open2" ] = %subway_cart_doors_open2;
	level.scr_anim[ "generic" ][ "subway_doors_close2" ] = %subway_cart_doors_close2;

	level.scr_anim[ "train_car1" ][ "train_crash" ] = %london_train_crash_1;

	addNotetrack_flag( "train_car1" , "break" , "train_breaks_in_half", "train_crash" );
    addNotetrack_flag( "train_car1", "collumn_213", "train_column_213", "train_crash" );
    addNotetrack_flag( "train_car1", "collumn_212", "train_column_212", "train_crash" );
    addNotetrack_flag( "train_car1", "collumn_211", "train_column_211", "train_crash" );
    addNotetrack_flag( "train_car1", "collumn_203", "train_column_203", "train_crash" );
    addNotetrack_flag( "train_car1", "collumn_202", "train_column_202", "train_crash" );
    addNotetrack_flag( "train_car1", "collumn_201", "train_column_201", "train_crash" );
    addNotetrack_flag( "train_car1", "collumn_193", "train_column_193", "train_crash" );
    addNotetrack_flag( "train_car1", "collumn_192", "train_column_192", "train_crash" );
    addNotetrack_flag( "train_car1", "collumn_191", "train_column_191", "train_crash" );
    addNotetrack_flag( "train_car1", "collumn_183", "train_column_183", "train_crash" );
    addNotetrack_flag( "train_car1", "collumn_182", "train_column_182", "train_crash" );
    addNotetrack_flag( "train_car1", "collumn_181", "train_column_181", "train_crash" );
    addNotetrack_flag( "train_car1", "collumn_173", "train_column_173", "train_crash" );
    addNotetrack_flag( "train_car1", "collumn_172", "train_column_172", "train_crash" );
    addNotetrack_flag( "train_car1", "collumn_171", "train_column_171", "train_crash" );
    addNotetrack_flag( "train_car1", "collumn_163", "train_column_163", "train_crash" );
    addNotetrack_flag( "train_car1", "collumn_162", "train_column_162", "train_crash" );
    addNotetrack_flag( "train_car1", "collumn_161", "train_column_161", "train_crash" );
    addNotetrack_flag( "train_car1", "collumn_153", "train_column_153", "train_crash" );
    addNotetrack_flag( "train_car1", "collumn_152", "train_column_152", "train_crash" );
    addNotetrack_flag( "train_car1", "collumn_151", "train_column_151", "train_crash" );
    addNotetrack_flag( "train_car1", "collumn_143", "train_column_143", "train_crash" );
    addNotetrack_flag( "train_car1", "collumn_142", "train_column_142", "train_crash" );
    addNotetrack_flag( "train_car1", "collumn_141", "train_column_141", "train_crash" );
    addNotetrack_flag( "train_car1", "collumn_133", "train_column_133", "train_crash" );
    addNotetrack_flag( "train_car1", "collumn_132", "train_column_132", "train_crash" );
    addNotetrack_flag( "train_car1", "collumn_131", "train_column_131", "train_crash" );
    addNotetrack_flag( "train_car1", "collumn_123", "train_column_123", "train_crash" );
    addNotetrack_flag( "train_car1", "collumn_122", "train_column_122", "train_crash" );
    addNotetrack_flag( "train_car1", "collumn_121", "train_column_121", "train_crash" );
    addNotetrack_flag( "train_car1", "collumn_113", "train_column_113", "train_crash" );
    addNotetrack_flag( "train_car1", "collumn_112", "train_column_112", "train_crash" );
    addNotetrack_flag( "train_car1", "collumn_111", "train_column_111", "train_crash" );
    addNotetrack_flag( "train_car1", "collumn_103", "train_column_103", "train_crash" );
    addNotetrack_flag( "train_car1", "collumn_102", "train_column_102", "train_crash" );
    addNotetrack_flag( "train_car1", "collumn_101", "train_column_101", "train_crash" );
    addNotetrack_flag( "train_car1", "collumn_093", "train_column_093", "train_crash" );
    addNotetrack_flag( "train_car1", "collumn_092", "train_column_092", "train_crash" );
    addNotetrack_flag( "train_car1", "collumn_091", "train_column_091", "train_crash" );
    addNotetrack_flag( "train_car1", "collumn_083", "train_column_083", "train_crash" );
    addNotetrack_flag( "train_car1", "collumn_082", "train_column_082", "train_crash" );
    addNotetrack_flag( "train_car1", "collumn_081", "train_column_081", "train_crash" );
    addNotetrack_flag( "train_car1", "collumn_073", "train_column_073", "train_crash" );
    addNotetrack_flag( "train_car1", "collumn_072", "train_column_072", "train_crash" );
    addNotetrack_flag( "train_car1", "collumn_071", "train_column_071", "train_crash" );
    addNotetrack_flag( "train_car1", "collumn_063", "train_column_063", "train_crash" );
    addNotetrack_flag( "train_car1", "collumn_062", "train_column_062", "train_crash" );
    addNotetrack_flag( "train_car1", "collumn_061", "train_column_061", "train_crash" );
    addNotetrack_flag( "train_car1", "collumn_053", "train_column_053", "train_crash" );
    addNotetrack_flag( "train_car1", "collumn_052", "train_column_052", "train_crash" );
    addNotetrack_flag( "train_car1", "collumn_051", "train_column_051", "train_crash" );
    addNotetrack_flag( "train_car1", "collumn_043", "train_column_043", "train_crash" );
    addNotetrack_flag( "train_car1", "collumn_042", "train_column_042", "train_crash" );
    addNotetrack_flag( "train_car1", "collumn_041", "train_column_041", "train_crash" );
    addNotetrack_flag( "train_car1", "collumn_033", "train_column_033", "train_crash" );
    addNotetrack_flag( "train_car1", "collumn_032", "train_column_032", "train_crash" );
    addNotetrack_flag( "train_car1", "collumn_031", "train_column_031", "train_crash" );
    addNotetrack_flag( "train_car1", "collumn_023", "train_column_023", "train_crash" );
    addNotetrack_flag( "train_car1", "collumn_022", "train_column_022", "train_crash" );
    addNotetrack_flag( "train_car1", "collumn_021", "train_column_021", "train_crash" );
    addNotetrack_flag( "train_car1", "collumn_013", "train_column_013", "train_crash" );
    addNotetrack_flag( "train_car1", "collumn_012", "train_column_012", "train_crash" );
    addNotetrack_flag( "train_car1", "collumn_011", "train_column_011", "train_crash" );
    addNotetrack_flag( "train_car1", "collumn_003", "train_column_003", "train_crash" );
    addNotetrack_flag( "train_car1", "collumn_002", "train_column_002", "train_crash" );
    addNotetrack_flag( "train_car1", "collumn_001", "train_column_001", "train_crash" );

    addNotetrack_flag( "truck", "truck_debris", "london_truck_crash", "train_crash" );
    addNotetrack_flag( "truck", "explode", "train_crash_explode", "train_crash" );

    addNotetrack_startFXonTag( "train_car1", "sparks_start", "train_crash", "sparks_subway_scrape_line", "TAG_BOTTOM_FX" );
    addNotetrack_stopFXonTag( "train_car1", "sparks_stop", "train_crash", "sparks_subway_scrape_line", "TAG_BOTTOM_FX" );

//    addNotetrack_startFXonTag( "train_car1", "top_fx_start", "train_crash", "debris_subway_scrape_line", "TAG_TOP_FX" );
//    addNotetrack_stopFXonTag( "train_car1", "top_fx_stop", "train_crash", "debris_subway_scrape_line", "TAG_TOP_FX" );

    addNotetrack_startFXonTag( "train_car1",    "sparks_front_start",   "train_crash", "sparks_subway_scrape_point", "TAG_FRONT_FX" );
    addNotetrack_stopFXonTag(  "train_car1",    "sparks_front_stop",    "train_crash", "sparks_subway_scrape_point", "TAG_FRONT_FX" );

    addNotetrack_startFXonTag( "train_car1",    "sparks_back_start",    "train_crash", "sparks_subway_scrape_point", "TAG_BACK_FX" );
    addNotetrack_stopFXonTag(  "train_car1",    "sparks_back_stop",     "train_crash", "sparks_subway_scrape_point", "TAG_BACK_FX" );

    addNotetrack_startFXonTag( "train_car1",    "bottom_player_fx_start",   "train_crash", "debris_subway_scrape_line", "TAG_PLAYER1_FX" );
    addNotetrack_stopFXonTag(  "train_car1",    "bottom_player_fx_stop",    "train_crash", "debris_subway_scrape_line", "TAG_PLAYER1_FX" );

//    addNotetrack_customFunction( "train_car1", "top_player_fx_start", ::top_player_fx_start, "train_crash" );
//    addNotetrack_customFunction( "train_car1", "top_player_fx_stop", ::top_player_fx_stop, "train_crash" );


    addNotetrack_startFXonTag( "train_car1",    "wheel_sparks_on",   "train_crash", "sparks_subway_scrape_point_wheels", "TAG_BOTTOM_FX" );
    addNotetrack_stopFXonTag(  "train_car1",    "wheel_sparks_off",  "train_crash", "sparks_subway_scrape_point_wheels", "TAG_BOTTOM_FX" );

    addNotetrack_startFXonTag( "train_car1",    "wheel_sparks_on_2",   "train_crash", "sparks_subway_scrape_point_wheels", "TAG_TOP_FX" );
    addNotetrack_stopFXonTag(  "train_car1",    "wheel_sparks_off_2",  "train_crash", "sparks_subway_scrape_point_wheels", "TAG_TOP_FX" );

    addNotetrack_startFXonTag( "train_car1",    "wheel_sparks_on_3",   "train_crash", "sparks_subway_scrape_point_wheels", "TAG_BACK_FX" );
    addNotetrack_stopFXonTag(  "train_car1",    "wheel_sparks_off_3",  "train_crash", "sparks_subway_scrape_point_wheels", "TAG_BACK_FX" );

    addNotetrack_startFXonTag( "train_car1",    "wheel_sparks_on_4",   "train_crash", "sparks_subway_scrape_point_wheels", "TAG_PLAYER2_FX" );
    addNotetrack_stopFXonTag(  "train_car1",    "wheel_sparks_off_4",  "train_crash", "sparks_subway_scrape_point_wheels", "TAG_PLAYER2_FX" );

    addNotetrack_customFunction( "train_car1", "truck_spew_on", ::truck_spew_start, "train_crash" );
    addNotetrack_customFunction( "train_car1", "truck_spew_off", ::truck_spew_stop, "train_crash" );

    addNotetrack_customFunction( "train_car1", "subway_fallover", ::subway_fallover, "train_crash" );

	level.scr_anim[ "train_car1_broken" ][ "train_crash" ] = %london_train_break;

    addNotetrack_customFunction( "train_car1_broken", "sparks_start", ::broken_back_spew_start, "train_crash" );
    addNotetrack_customFunction( "train_car1_broken", "sparks_stop", ::broken_back_spew_stop, "train_crash" );

    addNotetrack_customFunction( "train_car1_broken", "sparks_start_2", ::broken_front_2_spew_start, "train_crash" );
    addNotetrack_customFunction( "train_car1_broken", "sparks_stop_2", ::broken_front_2_spew_stop, "train_crash" );

    addNotetrack_customFunction( "train_car1_broken", "sparks_end", ::broken_back_spew_end, "train_crash" );
    addNotetrack_customFunction( "train_car1_broken", "sparks_end_2", ::broken_front_2_spew_end, "train_crash" );

    addNotetrack_customFunction( "train_car1_broken", "train_impact_1", ::broken_back_1_impact, "train_crash" );
    addNotetrack_customFunction( "train_car1_broken", "train_impact_2", ::broken_front_2_impact, "train_crash" );

    addNotetrack_customFunction( "train_car1_broken", "sparks_grind", ::broken_front_grind_start, "train_crash" );
    addNotetrack_customFunction( "train_car1_broken", "sparks_grind_stop", ::broken_front_grind_stop, "train_crash" );

	level.scr_anim[ "train_car2" ][ "train_crash" ] = %london_train_crash_2;

    addNotetrack_startFXonTag( "train_car2",    "wheel_sparks_on",   "train_crash", "sparks_subway_scrape_point_wheels", "TAG_BOTTOM_FX" );
    addNotetrack_stopFXonTag(  "train_car2",    "wheel_sparks_off",  "train_crash", "sparks_subway_scrape_point_wheels", "TAG_BOTTOM_FX" );

    addNotetrack_startFXonTag( "train_car2",    "wheel_sparks_on_2",   "train_crash", "sparks_subway_scrape_point_wheels", "TAG_TOP_FX" );
    addNotetrack_stopFXonTag(  "train_car2",    "wheel_sparks_off_2",  "train_crash", "sparks_subway_scrape_point_wheels", "TAG_TOP_FX" );

    addNotetrack_startFXonTag( "train_car2",    "wheel_sparks_on_3",   "train_crash", "sparks_subway_scrape_point_wheels", "TAG_BACK_FX" );
    addNotetrack_stopFXonTag(  "train_car2",    "wheel_sparks_off_3",  "train_crash", "sparks_subway_scrape_point_wheels", "TAG_BACK_FX" );

    addNotetrack_startFXonTag( "train_car2",    "wheel_sparks_on_4",   "train_crash", "sparks_subway_scrape_point_wheels", "TAG_PLAYER2_FX" );
    addNotetrack_stopFXonTag(  "train_car2",    "wheel_sparks_off_4",  "train_crash", "sparks_subway_scrape_point_wheels", "TAG_PLAYER2_FX" );

    addNotetrack_customFunction( "train_car2", "subway_fallover", ::subway_fallover_sparky, "train_crash" );

 //   addNotetrack_customFunction( "train_car2", "bottom_player_fx_start", ::bottom_player_fx_start, "train_crash" );
 //   addNotetrack_customFunction( "train_car2", "bottom_player_fx_stop", ::bottom_player_fx_stop, "train_crash" );


	level.scr_anim[ "train_car3" ][ "train_crash" ] = %london_train_crash_3;

    addNotetrack_startFXonTag( "train_car3",    "wheel_sparks_on",   "train_crash", "sparks_subway_scrape_point_wheels", "TAG_BOTTOM_FX" );
    addNotetrack_stopFXonTag(  "train_car3",    "wheel_sparks_off",  "train_crash", "sparks_subway_scrape_point_wheels", "TAG_BOTTOM_FX" );

    addNotetrack_startFXonTag( "train_car3",    "wheel_sparks_on_2",   "train_crash", "sparks_subway_scrape_point_wheels", "TAG_TOP_FX" );
    addNotetrack_stopFXonTag(  "train_car3",    "wheel_sparks_off_2",  "train_crash", "sparks_subway_scrape_point_wheels", "TAG_TOP_FX" );

    addNotetrack_startFXonTag( "train_car3",    "wheel_sparks_on_3",   "train_crash", "sparks_subway_scrape_point_wheels", "TAG_BACK_FX" );
    addNotetrack_stopFXonTag(  "train_car3",    "wheel_sparks_off_3",  "train_crash", "sparks_subway_scrape_point_wheels", "TAG_BACK_FX" );

    addNotetrack_startFXonTag( "train_car3",    "wheel_sparks_on_4",   "train_crash", "sparks_subway_scrape_point_wheels", "TAG_PLAYER2_FX" );
    addNotetrack_stopFXonTag(  "train_car3",    "wheel_sparks_off_4",  "train_crash", "sparks_subway_scrape_point_wheels", "TAG_PLAYER2_FX" );

	level.scr_anim[ "train_car4" ][ "train_crash" ] = %london_train_crash_4;
	level.scr_anim[ "train_car4_mirrored" ][ "train_crash" ] = %london_train_crash_4;

    addNotetrack_startFXonTag( "train_car4",    "wheel_sparks_on",   "train_crash", "sparks_subway_scrape_point_wheels", "TAG_BOTTOM_FX" );
    addNotetrack_stopFXonTag(  "train_car4",    "wheel_sparks_off",  "train_crash", "sparks_subway_scrape_point_wheels", "TAG_BOTTOM_FX" );

    addNotetrack_startFXonTag( "train_car4",    "wheel_sparks_on_2",   "train_crash", "sparks_subway_scrape_point_wheels", "TAG_TOP_FX" );
    addNotetrack_stopFXonTag(  "train_car4",    "wheel_sparks_off_2",  "train_crash", "sparks_subway_scrape_point_wheels", "TAG_TOP_FX" );

    addNotetrack_startFXonTag( "train_car4",    "wheel_sparks_on_3",   "train_crash", "sparks_subway_scrape_point_wheels", "TAG_BACK_FX" );
    addNotetrack_stopFXonTag(  "train_car4",    "wheel_sparks_off_3",  "train_crash", "sparks_subway_scrape_point_wheels", "TAG_BACK_FX" );

    addNotetrack_startFXonTag( "train_car4",    "wheel_sparks_on_4",   "train_crash", "sparks_subway_scrape_point_wheels", "TAG_PLAYER2_FX" );
    addNotetrack_stopFXonTag(  "train_car4",    "wheel_sparks_off_4",  "train_crash", "sparks_subway_scrape_point_wheels", "TAG_PLAYER2_FX" );

	level.scr_anim[ "truck" ][ "train_crash" ]      = %london_truck_crash;

    addNotetrack_customFunction( "truck", "truck_dust_start", ::truck_dust_start, "train_crash" );
    addNotetrack_customFunction( "truck", "truck_dust_stop", ::truck_dust_stop, "train_crash" );

	level.scr_anim[ "truck_wrecked" ][ "train_crash" ] = %london_truck_crash;

	level.scr_anim[ "player_car" ][ "train_crash" ] = %london_player_truck;
    addNotetrack_customFunCtion( "player_car", "player_bail", maps\westminster_code::player_bail, "train_crash" );

	level.scr_anim[ "player_car_mirrored" ][ "train_crash" ] = %london_player_truck;
    addNotetrack_customFunction( "player_car_mirrored", "truck_slowing_1_start", ::truck_slide_spew_start, "train_crash" );

	level.scr_model[ "train_car1" ] 						 	= "vehicle_subway_cart_destructible";
	level.scr_model[ "train_car1_broken" ] 						 	= "vehicle_subway_cart_destroyed";
	level.scr_model[ "train_car2" ] 						 	    = "vehicle_subway_cart_destructible";
	level.scr_model[ "train_car3" ] 						 	= "vehicle_subway_cart_destructible";
	level.scr_model[ "train_car4" ] 						 	= "vehicle_subway_cart_destructible";
	level.scr_model[ "train_car4_mirrored" ] 						 	= "vehicle_subway_cart_destructible";
	level.scr_model[ "truck" ] 						 	        = "vehicle_uk_utility_truck_destructible";
	level.scr_model[ "truck_wrecked" ] 						 	        = "vehicle_uk_utility_truck_trainwreck";
	level.scr_model[ "player_car" ] 						 	= "vehicle_uk_utility_truck_destructible";
	level.scr_model[ "player_car_mirrored" ] 						 	= "vehicle_uk_utility_truck_destructible";

	level.scr_anim[ "train_intersect_car" ][ "intersection_crash" ] = %london_railcross_car_crash;
    level.scr_model[ "train_intersect_car" ]                        = "uk_police_estate_destructible";
	level.scr_animtree[ "train_intersect_car" ]                     = #animtree;

	level.scr_animtree[ "train_car1" ] 						= #animtree;
	level.scr_animtree[ "train_car1_broken" ] 				= #animtree;
	level.scr_animtree[ "train_car2" ] 						= #animtree;
	level.scr_animtree[ "train_car3" ] 						= #animtree;
	level.scr_animtree[ "train_car4" ] 						= #animtree;
	level.scr_animtree[ "train_car4_mirrored" ] 			= #animtree;
	level.scr_animtree[ "truck" ] 						    = #animtree;
	level.scr_animtree[ "truck_wrecked" ] 					= #animtree;
	level.scr_animtree[ "player_car" ] 						= #animtree;
	level.scr_animtree[ "player_car_mirrored" ] 			= #animtree;
	
}


force_door_shut()
{
    wait 0.1;
    self ClearAnim( %london_utilitytruck_driver_mount_door, 0 );
    self ClearAnim( %london_utilitytruck_passenger_mount_door, 0 );
}



top_player_fx_start( guy )
{
 //   PlayFXOnTag( getfx( "sparks_subway_scrape_player" ), guy, "TAG_PLAYER2_FX" );
}

top_player_fx_stop( guy )
{
// //   StopFXOnTag( getfx( "sparks_subway_scrape_player" ), guy, "TAG_PLAYER2_FX" );
}



subway_fallover( guy )
{
    PlayFXOnTag( getfx( "debris_subway_fallover" ), guy, "TAG_PLAYER1_FX" );
}

subway_fallover_sparky( guy )
{
    PlayFXOnTag( getfx( "debris_subway_fallover_sparky" ), guy, "TAG_PLAYER1_FX" );
}

truck_spew_start( guy )
{
    PlayFXOnTag( getfx( "uk_utility_truck_spew" ), guy, "TAG_FRONT_FX" );
}

truck_spew_stop( guy )
{
    StopFXOnTag( getfx( "uk_utility_truck_spew" ), guy, "TAG_FRONT_FX" );
}

sparks_start_half( guy )
{
    PlayFXOnTag( getfx( "sparks_subway_scrape_line_short" ), guy, "TAG_BOTTOM_FX" );
}

sparks_stop_half( guy )
{
    StopFXOnTag( getfx( "sparks_subway_scrape_line_short" ), guy, "TAG_BOTTOM_FX" );
}

top_fx_start_half( guy )
{
    PlayFXOnTag( getfx( "debris_subway_scrape_line_short" ), guy, "TAG_TOP_FX" );
}

top_fx_stop_half( guy )
{
    StopFXOnTag( getfx( "debris_subway_scrape_line_short" ), guy, "TAG_TOP_FX" );
}


truck_slide_spew_start( guy )
{
    PlayFXOnTag( getfx( "sparks_truck_scrape_line_short_diminishing" ), guy, "TAG_TAIL_LIGHT_LEFT" );
}



broken_back_spew_start( guy )
{
    PlayFXOnTag( getfx( "sparks_subway_scrape_line_short" ), guy, "TAG_BACK_SEVERED_FX" );
    PlayFXOnTag( getfx( "debris_subway_scrape_line_short" ), guy, "TAG_BACK_SEVERED_FX" );
}

broken_back_spew_stop( guy )
{
    StopFXOnTag( getfx( "sparks_subway_scrape_line_short" ), guy, "TAG_BACK_SEVERED_FX" );
    StopFXOnTag( getfx( "debris_subway_scrape_line_short" ), guy, "TAG_BACK_SEVERED_FX" );
}


broken_front_2_spew_start( guy )
{
   PlayFXOnTag( getfx( "sparks_subway_scrape_line_short" ), guy, "TAG_FRONT_SEVERED_FX" );
    PlayFXOnTag( getfx( "debris_subway_scrape_line_short" ), guy, "TAG_FRONT_SEVERED_FX" );
}

broken_front_2_spew_stop( guy )
{
    StopFXOnTag( getfx( "sparks_subway_scrape_line_short" ), guy, "TAG_FRONT_SEVERED_FX" );
    StopFXOnTag( getfx( "debris_subway_scrape_line_short" ), guy, "TAG_FRONT_SEVERED_FX" );
}


broken_back_spew_end( guy )
{
    PlayFXOnTag( getfx( "sparks_subway_scrape_line_short_diminishing" ), guy, "TAG_BACK_SEVERED_FX" );
}

broken_front_2_spew_end( guy )
{
    PlayFXOnTag( getfx( "sparks_subway_scrape_line_short_diminishing" ), guy, "TAG_FRONT_SEVERED_FX" );
}


broken_back_1_impact( guy )
{
    PlayFXOnTag( getfx( "debris_subway_impact_line" ), guy, "TAG_BACK_SEVERED_FX" );
}

broken_front_2_impact( guy )
{
    PlayFXOnTag( getfx( "debris_subway_impact_line" ), guy, "TAG_FRONT_SEVERED_FX" );
}

broken_front_grind_start( guy )
{
    PlayFXOnTag( getfx( "debris_subway_scrape_line_short_heavy" ), guy, "TAG_FRONT_SEVERED_FX" );
    PlayFXOnTag( getfx( "sparks_subway_scrape_line_short_heavy" ), guy, "TAG_FRONT_SEVERED_FX" );
}

broken_front_grind_stop( guy )
{
    StopFXOnTag( getfx( "debris_subway_scrape_line_short_heavy" ), guy, "TAG_FRONT_SEVERED_FX" );
    StopFXOnTag( getfx( "sparks_subway_scrape_line_short_heavy" ), guy, "TAG_FRONT_SEVERED_FX" );
}


truck_dust_start( guy )
{
    PlayFXOnTag( getfx( "tread_dust_london_loop" ), guy, "TAG_WHEEL_FRONT_RIGHT" );
    PlayFXOnTag( getfx( "tread_dust_london_loop" ), guy, "TAG_WHEEL_FRONT_LEFT" );
    PlayFXOnTag( getfx( "tread_dust_london_loop" ), guy, "TAG_WHEEL_BACK_RIGHT" );
    PlayFXOnTag( getfx( "tread_dust_london_loop" ), guy, "TAG_WHEEL_BACK_LEFT" );
}

truck_dust_stop( guy )
{
    StopFXOnTag( getfx( "tread_dust_london_loop" ), guy, "TAG_WHEEL_FRONT_RIGHT" );
    StopFXOnTag( getfx( "tread_dust_london_loop" ), guy, "TAG_WHEEL_FRONT_LEFT" );
    StopFXOnTag( getfx( "tread_dust_london_loop" ), guy, "TAG_WHEEL_BACK_RIGHT" );
    StopFXOnTag( getfx( "tread_dust_london_loop" ), guy, "TAG_WHEEL_BACK_LEFT" );
}
