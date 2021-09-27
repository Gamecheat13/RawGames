#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;

main()
{
	generic_anims();
	radio();
	player_anims();
	russian_westminster();
	sas_ending();
	delivery_truck();
	vending_machine();
	vending_dudes();
	takedown_anims();
	new_generic_anims();
	sas_leader();
	police();
	ending_drone_anims();
	gas_model();
	civilian();
}

KNIFE_ATTACK_MODEL		=	"weapon_parabolic_knife";
KNIFE_ATTACK_TAG		=	"TAG_INHAND";

#using_animtree( "generic_human" );
generic_anims()
{
	// Westminster Station --------------------------------
	level.scr_anim[ "generic" ][ "dying_crawl" ]					= %dying_crawl;
	level.scr_anim[ "generic" ][ "dying_crawl_death_v2" ]			= %dying_crawl_death_v2;
	level.scr_anim[ "generic" ][ "exposed_death_flop" ]				= %exposed_death_flop;
	level.scr_anim[ "generic" ][ "dying_back_death_v1" ]			= %dying_back_death_v1;
	level.scr_anim[ "generic" ][ "dying_back_death_v2" ]			= %dying_back_death_v2;
	level.scr_anim[ "generic" ][ "dying_back_death_v3" ]			= %dying_back_death_v3;
	level.scr_anim[ "generic" ][ "dying_back_death_v4" ]			= %dying_back_death_v4;
	level.scr_anim[ "generic" ][ "dying_crawl_death_v1" ]			= %dying_crawl_death_v1;
	level.scr_anim[ "generic" ][ "civilian_leaning_death" ]			= %civilian_leaning_death;
	level.scr_anim[ "generic" ][ "exposed_death_nerve" ]			= %exposed_death_nerve;
	level.scr_anim[ "generic" ][ "run_death_roll" ]					= %run_death_roll;
	level.scr_anim[ "generic" ][ "death_pose_on_window" ]			= %death_pose_on_window;
	level.scr_anim[ "generic" ][ "death_pose_on_desk" ]				= %death_pose_on_desk;
	level.scr_anim[ "generic" ][ "exposed_death" ]					= %exposed_death;
	level.scr_anim[ "generic" ][ "exposed_death_falltoknees" ]		= %exposed_death_falltoknees;
	level.scr_anim[ "generic" ][ "civilain_crouch_hide_idle" ][0]	= %civilain_crouch_hide_idle;
	
	level.scr_anim[ "generic" ][ "station_melee_scene_sas" ]	= %cornerSdR_melee_winA_attacker;
	level.scr_anim[ "generic" ][ "station_melee_scene_chump" ]	= %cornerSdR_melee_winA_defender;
	
	level.scr_anim[ "generic" ][ "london_turnstile_traverse" ]	= %london_turnstile_traverse;

	// "Sir!"
	level.scr_sound[ "generic" ][ "london_sas1_sir" ] = "london_sas1_sir";
	
	addNotetrack_attach( "generic", "attach_knife", KNIFE_ATTACK_MODEL, KNIFE_ATTACK_TAG, "station_melee_scene_sas" );
	addNotetrack_detach( "generic", "detach_knife", KNIFE_ATTACK_MODEL, KNIFE_ATTACK_TAG, "station_melee_scene_sas" );
	addNotetrack_customFunction( "generic", "stab", maps\london_west_code::melee_scene_stab, "station_melee_scene_sas" );

	// Westminster Ending --------------------------------
	// Ziptie scene
//	level.scr_anim[ "generic" ][ "ziptie_soldier" ]				= %ziptie_soldier;
//	level.scr_anim[ "generic" ][ "ziptie_suspect" ]				= %ziptie_suspect;
//	level.scr_anim[ "generic" ][ "ziptie_suspect_idle" ][ 0 ]	= %ziptie_suspect_idle;
//	level.scr_anim[ "generic" ][ "hostage_knees_idle" ][ 0 ]	= %hostage_knees_idle;

	// Friendly checks a dying civ
	level.scr_anim[ "generic" ][ "hunted_woundedhostage_check_hostage" ]		= %hunted_woundedhostage_check_hostage;
//	level.scr_anim[ "generic" ][ "hunted_woundedhostage_idle_start" ][ 0 ]		= %hunted_woundedhostage_idle_start;
//	level.scr_anim[ "generic" ][ "hunted_woundedhostage_idle_end" ][ 0 ]		= %hunted_woundedhostage_idle_end;
	level.scr_anim[ "generic" ][ "hunted_woundedhostage_check_soldier" ]		= %hunted_woundedhostage_check_soldier;
	level.scr_anim[ "generic" ][ "hunted_woundedhostage_check_soldier_end" ]	= %hunted_woundedhostage_check_soldier_end;
	
	level.scr_anim[ "generic" ][ "jeepride_CPR_price" ]	= %jeepride_CPR_price;
	level.scr_anim[ "generic" ][ "jeepride_CPR_medic" ]	= %jeepride_CPR_medic;
	
	// Crowd gathering near truck
	level.scr_anim[ "generic" ][ "parabolic_phoneguy_idle" ][ 0 ] 				= %parabolic_phoneguy_idle;
	level.scr_anim[ "generic" ][ "roadkill_videotaper_3B_explosion_idle" ][ 0 ] = %roadkill_videotaper_3B_explosion_idle;
	level.scr_anim[ "generic" ][ "roadkill_videotaper_4B_explosion_idle" ][ 0 ] = %roadkill_videotaper_4B_explosion_idle;
	level.scr_anim[ "generic" ][ "roadkill_videotaper_2B_explosion_idle" ][ 0 ] = %roadkill_videotaper_2B_explosion_idle;
	level.scr_anim[ "generic" ][ "roadkill_videotaper_1B_explosion_idle" ][ 0 ] = %roadkill_videotaper_1B_explosion_idle;
	level.scr_anim[ "generic" ][ "civilian_smoking_A" ][ 0 ] 					= %civilian_smoking_A;
//	level.scr_anim[ "generic" ][ "civilian_directions_2_A_idle" ][ 0 ] 			= %civilian_directions_2_A_idle;
	level.scr_anim[ "generic" ][ "civilian_cower_idle" ][ 0 ] 					= %unarmed_cowercrouch_idle_duck;
	
	// Explosion Deaths
////	level.scr_anim[ "generic" ][ "civilian_explosion_death_B_1" ] 	= %death_explosion_stand_B_v1;
////	level.scr_anim[ "generic" ][ "civilian_explosion_death_B_2" ] 	= %death_explosion_stand_B_v2;	
////	level.scr_anim[ "generic" ][ "civilian_explosion_death_F_1" ] 	= %death_explosion_stand_F_v1;
////	level.scr_anim[ "generic" ][ "civilian_explosion_death_F_2" ] 	= %death_explosion_stand_F_v2;	
////	level.scr_anim[ "generic" ][ "civilian_explosion_death_L_1" ] 	= %death_explosion_stand_L_v1;
////	level.scr_anim[ "generic" ][ "civilian_explosion_death_L_2" ] 	= %death_explosion_stand_L_v2;	
////	level.scr_anim[ "generic" ][ "civilian_explosion_death_R_1" ] 	= %death_explosion_stand_R_v1;
////	level.scr_anim[ "generic" ][ "civilian_explosion_death_R_2" ] 	= %death_explosion_stand_R_v2;

	// Death Poses
////	level.scr_anim[ "generic" ][ "civilian_explosion_death_pose_1" ]	= %london_gas_death_1;
////	level.scr_anim[ "generic" ][ "civilian_explosion_death_pose_2" ]	= %london_gas_death_13;
////	level.scr_anim[ "generic" ][ "civilian_explosion_death_pose_3" ]	= %london_gas_death_12;
////	level.scr_anim[ "generic" ][ "civilian_explosion_death_pose_4" ]	= %london_gas_death_4;
	
	// Death anims
	level.scr_anim[ "generic" ][ "exposed_crouch_extendedpainA" ] 	= %exposed_crouch_extendedpainA;
	level.scr_anim[ "generic" ][ "death_explosion_stand_B_v2" ] 	= %death_explosion_stand_B_v2;	
	level.scr_anim[ "generic" ][ "death_explosion_stand_B_v4" ] 	= %death_explosion_stand_B_v4;	
	level.scr_anim[ "generic" ][ "civilian_run_hunched_C" ] 		= %civilian_run_hunched_C;
	level.scr_anim[ "generic" ][ "civilian_run_2_crawldeath" ] 		= %civilian_run_2_crawldeath;
//	level.scr_anim[ "generic" ][ "london_gas_death_1" ]				= %london_gas_death_1;	// Crouched, falls on side
//	level.scr_anim[ "generic" ][ "london_gas_death_2" ]				= %london_gas_death_2;	// Standing, holding on railing, falls on back
//	level.scr_anim[ "generic" ][ "london_gas_death_3" ]				= %london_gas_death_3;	// Standing, down to side
//	level.scr_anim[ "generic" ][ "london_gas_death_4" ]				= %london_gas_death_4;	// crouched, down to back
//	level.scr_anim[ "generic" ][ "london_gas_death_5" ]				= %london_gas_death_5;	// Stand, falls forward to ground
//	level.scr_anim[ "generic" ][ "london_gas_death_6" ]				= %london_gas_death_6;	// Walks forward coughing, forward to ground
//	level.scr_anim[ "generic" ][ "london_gas_death_7" ]				= %london_gas_death_7;	// Crawling forward, to side
//	level.scr_anim[ "generic" ][ "london_gas_death_8" ]				= %london_gas_death_8;	// On side
//	level.scr_anim[ "generic" ][ "london_gas_death_9" ]				= %london_gas_death_9;	// Crawling position, fall to side
//	level.scr_anim[ "generic" ][ "london_gas_death_10" ]			= %london_gas_death_10;	// Standing, stumbles, fall to side
//	level.scr_anim[ "generic" ][ "london_gas_death_11" ]			= %london_gas_death_11;	// On back twitching
//	level.scr_anim[ "generic" ][ "london_gas_death_12" ]			= %london_gas_death_12;	// On side twitching
//	level.scr_anim[ "generic" ][ "london_gas_death_13" ]			= %london_gas_death_13;	// Face down twitching
//	level.scr_anim[ "generic" ][ "london_gas_death_14" ]			= %london_gas_death_14;	// On side twitching

	// Newer gas deaths
	level.scr_anim[ "generic" ][ "london_gas_hero_death_1" ]		= %london_gas_hero_death_1;	// Standing, stumbles, to back
	level.scr_anim[ "generic" ][ "london_gas_hero_death_2" ]		= %london_gas_hero_death_2;	// Standing, to reach forward, knees, to side
	level.scr_anim[ "generic" ][ "london_gas_hero_death_3" ]		= %london_gas_hero_death_3;	// Standing, stumbles in a u-turn pattern
	level.scr_anim[ "generic" ][ "london_gas_hero_death_4" ]		= %london_gas_hero_death_4;	// Standing, bending over coughing, fall forward

//	level.scr_anim[ "generic" ][ "contingency_teargas_1" ]	= %contingency_teargas_1;
//	level.scr_anim[ "generic" ][ "contingency_teargas_2" ]	= %contingency_teargas_2;
//	level.scr_anim[ "generic" ][ "contingency_teargas_3" ]	= %contingency_teargas_3;
			
//	level.scr_anim[ "generic" ][ "sprint" ]				= %sprint1_loop;
//	level.scr_anim[ "generic" ][ "civ_crawl" ]			= %civilian_crawl_1;
//	level.scr_anim[ "generic" ][ "civ_blind" ]			= %hunted_dazed_walk_B_blind;
	
//	level.scr_anim[ "generic" ][ "civilian_crawl_1" ]			= %civilian_crawl_1;
//	level.scr_anim[ "generic" ][ "civilian_crawl_1_death_A" ]	= %civilian_crawl_1_death_A;
//	level.scr_anim[ "generic" ][ "civilian_crawl_1_death_B" ]	= %civilian_crawl_1_death_B;
	
	// Check out the truck
	level.scr_anim[ "generic" ][ "inspect_truck" ]			= %london_bomber_friendly_inspect_01;
	addNotetrack_customFunction( "generic", "truckdoor_start", ::ending_truck_door, "inspect_truck" );

	// Truck Explosion
	level.scr_anim[ "generic" ][ "death_explosion1" ]		= %death_explosion_back13;
	level.scr_anim[ "generic" ][ "death_explosion2" ]		= %death_shotgun_back_v1;

	level.scr_anim[ "generic" ][ "explosion_reaction" ]		= %london_friendly_blowback;

	// Post Explosion
//	level.scr_anim[ "generic" ][ "wounded_carry_closet_idle_wounded" ][ 0 ]			= %wounded_carry_closet_idle_wounded;
	level.scr_anim[ "generic" ][ "hunted_woundedhostage_idle_start" ][ 0 ]			= %hunted_woundedhostage_idle_start;
	level.scr_anim[ "generic" ][ "hunted_woundedhostage_idle_end" ][ 0 ]			= %hunted_woundedhostage_idle_end;
//	level.scr_anim[ "generic" ][ "ai_attacked_german_shepherd_02_getup_a" ]			= %ai_attacked_german_shepherd_02_getup_a;
//	level.scr_anim[ "generic" ][ "DC_Burning_bunker_stumble" ]						= %DC_Burning_bunker_stumble;
//	level.scr_anim[ "generic" ][ "DC_Burning_bunker_stumble_idle" ][ 0 ]			= %DC_Burning_bunker_sit_idle;

	// "WHAT THE HELL HAPPENED?!?!"
	level.scr_sound[ "generic" ][ "london_b21_whathappened" ] = "london_b21_whathappened";
}

