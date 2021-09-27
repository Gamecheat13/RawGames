#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;

main()
{
	innocent_scene();
	death_anims();
	pigeons();
	civilian_anims();

	// Westminster Section
	anim_playerview();
	anim_vehicles();
	west_anims();
	sas_leader();
	radio();
}

#using_animtree( "generic_human" );
innocent_scene()
{

	level.scr_anim[ "wife" ][ "idle" ][ 0 ] = %civilian_stand_idle;
//	level.scr_anim[ "wife" ][ "temp" ] = %london_wife_ending;

	level.scr_anim[ "wife" ][ "anim_1" ] 		= %london_ending_A_wife;
	level.scr_anim[ "wife" ][ "anim_1_idle" ]	= %london_ending_A_wife_idle;
	level.scr_anim[ "wife" ][ "anim_1_nag" ]	= %london_ending_A_wife_nag;

	level.scr_anim[ "daughter" ][ "anim_1" ] 	= %london_ending_A_girl;
	addNotetrack_customFunction( "daughter", "ps_london_wif_bigben", maps\innocent::enemy_truck, "anim_1" ); 
	level.scr_anim[ "daughter" ][ "anim_1_idle" ]	= %london_ending_A_girl_idle;
	level.scr_anim[ "daughter" ][ "anim_1_nag" ]	= %london_ending_A_girl_nag;

	// Nags
	// "Honey, you're missing it!"
	level.scr_sound[ "wife" ][ "london_wif_honey" ] = "london_wif_honey";
	// "C'mon! Get closer."
	level.scr_sound[ "wife" ][ "london_wif_getcloser" ] = "london_wif_getcloser";


	level.scr_anim[ "drone_man" ][ "couple_walk" ] = %innocent_civ_couple_walk_man;
	level.scr_anim[ "drone_girl" ][ "couple_walk" ] = %innocent_civ_couple_walk_woman;


	level.scr_anim[ "wife" ][ "anim_2" ] 		= %london_ending_B_wife;
	level.scr_anim[ "wife" ][ "anim_2_idle" ]	= %london_ending_B_wife_idle;
	level.scr_anim[ "wife" ][ "anim_2_nag" ]	= %london_ending_B_wife_nag;

	// addNotetrack_customFunction( "wife", "ps_london_dtr_lookoverhere", maps\london_west_code::enemy_truck, "anim_2" );
	addNotetrack_customFunction( "wife", "ps_london_wif_fromyou", maps\innocent::truck_explosion_flag, "anim_2" );
	level.scr_anim[ "daughter" ][ "anim_2" ] 		= %london_ending_B_girl;
	level.scr_anim[ "daughter" ][ "anim_2_idle" ]	= %london_ending_B_girl_idle;
//	level.scr_anim[ "daughter" ][ "anim_2_nag" ]	= %london_ending_B_girl_nag;

	// "Over here, honey!  Look over here!"
	level.scr_sound[ "wife" ][ "london_wif_overhere" ] 			= "london_wif_overhere";
	// "Are you recording?"
	level.scr_sound[ "wife" ][ "london_wif_recording" ] 		= "london_wif_recording";
	// "Ok.  So.  Here we are, day three, in downtown London.  And it..is…<sigh>beautiful."
	level.scr_sound[ "wife" ][ "london_wif_hereweare" ] 		= "london_wif_hereweare";
	// "When can we get ice cream? I want ice cream."
	level.scr_sound[ "daughter" ][ "london_dtr_whencan" ] 		= "london_dtr_whencan";
	// "<laughs>  We just had breakfast, I think it's too early for ice cream."
	level.scr_sound[ "wife" ][ "london_wif_icecream" ] 			= "london_wif_icecream";
	// "<gasp> Oh my goodness sweetie look at that!  Look at Big Ben!  It's incredible!  Come take our picture!  C'mon!"
	level.scr_sound[ "wife" ][ "london_wif_bigben" ] 			= "london_wif_bigben";
	// "Daddy!  Look over here!"
	level.scr_sound[ "daughter" ][ "london_dtr_lookoverhere" ] 	= "london_dtr_lookoverhere";
	// "Look at me, daddy!"
	level.scr_sound[ "daughter" ][ "london_dtr_lookatme" ] 		= "london_dtr_lookatme";
	// "What's daddy doing?"
	level.scr_sound[ "daughter" ][ "london_dtr_whatsdaddy" ] 	= "london_dtr_whatsdaddy";
	// "C'mere!  I'm gonna get you!"
	level.scr_sound[ "wife" ][ "london_wif_cmere" ] 			= "london_wif_cmere";
	// "<laughing>"
	level.scr_sound[ "daughter" ][ "london_dtr_laugh" ] 		= "london_dtr_laugh";
	// "I can't believe we finally did this…"
	level.scr_sound[ "wife" ][ "london_wif_cantbelieve" ] 		= "london_wif_cantbelieve";
	// "Birds!  Look mommy!  Birds!  "
	level.scr_sound[ "daughter" ][ "london_dtr_birds" ] 		= "london_dtr_birds";
	// "Sara, don't go too far…"
	level.scr_sound[ "wife" ][ "london_wif_dontgofar" ] 		= "london_wif_dontgofar";
	// "<giggle>"
	level.scr_sound[ "daughter" ][ "london_dtr_laugh2" ] 		= "london_dtr_laugh2";
	// "…that's you're daughter."
	level.scr_sound[ "wife" ][ "london_wif_thatsyour" ] 		= "london_wif_thatsyour";
	// "Y'know she gets that from you."
	level.scr_sound[ "wife" ][ "london_wif_fromyou" ] 			= "london_wif_fromyou";


	level.scr_anim[ "generic" ][ "unarmed_run" ]				= %unarmed_scared_run_delta;
}

