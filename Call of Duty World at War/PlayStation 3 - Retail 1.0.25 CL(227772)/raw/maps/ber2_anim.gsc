//
// file: ber2_anim.gsc
// description: animation setup script for berlin2
// scripter: slayback
//

#include maps\_utility;
#include maps\_anim;
#include maps\ber2_util;

#using_animtree( "generic_human" );

ber2_anim_init()
{
	setup_human_anims();
	setup_metrogate_anims();
	setup_chair_anims();
	setup_metrodoor_anims();
	setup_fallingsign_anims();
	setup_flag_anims();
	setup_buildingcollapse_anims();
	setup_woodbeam_anims();
	setup_rat_anims();
	
	// animations needed for util/anim scripts
	maps\_mganim::main();
}

setup_human_anims()
{
	// -- intro IGC --
	level.scr_anim["introIGC_victim"]["idle"][0] = %ch_berlin2_intro_guy1_hold;
	level.scr_anim["introIGC_guy2"]["idle"][0] = %ch_berlin2_intro_guy2_hold;
	level.scr_anim["introIGC_guy3"]["idle"][0] = %ch_berlin2_intro_guy3_hold;
	level.scr_anim["introIGC_guy4"]["idle"][0] = %ch_berlin2_intro_guy4_hold;
	
	level.scr_anim["introIGC_victim"]["intro_igc"] = %ch_berlin2_intro_guy1;  // the german being killed
	level.scr_anim["introIGC_guy2"]["intro_igc"] = %ch_berlin2_intro_guy2;  // to the right of the german, ENDS EARLY
	level.scr_anim["introIGC_guy3"]["intro_igc"] = %ch_berlin2_intro_guy3;  // to the left of the german - the executioner
	level.scr_anim["introIGC_guy4"]["intro_igc"] = %ch_berlin2_intro_guy4;  // to the left of the german
	// note: victim dialogue gets played in a special thread because I animate him with a .deathanim
	addNotetrack_dialogue( "introIGC_guy2", "dialog", "intro_igc", "Ber2_IGD_300A_RUR2" );
	addNotetrack_dialogue( "introIGC_guy2", "dialog", "intro_igc", "Ber2_IGD_003A_RUR2" );
	addNotetrack_dialogue( "introIGC_guy3", "dialog", "intro_igc", "Ber2_IGD_301A_RUR3" );
	addNotetrack_dialogue( "introIGC_guy3", "dialog", "intro_igc", "Ber2_IGD_303A_RUR3" );
	addNotetrack_dialogue( "introIGC_guy4", "dialog", "intro_igc", "Ber2_IGD_001A_RUR1" );
	addNotetrack_dialogue( "introIGC_guy4", "dialog", "intro_igc", "Ber2_IGD_302A_RUR1" );
	addNotetrack_dialogue( "introIGC_guy4", "dialog", "intro_igc", "Ber2_IGD_304A_RUR1" );
	addNotetrack_dialogue( "introIGC_guy4", "dialog", "intro_igc", "Ber2_IGD_305A_RUR1" );
	addNotetrack_customFunction( "introIGC_guy3", "fire", maps\ber2_event1::event1_introIGC_gunshotFX, "intro_igc" );
	addNotetrack_sound( "introIGC_guy3", "fire", "intro_igc", "weap_tt33_fire" );  // gunshot sound

	
	// -- intro reactions --
	// "This is not war - this is murder."
	level.scr_sound["hero1"]["notwar_murder"] = "Ber2_IGD_004A_CHER";
	// "This is how you end a war, Chernov."
	level.scr_sound["sarge"]["how_you_end_a_war"] = "Ber2_IGD_005A_REZN";

	// -- reactions to rooftop rockets --
	// "This is madness - Our rockets are tearing the city apart!"
	level.scr_sound["hero1"]["this_is_madness"] = "Ber2_IGD_006A_CHER";
	// "Get inside."
	level.scr_sound["sarge"]["get_inside"] = "Ber2_IGD_007A_REZN";

	
	// -- event1 apt1 sneaky action anims --
	// "Shhhh!"
	level.scr_sound["sarge"]["shhh"] = "Ber2_IGD_008A_REZN";
	// "Move quietly - take them by surprise."
	level.scr_sound["sarge"]["movequietly"] = "Ber2_IGD_009A_REZN";
	// "Take them down, quickly."
	level.scr_sound["sarge"]["takethemdown"] = "Ber2_IGD_010A_REZN";
	// "Ready?..."
	level.scr_sound["sarge"]["are_you_ready"] = "Ber2_IGD_011A_REZN";
	// "Cut them down!"
	level.scr_sound["sarge"]["cut_them_down"] = "Ber2_IGD_024A_REZN";
	// "Kill them all!"
	level.scr_sound["sarge"]["kill_them_all"] = "Ber2_IGD_026A_REZN";
	// "Room clear."
	level.scr_sound["sarge"]["roomclear"] = "Ber2_IGD_028A_REZN";
	
	level.scr_anim["mapreader1"]["readingmap"][0] = %ch_officer1_reading_wall_map_loop;
	level.scr_anim["mapreader2"]["readingmap"][0] = %ch_officer2_reading_wall_map_loop;
	level.scr_anim["mapreader1"]["readingmap_surprise"] = %ch_officer1_reading_wall_map_alert;
	level.scr_anim["mapreader2"]["readingmap_surprise"] = %ch_officer2_reading_wall_map_alert;
	level.scr_anim["telegrapher"]["tapping"][0] = %ch_telegraph_guy_tapping_loop;
	level.scr_anim["telegrapher"]["tapping_death"] = %ch_telegraph_guy_tapping_death;
	level.scr_anim["telegrapher"]["tapping_surprise"] = %ch_telegraph_guy_tapping_alert;
	// "They are here!"
	level.scr_sound["mapreader2"]["readingmap_surprise"] = "Ber2_IGD_021A_GMP2";
	
	level.scr_anim["rifleman1"]["loop"][0] = %ch_berlin2_rifle_guy1_loop;
	level.scr_anim["rifleman2"]["loop"][0] = %ch_berlin2_rifle_guy2_loop;
	level.scr_anim["rifleman3"]["loop"][0] = %ch_berlin2_rifle_guy3_loop;
	level.scr_anim["rifleman1"]["reaction"] = %ch_berlin2_rifle_guy1_reaction;
	level.scr_anim["rifleman2"]["reaction"] = %ch_berlin2_rifle_guy2_reaction;
	level.scr_anim["rifleman3"]["reaction"] = %ch_berlin2_rifle_guy3_reaction;
	
	// -- German executing a Russian soldier on his knees --
	level.scr_anim["knees_execution_executioner"]["execute"] = %ch_berlin2_E1vignette2_german;
	level.scr_anim["knees_execution_victim"]["execute"] = %ch_berlin2_E1vignette2_russian_dead;
	level.scr_anim["knees_execution_victim"]["saved_getup"] = %ch_berlin2_E1vignette2_russian_alive;
	addNotetrack_dialogue( "knees_execution_victim", "dialog", "execute", "Ber2_IGD_034A_RUR1" );
	addNotetrack_dialogue( "knees_execution_executioner", "dialog", "execute", "Ber2_IGD_035A_GER2" );
	addNotetrack_sound( "knees_execution_executioner", "shoot", "execute", "weap_kar98k_fire" );  // gunshot sound
	addNotetrack_customFunction( "knees_execution_executioner", "shoot", maps\ber2_event1::event1_knees_execution_gunshotFX, "execute" );  // gunshot fx
	addNotetrack_sound( "knees_execution_executioner", "shot_in_the_head", "execute", "bullet_large_flesh" );  // headshot sound
	addNotetrack_customFunction( "knees_execution_executioner", "shot_in_the_head", maps\ber2_event1::event1_knees_execution_headshotFX, "execute" );  // headshot fx
	
	// -- squad reaction to falling boards --
	// "Look out!"
	level.scr_sound["redshirt"]["lookout"] = "Ber2_IGD_041A_RUR1";
	// "Watch your heads."
	level.scr_sound["sarge"]["watchyourheads"] = "Ber2_IGD_039A_REZN";
	// "The building is collapsing around us!"
	level.scr_sound["hero1"]["building_collapsing"] = "Ber2_IGD_040A_CHER";
	
	// -- various executions of wounded soldiers --
	level.scr_anim["wounded_execution1_victim"]["wounded_loop"][0] = %ch_execution1_wounded_loop;
	level.scr_anim["wounded_execution1_victim"]["execution_shot"] = %ch_execution1_wounded_shot;
	level.scr_anim["wounded_execution1_executioner"]["execution_shot"] = %ch_execution1_shooter;
	addNotetrack_customFunction( "wounded_execution1_executioner", "fire", maps\ber2_event1::street_execution_gunshotFX, "execution_shot" );  // gunshot fx
	addNotetrack_sound( "wounded_execution1_executioner", "fire", "execution_shot", "weap_kar98k_fire" );  // gunshot sound
	addNotetrack_sound( "wounded_execution1_executioner", "head_shot", "execution_shot", "bullet_large_flesh" );  // headshot sound
	
	level.scr_anim["wounded_execution2_victim"]["wounded_loop"][0] = %ch_execution2_wounded_loop;
	level.scr_anim["wounded_execution2_victim"]["execution_shot"] = %ch_execution2_wounded_shot;
	level.scr_anim["wounded_execution2_executioner"]["execution_shot"] = %ch_execution2_shooter;
	addNotetrack_customFunction( "wounded_execution2_executioner", "fire", maps\ber2_event1::street_execution_gunshotFX, "execution_shot" );  // gunshot fx
	addNotetrack_sound( "wounded_execution2_executioner", "fire", "execution_shot", "weap_kar98k_fire" );  // gunshot sound
	addNotetrack_sound( "wounded_execution2_executioner", "head_shot", "execution_shot", "bullet_large_flesh" );  // headshot sound
	
	level.scr_anim["wounded_execution3_victim"]["wounded_loop"][0] = %ch_execution3_wounded_loop;
	level.scr_anim["wounded_execution3_victim"]["execution_shot"] = %ch_execution3_wounded_shot;
	level.scr_anim["wounded_execution3_executioner"]["execution_shot"] = %ch_execution3_shooter;
	addNotetrack_customFunction( "wounded_execution3_executioner", "fire", maps\ber2_event1::street_execution_gunshotFX, "execution_shot" );  // gunshot fx
	addNotetrack_sound( "wounded_execution3_executioner", "fire", "execution_shot", "weap_kar98k_fire" );  // gunshot sound
	addNotetrack_sound( "wounded_execution3_executioner", "head_shot", "execution_shot", "bullet_large_flesh" );  // headshot sound
	
	// -- Russian unfurling flag --
	level.scr_anim["flag_guy"]["unfurl"] = %ch_berlin2_flag_unravel;
	
	// -- mortar run explosion death --
	level.scr_anim["gibber"]["mortar_death_forward"] = %death_explosion_forward13;
	level.scr_anim["gibber"]["mortar_death_up"] = %death_explosion_up10;
	
	// -- metro gate execution scene --
	level.scr_anim["metrogate_exe_sarge"]["idle1"][0] = %ch_berlin2_sub_entrance_reznov_idle;
	level.scr_anim["metrogate_exe_sarge"]["idle2"][0] = %ch_berlin2_sub_entrance_reznov_idle2;
	level.scr_anim["metrogate_exe_sarge"]["scene"] = %ch_berlin2_sub_entrance_reznov;
	
	addNotetrack_dialogue( "metrogate_exe_sarge", "dialog", "scene", "Ber2_IGD_066A_REZN" );
	addNotetrack_dialogue( "metrogate_exe_sarge", "dialog", "scene", "Ber2_IGD_068A_REZN" );
	addNotetrack_dialogue( "metrogate_exe_sarge", "dialog", "scene", "Ber2_IGD_069A_REZN" );
	addNotetrack_dialogue( "metrogate_exe_sarge", "dialog", "scene", "Ber2_IGD_200A_REZN" );
	
	// pick one of these at runtime to play
	level.scr_anim["metrogate_exe_sarge"]["escape_mercy"] = %ch_berlin2_sub_entrance_reznov_escape_a;
	level.scr_anim["metrogate_exe_sarge"]["escape_burn"] = %ch_berlin2_sub_entrance_reznov_escape_b;
	// "Chernov - You should learn from Dimitri... He understands the nature of mercy killing."
	addNotetrack_dialogue( "metrogate_exe_sarge", "dialog", "escape_mercy", "Ber2_IGD_070A_REZN" );
	// "You should have shot them, Chernov. It is only cruel to prolong an animal's suffering."
	addNotetrack_dialogue( "metrogate_exe_sarge", "dialog", "escape_burn", "Ber2_IGD_071A_REZN" );
	
	// "Quickly - into the subway!"
	addNotetrack_dialogue( "metrogate_exe_sarge", "dialog", "escape_mercy", "Ber2_IGD_073A_REZN" );
	addNotetrack_dialogue( "metrogate_exe_sarge", "dialog", "escape_burn", "Ber2_IGD_073A_REZN" );
	// "This way!"
	addNotetrack_dialogue( "metrogate_exe_sarge", "dialog", "escape_mercy", "Ber2_IGD_076A_REZN" );
	addNotetrack_dialogue( "metrogate_exe_sarge", "dialog", "escape_burn", "Ber2_IGD_076A_REZN" );
	
	level.scr_anim["metrogate_exe_hero1"]["idle1"][0] = %ch_berlin2_sub_entrance_chernov_idle;
	level.scr_anim["metrogate_exe_hero1"]["idle2"][0] = %ch_berlin2_sub_entrance_chernov_idle2;
	level.scr_anim["metrogate_exe_hero1"]["scene"] = %ch_berlin2_sub_entrance_chernov;
	level.scr_anim["metrogate_exe_hero1"]["escape"] = %ch_berlin2_sub_entrance_chernov_escape;
	
	addNotetrack_dialogue( "metrogate_exe_hero1", "dialog", "scene", "Ber2_IGD_067A_CHER" );
	addNotetrack_dialogue( "metrogate_exe_hero1", "dialog", "escape", "Ber2_IGD_072A_CHER" );
	
	level.scr_anim["metrogate_exe_redshirt1"]["molotov_idle1"][0] = %ch_berlin2_metro_entrance_idle1_molotov1;
	level.scr_anim["metrogate_exe_redshirt2"]["molotov_idle1"][0] = %ch_berlin2_metro_entrance_idle1_molotov2;
	level.scr_anim["metrogate_exe_redshirt3"]["molotov_idle1"][0] = %ch_berlin2_metro_entrance_idle1_molotov3;
	level.scr_anim["metrogate_exe_redshirt4"]["molotov_idle1"][0] = %ch_berlin2_metro_entrance_idle1_molotov4;

	level.scr_anim["metrogate_exe_redshirt1"]["molotov_takeout"] = %ch_berlin2_metro_entrance_takeout_molotov1;
	level.scr_anim["metrogate_exe_redshirt2"]["molotov_takeout"] = %ch_berlin2_metro_entrance_takeout_molotov2;
	level.scr_anim["metrogate_exe_redshirt3"]["molotov_takeout"] = %ch_berlin2_metro_entrance_takeout_molotov3;
	level.scr_anim["metrogate_exe_redshirt4"]["molotov_takeout"] = %ch_berlin2_metro_entrance_takeout_molotov4;
	
	level.scr_anim["metrogate_exe_redshirt1"]["molotov_idle2"][0] = %ch_berlin2_metro_entrance_idle2_molotov1;
	level.scr_anim["metrogate_exe_redshirt2"]["molotov_idle2"][0] = %ch_berlin2_metro_entrance_idle2_molotov2;
	level.scr_anim["metrogate_exe_redshirt3"]["molotov_idle2"][0] = %ch_berlin2_metro_entrance_idle2_molotov3;
	level.scr_anim["metrogate_exe_redshirt4"]["molotov_idle2"][0] = %ch_berlin2_metro_entrance_idle2_molotov4;
	
	level.scr_anim["metrogate_exe_redshirt1"]["molotov_throw"] = %ch_berlin2_metro_entrance_throw_molotov1;
	level.scr_anim["metrogate_exe_redshirt2"]["molotov_throw"] = %ch_berlin2_metro_entrance_throw_molotov2;
	level.scr_anim["metrogate_exe_redshirt3"]["molotov_throw"] = %ch_berlin2_metro_entrance_throw_molotov3;
	level.scr_anim["metrogate_exe_redshirt4"]["molotov_throw"] = %ch_berlin2_metro_entrance_throw_molotov4;
	
	level.scr_anim["metrogate_exe_redshirt1"]["molotov_putaway"] = %ch_berlin2_metro_entrance_putaway_molotov1;
	level.scr_anim["metrogate_exe_redshirt2"]["molotov_putaway"] = %ch_berlin2_metro_entrance_putaway_molotov2;
	level.scr_anim["metrogate_exe_redshirt3"]["molotov_putaway"] = %ch_berlin2_metro_entrance_putaway_molotov3;
	level.scr_anim["metrogate_exe_redshirt4"]["molotov_putaway"] = %ch_berlin2_metro_entrance_putaway_molotov4;
	
	level.scr_anim["metrogate_exe_german1"]["scene"] = %ch_berlin2_metro_entrance_german1;
	level.scr_anim["metrogate_exe_german2"]["scene"] = %ch_berlin2_metro_entrance_german2;
	level.scr_anim["metrogate_exe_german3"]["scene"] = %ch_berlin2_metro_entrance_german3;
	// "Bitte! Bitte!"
	addNotetrack_dialogue( "metrogate_exe_german2", "dialog", "scene", "Ber1_IGD_109A_GER3" );
	// "Zeiga ze genade"
	addNotetrack_dialogue( "metrogate_exe_german2", "dialog", "scene", "Ber1_IGD_110A_GER3" );
	// "Ich bitte zei!"
	addNotetrack_dialogue( "metrogate_exe_german3", "dialog", "scene", "Ber1_IGD_108A_GER2" );
	
	level.scr_anim["metrogate_exe_german1"]["idle2"][0] = %ch_berlin2_metro_entrance_german1_idle;
	level.scr_anim["metrogate_exe_german2"]["idle2"][0] = %ch_berlin2_metro_entrance_german2_idle;
	level.scr_anim["metrogate_exe_german3"]["idle2"][0] = %ch_berlin2_metro_entrance_german3_idle;
	
	level.scr_anim["metrogate_exe_german1"]["burn"] = %ch_berlin2_metro_entrance_german1_burn;
	level.scr_anim["metrogate_exe_german2"]["burn"] = %ch_berlin2_metro_entrance_german2_burn;
	level.scr_anim["metrogate_exe_german3"]["burn"] = %ch_berlin2_metro_entrance_german3_burn;
	
	// -- opening the metro entrance gate --
	level.scr_anim["metro_gate_opener"]["open"] = %ch_lattice_gate_guy1_open;
	level.scr_anim["metro_gate_holder"]["open"] = %ch_lattice_gate_guy2_open;
	level.scr_anim["metro_gate_holder"]["hold"][0] = %ch_lattice_gate_guy2_idle;
	level.scr_anim["metro_gate_holder"]["close"] = %ch_lattice_gate_guy2_close;
	
	// -- metro MGs start --
	// "MG42 on the left platform!"
	level.scr_sound["metro_mg_notifier"]["mg_left"] = "Ber2_IGD_410A_RUR2";
	// "MG on the right platform!"
	level.scr_sound["metro_mg_notifier"]["mg_right"] = "Ber2_IGD_411A_RUR1";

	
	// -- guy trying to open subway exit gate --
	level.scr_anim["subway_exitgate_opener"]["doorstuck1"] = %ch_sarge_open_fail1;
	// "It's stuck!"
	level.scr_sound["subway_exitgate_opener"]["doorstuck1"] = "Ber2_IGD_095A_REZN";
	level.scr_anim["subway_exitgate_opener"]["doorstuck2"] = %ch_sarge_open_fail2;
	level.scr_anim["subway_exitgate_opener"]["doorstuck3"] = %ch_sarge_open_fail3;
	addNotetrack_sound( "subway_exitgate_opener", "Hit_Door", "doorstuck1", "metro_door_hit" );
	addNotetrack_sound( "subway_exitgate_opener", "Hit_Door", "doorstuck2", "metro_door_hit" );
	addNotetrack_sound( "subway_exitgate_opener", "Hit_Door", "doorstuck3", "metro_door_hit" );
	
	level.scr_anim["subway_exitgate_opener"]["twitch1"] = %ch_sarge_open_twitch1;
	// "Cover me!"
	level.scr_sound["subway_exitgate_opener"]["twitch1"] = "Ber2_IGD_096A_REZN";
	level.scr_anim["subway_exitgate_opener"]["twitch2"] = %ch_sarge_open_twitch2;
	// "Return fire!"
	level.scr_sound["subway_exitgate_opener"]["twitch2"] = "Ber2_IGD_205A_REZN";
	
	level.scr_anim["subway_exitgate_opener"]["twitch3"] = %ch_sarge_open_twitch1;
	// "Keep them off me!"
	level.scr_sound["subway_exitgate_opener"]["twitch3"] = "Ber2_IGD_097A_REZN";
	level.scr_anim["subway_exitgate_opener"]["twitch4"] = %ch_sarge_open_twitch2;
	// "Chyort! Hold them back!"
	level.scr_sound["subway_exitgate_opener"]["twitch4"] = "Ber2_IGD_098A_REZN";
	
	// "Almost got it!"
	level.scr_sound["subway_exitgate_opener"]["almost"] = "Ber2_IGD_206A_REZN";
	level.scr_anim["subway_exitgate_opener"]["success"] = %ch_sarge_open_success;
	// "Got it!!!"
	level.scr_sound["subway_exitgate_opener"]["success"] = "Ber2_IGD_209A_REZN";
	addNotetrack_sound( "subway_exitgate_opener", "Door_Creak", "success", "metro_door_hit" );
	
	// "What is that noise?!"
	level.scr_sound["subway_exitgate_reaction"]["doyouhearthat"] = "Ber2_IGD_203A_CHER";
	// "Rats!!!"
	level.scr_sound["subway_exitgate_reaction"]["rats"] = "Ber2_IGD_204A_CHER";
	// "Hurry, Sergeant!"
	level.scr_sound["subway_exitgate_reaction"]["hurryup"] = "Ber2_IGD_207A_CHER";
	// "My God!!!"
	level.scr_sound["subway_exitgate_reaction"]["omg"] = "Ber2_IGD_208A_CHER";
	
	// -- guys getting swept up in the wave --
	level.scr_anim["metrowave_casualty"]["wipeout1"] = %death_explosion_forward13;
	level.scr_anim["metrowave_casualty"]["wipeout2"] = %death_explosion_run_F_v1;
	level.scr_anim["metrowave_casualty"]["wipeout3"] = %death_explosion_run_F_v2;
	level.scr_anim["metrowave_casualty"]["wipeout4"] = %death_explosion_run_F_v3;
	level.scr_anim["metrowave_casualty"]["wipeout5"] = %death_explosion_run_F_v4;
	level.scr_anim["metrowave_casualty"]["wipeout6"] = %death_explosion_stand_F_v1;
	level.scr_anim["metrowave_casualty"]["wipeout7"] = %death_explosion_stand_F_v2;
	level.scr_anim["metrowave_casualty"]["wipeout8"] = %death_explosion_stand_F_v3;
	
	// -- post-wave floaty guy --
	level.scr_anim["metrowave_floater"]["float"] = %ch_berlin2_drowning_guy1;
	
	// -- patrol anims --
	level.scr_anim[ "generic" ][ "patrol_walk" ]			= %patrol_bored_patrolwalk;
	level.scr_anim[ "generic" ][ "patrol_walk_twitch" ]		= %patrol_bored_patrolwalk_twitch;
	level.scr_anim[ "generic" ][ "patrol_stop" ]			= %patrol_bored_walk_2_bored;
	level.scr_anim[ "generic" ][ "patrol_start" ]			= %patrol_bored_2_walk;
	level.scr_anim[ "generic" ][ "patrol_turn180" ]			= %patrol_bored_2_walk_180turn;
	
	level.scr_anim[ "generic" ][ "patrol_idle_1" ]			= %patrol_bored_idle;
	level.scr_anim[ "generic" ][ "patrol_idle_2" ]			= %patrol_bored_idle_smoke;
	level.scr_anim[ "generic" ][ "patrol_idle_3" ]			= %patrol_bored_idle_cellphone;
	level.scr_anim[ "generic" ][ "patrol_idle_4" ]			= %patrol_bored_twitch_bug;
	level.scr_anim[ "generic" ][ "patrol_idle_5" ]			= %patrol_bored_twitch_checkphone;
	level.scr_anim[ "generic" ][ "patrol_idle_6" ]			= %patrol_bored_twitch_stretch;
	
	level.scr_anim[ "generic" ][ "patrol_idle_smoke" ]		= %patrol_bored_idle_smoke;
	level.scr_anim[ "generic" ][ "patrol_idle_checkphone" ]	= %patrol_bored_twitch_checkphone;
	level.scr_anim[ "generic" ][ "patrol_idle_stretch" ]	= %patrol_bored_twitch_stretch;
	level.scr_anim[ "generic" ][ "patrol_idle_phone" ]		= %patrol_bored_idle_cellphone;
}