takedown_anims()
{
	// Westiminster Exit Area -----------------------------
	level.scr_anim[ "takedown_enemy1" ][ "takedown" ]		= %london_enemy_capture_enemy_01;
	addNotetrack_customFunction( "takedown_enemy1", "bodyfall large", ::set_my_death_anim, "takedown" );
	addNotetrack_detach_gun( "takedown_enemy1", "detach gun", "takedown", true );
	level.scr_anim[ "takedown_enemy1" ][ "idle" ][ 0 ]		= %london_enemy_capture_enemy_idle_01;
	level.scr_anim[ "takedown_friendly1" ][ "takedown" ]	= %london_enemy_capture_friendly_01;
	level.scr_anim[ "takedown_friendly1" ][ "idle" ][ 0 ]	= %london_enemy_capture_friendly_idle_01;
	level.scr_anim[ "takedown_enemy1" ][ "death" ]		= %london_enemy_capture_enemy_death_01;
	level.scr_anim[ "takedown_friendly1" ][ "takedown_ended_on_ground" ]	= %london_enemy_capture_friendly_death_01;

	level.scr_anim[ "takedown_enemy3" ][ "takedown" ]		= %london_enemy_capture_enemy_03;
	addNotetrack_customFunction( "takedown_enemy3", "bodyfall large", ::set_my_death_anim, "takedown" );
	addNotetrack_detach_gun( "takedown_enemy3", "detach gun", "takedown", true );

	level.scr_anim[ "takedown_enemy3" ][ "idle" ][ 0 ]		= %london_enemy_capture_enemy_idle_01;
	level.scr_anim[ "takedown_friendly3" ][ "takedown" ]	= %london_enemy_capture_friendly_03;
	level.scr_anim[ "takedown_friendly3" ][ "idle" ][ 0 ]	= %london_enemy_capture_friendly_idle_01;
	level.scr_anim[ "takedown_enemy3" ][ "death" ]		= %london_enemy_capture_enemy_death_01;
	level.scr_anim[ "takedown_friendly3" ][ "takedown_ended_on_ground" ]	= %london_enemy_capture_friendly_death_01;

	level.scr_anim[ "takedown_enemy4" ][ "takedown" ]		= %london_enemy_capture_enemy_04;
	addNotetrack_customFunction( "takedown_enemy4", "bodyfall large", ::set_my_death_anim, "takedown" );
	addNotetrack_detach_gun( "takedown_enemy4", "detach gun", "takedown", true );

	level.scr_anim[ "takedown_enemy4" ][ "idle" ][ 0 ]						= %london_enemy_capture_enemy_idle_04;
	level.scr_anim[ "takedown_friendly4" ][ "takedown" ]					= %london_enemy_capture_friendly_04;
	level.scr_anim[ "takedown_friendly4" ][ "idle" ][ 0 ]					= %london_enemy_capture_friendly_idle_04;
	level.scr_anim[ "takedown_enemy4" ][ "death" ]							= %london_enemy_capture_enemy_death_04;
	level.scr_anim[ "takedown_friendly4" ][ "takedown_ended_on_ground" ]	= %london_enemy_capture_friendly_death_01;
	level.scr_anim[ "takedown_friendly4" ][ "crouch_to_stand" ]				= %CornerCrL_alert_2_stand;
	
	level.scr_anim[ "takedown_friendly1" ][ "all_dead_idle" ][0] 	= %stand_alertb_idle1;
	level.scr_anim[ "takedown_friendly2" ][ "all_dead_idle" ][0] 	= %stand_alertb_idle1;
	level.scr_anim[ "takedown_friendly3" ][ "all_dead_idle" ][0] 	= %stand_alertb_idle1;
	level.scr_anim[ "takedown_friendly4" ][ "all_dead_idle" ][0] 	= %stand_alertb_idle1;
	level.scr_anim[ "generic" ][ "all_dead_idle" ][0] 				= %stand_alertb_idle1;
}