civilian_anims()
{
	level.scr_anim[ "civilian" ][ "idle_combat" ][ 0 ] 	= %civilian_stand_idle;

	level.scr_anim[ "civilian" ][ "walk" ]				= %civilian_walk_cool;
	level.scr_anim[ "civilian" ][ "run" ]				= %london_police_jog;
}

west_anims()
{
}

radio()
{
	// "Bravo Six, come in….Bravo Six, do you copy?"
	level.scr_radio[ "london_com_doyoucopy" ] 	= "london_com_doyoucopy";
	// "Bravo Six, what's your status?"
	level.scr_radio[ "london_com_status" ] 		= "london_com_status";
	// "Be advised, Bravo Six, the trucks are headed in your direction.  Get topside and RV with Bravo Two."
	level.scr_radio[ "london_com_rendevous" ] 	= "london_com_rendevous";
}

sas_leader()
{
	// After Train Crash ----------------------------------
    level.scr_anim[ "sas_leader" ][ "stumble" ] 					= %london_truckcrash_crawl;

	// "*cough*...Burns…burns…you alright??"
	level.scr_sound[ "sas_leader" ][ "london_ldr_burnsalright" ] 	= "london_ldr_burnsalright";
	// "Burns…*cough*…Burns… Burns, you alright??"
	level.scr_sound[ "sas_leader" ][ "london_ldr_burnsalright" ] 	= "london_ldr_burnsalright";
	// "The train's done in under Westminster.  Those bastards were using it for transport."
	level.scr_sound[ "sas_leader" ][ "london_ldr_scrapmetal2" ] 	= "london_ldr_scrapmetal2";
	// "<sigh> Copy.  Come on, Burns.  It looks like it's just us now."
	level.scr_sound[ "sas_leader" ][ "london_ldr_nothingwecando" ] 	= "london_ldr_nothingwecando";
}

death_anims()
{
	level.scr_anim[ "generic" ][ "death_explosion_stand_B_v2" ] 	= %death_explosion_stand_B_v2;	
	level.scr_anim[ "generic" ][ "london_gas_hero_death_2" ]		= %london_gas_hero_death_2;	// Standing, to reach forward, knees, to side
	level.scr_anim[ "generic" ][ "camera_guy_death" ]				= %london_ending_dad;
}

#using_animtree( "chicken" );
pigeons()
{
	level.scr_animtree[ "pigeon" ] 					= #animtree;
	level.scr_anim[ "pigeon" ][ "idle" ][ 0 ] = %pigeon_idle;
	level.scr_anim[ "pigeon" ][ "idleweight" ][ 0 ] = 1;
	level.scr_anim[ "pigeon" ][ "idle" ][ 1 ] = %pigeon_idle_twitch_1;
	level.scr_anim[ "pigeon" ][ "idleweight" ][ 1 ] = 0.3;

	level.scr_anim[ "pigeon" ][ "flying" ] = %pigeon_flying_cycle;
}