// non-human anim setup
#using_animtree( "ber2_metro_entrance_gate" );

setup_metrogate_anims()
{
	level.scr_anim["metro_gate_model"]["open"] = %o_lattice_gate_open;
	level.scr_anim["metro_gate_model"]["close"] = %o_lattice_gate_close;
}

#using_animtree( "ber2_chair" );

setup_chair_anims()
{
	level.scr_anim["telegrapher_chair"]["tapping"] = %o_berlin2_telegraph_chair_loop;
	level.scr_anim["telegrapher_chair"]["tapping_death"] = %o_berlin2_telegraph_chair_alert;
}

#using_animtree( "ber2_metro_exit_door" );

setup_metrodoor_anims()
{
	level.scr_anim["metro_door_sbmodel"]["doorstuck1"] = %o_open_door_fail1;
	level.scr_anim["metro_door_sbmodel"]["doorstuck2"] = %o_open_door_fail2;
	level.scr_anim["metro_door_sbmodel"]["doorstuck3"] = %o_open_door_fail3;
	level.scr_anim["metro_door_sbmodel"]["success"] = %o_open_door_success;
}

#using_animtree( "ber2_fallingsign" );

setup_fallingsign_anims()
{
	PrecacheModel( "anim_berlin_rooftop_sign_tall" );
	
	level.scr_animtree["fallingsign_controlmodel"] = #animtree;	
	level.scr_model["fallingsign_controlmodel"] = "anim_berlin_rooftop_sign_tall";
	
	level.scr_anim["fallingsign_controlmodel"]["sign_fall"] = %o_berlin2_sign_falldown;
	
	addNotetrack_customFunction( "fallingsign_controlmodel", "detach_N", maps\ber2_event1::fallingsign_detachN, "sign_fall" );
	addNotetrack_customFunction( "fallingsign_controlmodel", "detach_G", maps\ber2_event1::fallingsign_detachG, "sign_fall" );
	addNotetrack_customFunction( "fallingsign_controlmodel", "detach_E", maps\ber2_event1::fallingsign_detachE, "sign_fall" );
}