set_my_death_anim( guy )
{
    guy.takedown_node.on_the_ground = true;
    guy.deathanim = guy getanim( "death" );
}

sas_ending()
{	
	level.scr_anim[ "sas" ][ "sas_wave" ]					= %DCemp_door_sequence_foley_wave;
	
	//SAS Group Leader 2: You lads take care of the truck, we'll secure the station.
	level.scr_sound[ "sas" ][ "london_sas2_ladstaketruck" ]	= "london_sas2_ladstaketruck";
}

police()
{
	level.scr_anim[ "generic" ][ "front_exit_anim" ]	= %london_police_car_exit_2_jog_f;
	level.scr_anim[ "generic" ][ "jog" ]				= %london_police_jog;
}

russian_westminster()
{	
	level.scr_anim[ "russian_soldier" ][ "check_body_surprise" ]		= %exposed_idle_reactB;
	
	//Russian 1: Hostiles are after us!
	level.scr_sound[ "russian_soldier" ][ "london_ru1_gettotrucks" ] 	= "london_ru1_gettotrucks";
	//Russian 2: Don't let them get to the trucks!
	level.scr_sound[ "russian_soldier" ][ "london_ru2_gettotrucks" ] 	= "london_ru2_gettotrucks";
}

vending_dudes()
{
	level.scr_anim[ "vending_dude_1" ][ "vending_scene" ]	= %london_vending_blocker_guy1;
	level.scr_anim[ "vending_dude_2" ][ "vending_scene" ]	= %london_vending_blocker_guy2;
}