#using_animtree( "player" );
anim_playerview()
{
	level.scr_animtree[ "player_rig_tunnel_crash_teleport" ] = #animtree;
	level.scr_model[ "player_rig_tunnel_crash_teleport" ] 					= "viewhands_player_sas";
	level.scr_anim[ "player_rig_tunnel_crash_teleport" ][ "train_crash" ] 	= %london_player_bail;
    addNotetrack_flag( "player_rig_tunnel_crash_teleport", "dirt_kickup_hands_light_start", "smoke_fill", "train_crash" );
    
	addNotetrack_customFunction( "player_rig_tunnel_crash_teleport", "transition", maps\london_west::sandman_stumbles, "train_crash" );
	addNotetrack_customFunction( "player_rig_tunnel_crash_teleport", "dirt_kickup_head_start", maps\westminster_code::slide_innocent, "train_crash" );
    addNotetrack_flag( "player_rig_tunnel_crash_teleport", "dirt_kickup_hands_stop", "train_crash_tumble_stops", "train_crash" );
//    addNotetrack_startFXonTag( "player_rig_tunnel_crash_teleport", "dirt_kickup_hands_start", "train_crash", "dirt_kickup_hands", "J_wrist_RI" );
//    addNotetrack_startFXonTag( "player_rig_tunnel_crash_teleport", "dirt_kickup_hands_start", "train_crash", "dirt_kickup_hands", "J_wrist_LE" );
//    addNotetrack_stopFXonTag( "player_rig_tunnel_crash_teleport", "dirt_kickup_hands_stop", "train_crash", "dirt_kickup_hands", "J_wrist_RI" );
//    addNotetrack_stopFXonTag( "player_rig_tunnel_crash_teleport", "dirt_kickup_hands_stop", "train_crash", "dirt_kickup_hands", "J_wrist_LE" );
//    addNotetrack_startFXonTag( "player_rig_tunnel_crash_teleport", "dirt_kickup_hands_light_start", "train_crash", "dirt_kickup_hands_light", "J_wrist_RI" );
//    addNotetrack_startFXonTag( "player_rig_tunnel_crash_teleport", "dirt_kickup_hands_light_start", "train_crash", "dirt_kickup_hands_light", "J_wrist_LE" );
//    addNotetrack_stopFXonTag( "player_rig_tunnel_crash_teleport", "dirt_kickup_hands_light_stop", "train_crash", "dirt_kickup_hands_light", "J_wrist_RI" );
//    addNotetrack_stopFXonTag( "player_rig_tunnel_crash_teleport", "dirt_kickup_hands_light_stop", "train_crash", "dirt_kickup_hands_light", "J_wrist_LE" );
//    addNotetrack_startFXonTag( "player_rig_tunnel_crash_teleport", "dirt_kickup_head_start", "train_crash" ,"dirt_kickup_head", "TAG_CAMERA" );
//    addNotetrack_stopFXonTag( "player_rig_tunnel_crash_teleport", "dirt_kickup_head_stop", "train_crash", "dirt_kickup_head", "TAG_CAMERA" );
}

#using_animtree( "vehicles" );
anim_vehicles()
{
	level.scr_anim[ "player_car" ][ "train_crash" ] 			= %london_player_truck;
//    addNotetrack_customFunCtion( "player_car", "player_bail", maps\westminster_code::player_bail, "train_crash" );
	level.scr_model[ "player_car" ] 							= "vehicle_uk_utility_truck_destructible";
	level.scr_animtree[ "player_car" ] 							= #animtree;

	level.scr_anim[ "player_car_mirrored" ][ "train_crash" ] 	= %london_player_truck;
    addNotetrack_customFunction( "player_car_mirrored", "truck_slowing_1_start", ::truck_slide_spew_start, "train_crash" );
	level.scr_model[ "player_car_mirrored" ] 					= "vehicle_uk_utility_truck_destructible";
	level.scr_animtree[ "player_car_mirrored" ] 				= #animtree;
}

truck_slide_spew_start( guy )
{
    PlayFXOnTag( getfx( "sparks_truck_scrape_line_short_diminishing" ), guy, "TAG_TAIL_LIGHT_LEFT" );
}