#using_animtree( "ber2_flag" );

setup_flag_anims()
{
	PrecacheModel( "anim_berlin_rus_flag_window_hang" );
	
	level.scr_animtree["big_flag"] = #animtree;	
	level.scr_model["big_flag"] = "anim_berlin_rus_flag_window_hang";
	
	level.scr_anim["big_flag"]["unfurl"] = %o_berlin2_flag_unravel;
	level.scr_anim["big_flag"]["idle"] = %o_berlin2_flag_unravel_loop;
}

#using_animtree( "ber2_buildingcollapse" );

setup_buildingcollapse_anims()
{
	PrecacheModel( "anim_berlin2_building_collapse" );
	
	level.scr_animtree["buildingcollapse_rig"] = #animtree;	
	level.scr_model["buildingcollapse_rig"] = "anim_berlin2_building_collapse";
	
	level.scr_anim["buildingcollapse_rig"]["hit1"] = %o_berlin2_building_hit1;
	level.scr_anim["buildingcollapse_rig"]["hit2"] = %o_berlin2_building_hit2;
	level.scr_anim["buildingcollapse_rig"]["towerfall"] = %o_berlin2_building_towerfall;
}

#using_animtree( "ber2_woodbeam" );

setup_woodbeam_anims()
{
	level.scr_anim["metrogate_woodbeam"]["resting"][0] = %o_lattice_gate_woodbeam_hold;
	level.scr_anim["metrogate_woodbeam"]["open"] = %o_lattice_gate_woodbeam_open;
	level.scr_anim["metrogate_woodbeam"]["hold"][0] = %o_lattice_gate_woodbeam_idle;
	level.scr_anim["metrogate_woodbeam"]["close"] = %o_lattice_gate_woodbeam_close;
	
	thread maps\ber2_event1::subway_gate_woodbeam_init();
}

#using_animtree( "ber2_rat" );

setup_rat_anims()
{
	level.scr_anim["rat"]["hop_loop"] = %ch_rat_hop_loop;
	level.scr_anim["rat"]["run_loop"] = %ch_rat_run_loop;
	level.scr_anim["rat"]["sniff"] = %ch_rat_sniff;
}

// --- UTIL ---
// self = the script_model being set up
setup_ally_char_model()
{
	self character\char_rus_wet_r_rifle::main();
}

setup_axis_char_model()
{
	self character\char_ger_wrmchtwet_k98::main();
}