radio()
{
	// Westminster Station --------------------------------
	// "Copy, Bravo Six.  Teams are en route.  ETA - ten minutes."
	level.scr_radio[ "london_com_deployteams" ] 		= "london_com_deployteams";
	// "Local police are arriving on scene.  Bravo Two will be on station in five minutes."
	level.scr_radio[ "london_com_stillenroute" ]		= "london_com_stillenroute";

	// "Local police are arriving on scene.  Bravo Two will be on station in five minutes."
	level.scr_radio[ "london_com_stillenroute" ] = "london_com_stillenroute";

	// "They're arriving on scene now, Bravo Six."
	level.scr_radio[ "london_com_onscene" ] = "london_com_onscene";


	// Post Explosion -------------------------------------
	// New Ending Dialogue
	// "All teams, be advised.  The truck is headed your way and coming in hot."
	level.scr_radio[ "london_hp2_truckcoming" ] 		= "london_hp2_truckcoming";
}

new_generic_anims()
{
	// Ending Section -------------------------------------
	level.scr_anim[ "generic" ][ "police_wave" ][ 0 ] 	= %london_police_wave_1;
	level.scr_anim[ "generic" ][ "police_wave" ][ 1 ] 	= %london_police_wave_2;

//	level.scr_anim[ "generic" ][ "civilian_directions_1_A_once" ][ 0 ]	= %civilian_directions_1_A_once;
//	level.scr_anim[ "generic" ][ "civilian_directions_2_A_once" ][ 0 ]	= %civilian_directions_2_A_once;
//	level.scr_anim[ "generic" ][ "civilian_directions_1_B_once" ][ 0 ]	= %civilian_directions_1_B_once;
//	level.scr_anim[ "generic" ][ "civilian_texting_standing" ][ 0 ]		= %civilian_texting_standing;
	level.scr_anim[ "generic" ][ "civilian_stand_idle" ][ 0 ]			= %civilian_stand_idle;
	level.scr_anim[ "generic" ][ "civilian_smoking_A" ][ 0 ]			= %civilian_smoking_A;

	level.scr_anim[ "generic" ][ "setup_blockade" ]						= %london_sandman_sas_talk_friendly;

	// "Secure the area!"
	level.scr_sound[ "generic" ][ "setup_blockade1" ] 					= "london_b21_securethearea";
	// "The truck will be here any second! We need to get in front of this!  Lock the road down, Seargeant!"
	level.scr_sound[ "generic" ][ "setup_blockade2" ] 					= "london_b21_lockdown";

	// "There's the truck!!  Weapons free!!"
	level.scr_sound[ "generic" ][ "london_b21_weaponsfree" ] 			= "london_b21_weaponsfree";

	// "Clear!!"
	level.scr_sound[ "generic" ][ "london_b21_clear" ] 					= "london_b21_clear";

	// "Check it!"
	level.scr_sound[ "generic" ][ "london_b21_checkit" ] 				= "london_b21_checkit";

	// Post Bomb

	// "Easy, easy.  You're all right."
	level.scr_sound[ "generic" ][ "london_med1_youreallright" ] 		= "london_med1_youreallright";

	// "Baseplate, baseplate - request medivac at Westminster Station.  Chemical attack - need atropine and gas masks for wounded, over."
	level.scr_sound[ "sas medic" ][ "london_med1_medivac" ] 			= "london_med1_medivac";
}

ending_drone_anims()
{
//	level.scr_anim[ "drone" ][ "standing" ][ 0 ]		= %civilian_directions_1_A_once;
//	level.scr_anim[ "drone" ][ "standing" ][ 1 ]		= %civilian_directions_2_A_once;
//	level.scr_anim[ "drone" ][ "standing" ][ 2 ]		= %civilian_directions_1_B_once;
//	level.scr_anim[ "drone" ][ "standing" ][ 3 ]		= %civilian_texting_standing;
//	level.scr_anim[ "drone" ][ "standing model" ][ 3 ]	= "pda";
//	level.scr_model[ "pda" ]							= "electronics_pda";
//	level.scr_anim[ "drone" ][ "standing" ][ 4 ]		= %civilian_stand_idle;
//	level.scr_anim[ "drone" ][ "standing" ][ 5 ]		= %civilian_smoking_A;
//	level.scr_anim[ "drone" ][ "standing model" ][ 5 ]	= "cigarrette";
//	level.scr_model[ "cigarrette" ]						= "prop_cigarette";

	level.scr_anim[ "drone" ][ "standing" ][ 0 ] = %london_civ_idle_lookover;
	level.scr_anim[ "drone" ][ "standingweight" ][ 0 ] = 1;
	level.scr_anim[ "drone" ][ "standing" ][ 1 ] = %london_civ_idle_checkwatch;
	level.scr_anim[ "drone" ][ "standingweight" ][ 1 ] = 1;
	level.scr_anim[ "drone" ][ "standing" ][ 2 ] = %london_civ_idle_lookbehind;
	level.scr_anim[ "drone" ][ "standingweight" ][ 2 ] = 1;
	level.scr_anim[ "drone" ][ "standing" ][ 3 ] = %london_civ_idle_sneeze;
	level.scr_anim[ "drone" ][ "standingweight" ][ 3 ] = 1;
	level.scr_anim[ "drone" ][ "standing" ][ 4 ] = %london_civ_idle_wave;
	level.scr_anim[ "drone" ][ "standingweight" ][ 4 ] = 0.2;
	level.scr_anim[ "drone" ][ "standing" ][ 5 ] = %london_civ_idle_foldarms_scratchass;
	level.scr_anim[ "drone" ][ "standingweight" ][ 5 ] = 1;
	level.scr_anim[ "drone" ][ "standing" ][ 6 ] = %london_civ_idle_foldarms2;
	level.scr_anim[ "drone" ][ "standingweight" ][ 6 ] = 1;
	level.scr_anim[ "drone" ][ "standing" ][ 7 ] = %london_civ_idle_scratchnose;
	level.scr_anim[ "drone" ][ "standingweight" ][ 7 ] = 1;

	level.scr_anim[ "drone" ][ "police_wave" ][ 0 ] 	= %london_police_wave_1;
	level.scr_anim[ "drone" ][ "police_wave" ][ 1 ] 	= %london_police_wave_2;

	level.scr_anim[ "drone" ][ "hurried_walk" ][ 0 ]	= %civilian_walk_hurried_1_relative;
	level.scr_anim[ "drone" ][ "hurried_walk" ][ 1 ]	= %civilian_walk_hurried_2_relative;

	level.scr_anim[ "drone" ][ "hunched_run" ][ 0 ]		= %civilian_run_hunched_A_relative;
	level.scr_anim[ "drone" ][ "hunched_run" ][ 1 ]		= %civilian_run_hunched_C_relative;

	level.scr_anim[ "generic" ][ "hunched_run" ][ 0 ]	= %civilian_run_hunched_A_relative;
	level.scr_anim[ "generic" ][ "hunched_run" ][ 1 ]	= %civilian_run_hunched_C_relative;
}

sas_leader()
{
	// Westminster Station --------------------------------
	// "Where do you think you're goin?"
	level.scr_sound[ "sas_leader" ][ "london_ldr_bastard" ] 			= "london_ldr_bastard";
	// "You're not going anywhere."
	level.scr_sound[ "sas_leader" ][ "london_ldr_notgoinganywhere" ] 	= "london_ldr_notgoinganywhere";
	// "And that's for my mates."
	level.scr_sound[ "sas_leader" ][ "london_ldr_thatsformymates" ] 	= "london_ldr_thatsformymates";

	// "Baseplate, we got contact at Westminster Station!"
	level.scr_sound[ "sas_leader" ][ "london_ldr_usingthetube" ] 	= "london_ldr_usingthetube";
	// "Tell 'em to double-time it now!"
	level.scr_sound[ "sas_leader" ][ "london_ldr_doubletime" ] 		= "london_ldr_doubletime";
	// "C'mon, mate!  Let's give these bastards a proper British welcome!"
	level.scr_sound[ "sas_leader" ][ "london_ldr_britishwelcome" ] 	= "london_ldr_britishwelcome";

	// "Check those corners!"
	level.scr_sound[ "sas_leader" ][ "london_ldr_checkcorners2" ] = "london_ldr_checkcorners2";

	// "Watch for civilians!  "
	level.scr_sound[ "sas_leader" ][ "london_ldr_watchforcivvies" ] = "london_ldr_watchforcivvies";

	// "Area clear!"
	level.scr_sound[ "sas_leader" ][ "london_ldr_areaclear" ] = "london_ldr_areaclear";

	// "Baseplate!  Where's that backup?!?!"
	level.scr_sound[ "sas_leader" ][ "london_ldr_wheresbackup" ] = "london_ldr_wheresbackup";
	// "BOLLOCKS!  Nothing takes FIVE MINUTES!"
	level.scr_sound[ "sas_leader" ][ "london_ldr_stoplarkin" ] = "london_ldr_stoplarkin";

	// "Keep pushing!  They're falling back!"
	level.scr_sound[ "sas_leader" ][ "london_ldr_keeppushing" ] = "london_ldr_keeppushing";

	// "Up the stairs!"
	level.scr_sound[ "sas_leader" ][ "london_ldr_upthestairs" ] = "london_ldr_upthestairs";

	// "Grenade!!"
	level.scr_sound[ "sas_leader" ][ "london_ldr_grenade2" ] = "london_ldr_grenade2";
	// "Cheeky bastards!!"
	level.scr_sound[ "sas_leader" ][ "london_ldr_cheekybastards" ] = "london_ldr_cheekybastards";

	// "Baseplate!  Where's that backup?!?!"
	level.scr_sound[ "sas_leader" ][ "london_ldr_wheresbackup" ] = "london_ldr_wheresbackup";

	// "Hold your fire!  Hold your fire!"
	level.scr_sound[ "sas_leader" ][ "london_ldr_thefuzz" ] = "london_ldr_thefuzz";
	// "Nice timing, mates!  You're with Bravo Three?"
	level.scr_sound[ "sas_leader" ][ "london_ldr_nicetiming" ] = "london_ldr_nicetiming";
	// "Let's go, Burns!"
	level.scr_sound[ "sas_leader" ][ "london_ldr_letsgoburns" ] = "london_ldr_letsgoburns";
	// "Baseplate.  Westminster is secure.  We've linked up with Bravo Three.  What's the status on the lorries?"
	level.scr_sound[ "sas_leader" ][ "london_ldr_lorries" ] = "london_ldr_lorries";
	// "Baseplate, come in...Baseplate - WHERE ARE THE TRUCKS?"
	level.scr_sound[ "sas_leader" ][ "london_ldr_wherearetrucks" ] = "london_ldr_wherearetrucks";

	level.scr_anim[ "sas_leader" ][ "alley_comm_check" ] 				= %london_sandman_intro;
	level.scr_anim[ "sas_leader" ][ "alley_comm_idle" ][ 0 ]			= %london_sandman_talk_idle;

	level.scr_anim[ "sas_leader" ][ "westminster_stop" ] 	= %CQB_stop_2_signal;
	level.scr_anim[ "sas_leader" ][ "littlebird_idle" ][0] 	= %little_bird_casual_idle_guy3;

	// Out of Station -------------------------------------
	// Meet up with guy from chopper
	level.scr_anim[ "sas_leader" ][ "setup_blockade" ]			= %london_sandman_sas_talk_sandman;

	// "I want everyone at the blockade!  Stack up!!"
	level.scr_sound[ "sas_leader" ][ "london_ldr_atblockade" ] 	= "london_ldr_atblockade";

	// Nag lines to get to the blockade
	// "Burns - on me!"
	level.scr_sound[ "sas_leader" ][ "london_ldr_burnsonme" ] 		= "london_ldr_burnsonme";
	// "Stack up, Burns!  "
	level.scr_sound[ "sas_leader" ][ "london_ldr_stackupburns" ] 	= "london_ldr_stackupburns";
	// "Burns!  Get your arse over here, NOW!"
	level.scr_sound[ "sas_leader" ][ "london_ldr_burnsherenow" ] 	= "london_ldr_burnsherenow";
	// "Aim for the bloody driver!!"
	level.scr_sound[ "sas_leader" ][ "london_ldr_aimfordriver" ] 	= "london_ldr_aimfordriver";
	// "Hold your fire!! Hold your fire!!"
	level.scr_sound[ "sas_leader" ][ "london_ldr_holdyourfire" ] 	= "london_ldr_holdyourfire";
	// "All clear??"
	level.scr_sound[ "sas_leader" ][ "london_ldr_allclear" ] 		= "london_ldr_allclear";
	// "Watch for movement!"
	level.scr_sound[ "sas_leader" ][ "london_ldr_watchmovement" ] 	= "london_ldr_watchmovement";

	level.scr_anim[ "sas_leader" ][ "explosion_reaction" ] 			= %london_sandman_blowback;

	// Post Explosion -------------------------------------
	// "Baseplate, this is Bravo Six!! We need a medi…"
	level.scr_sound[ "sas_leader" ][ "london_ldr_needamedi" ] 		= "london_ldr_needamedi";
	// "*cough* Frost!  You still with us, mate?!"
	level.scr_sound[ "sas_leader" ][ "london_ldr_stillwithus" ] 	= "london_ldr_stillwithus";

	// Gas ------------------------------------------------
	level.scr_anim[ "sas_leader" ][ "london_gas_hero_death_1" ]		= %london_gas_hero_death_1;	// Standing, stumbles, to back
}

friendly_explosion_reaction( guy )
{
	guys = [ level.sas_leader, level.bravo_two ];
	array_thread( guys, ::gun_remove );

	level.sas_leader.noreload = true;

	node = SpawnStruct();
	node.origin = level.player_rig.anim_origin;
	node.angles = level.player_rig.anim_angles;

	node anim_single( guys, "explosion_reaction" );	
}

civilian()
{
	level.scr_anim[ "generic" ][ "walk" ]		= %civilian_walk_cool;
	level.scr_anim[ "generic" ][ "runaway1" ]	= %civilian_run_upright;
	level.scr_anim[ "generic" ][ "runaway2" ]	= %civilian_run_hunched_A;
}

#using_animtree( "player" );
player_anims()
{
	level.scr_animtree[ "player_rig" ] 					 	= #animtree;
	level.scr_model[ "player_rig" ] 					 	= "viewhands_player_sas";
	level.scr_anim[ "player_rig" ][ "player_explosion" ] 	= %london_player_blowback;
}

#using_animtree( "vehicles" );
delivery_truck()
{
	level.scr_animtree[ "delivery_truck" ] 					= #animtree;
	level.scr_model[ "delivery_truck" ] 					= "vehicle_uk_delivery_truck";
	level.scr_anim[ "delivery_truck" ][ "truck_crash" ] 	= %london_bomber_truck_crash;
//	level.scr_anim[ "delivery_truck" ][ "doors_open" ] 		= %london_bomber_truck_door_open;

	addNotetrack_sound( "delivery_truck", "truck_crash1", "truck_crash", "scn_london_truck_crash_tumble" );
}

ending_truck_door( guy )
{
}

#using_animtree( "script_model" );
vending_machine()
{
	level.scr_animtree[ "vending_machine" ] 				= #animtree;
	level.scr_anim[ "vending_machine" ][ "vending_scene" ] 	= %london_vending_blocker_vendingmachine;
}

gas_model()
{
	level.scr_animtree[ "gas_model" ] 				= #animtree;
	level.scr_anim[ "gas_model" ][ "start" ] 		= %london_gas_attack;
	level.scr_anim[ "gas_model" ][ "loop" ][ 0 ]	= %london_gas_attack_loop;
}
