//
// file: ber3_anim.gsc
// description: animation script for berlin3
// scripter: slayback
//

#include common_scripts\utility;
#include maps\_utility;
#include maps\_anim;

#using_animtree ("generic_human");

main()
{
	setup_level_anims();
	setup_player_interactive_anims();
	setup_brick_anims();
	setup_flag_anims();
	setup_rus_flag_anims();
	setup_pillar_anims();
	setup_pak_anims();
	setup_tank_trap_tank();
	
	// animations needed for util/anim scripts
	maps\_mganim::main();
	
	// VO and whatnot
	audio_loader();
	
	// flagbearer vignettes
	//level thread preview_anim_single( "trig_wave_anim_flagbearer_e2death", "flagbearer_death_e2", "death" );
	
	// officer signaling at wave
	//level thread preview_anim_single( "trig_wave_anim_officerSignaling", "officer", "signal" );
}

setup_level_anims()
{	
	// collectable anim
	level.scr_anim["collectible"]["collectible_loop"][0] = %ch_ber3_collectible; 
	
	//stairs anims
	level.scr_anim["chernov"][ "stairs_up" ]							= %ai_staircase_run_up_v1;
	level.scr_anim["chernov"][ "stairs_down" ]						= %ai_staircase_run_down_v1;	
	level.scr_anim["reznov"][ "stairs_up" ]								= %ai_staircase_run_up_v1;
	level.scr_anim["reznov"][ "stairs_down" ]							= %ai_staircase_run_down_v1;
	level.scr_anim["generic"][ "stairs_up" ]							= %ai_staircase_run_up_v1;
	level.scr_anim["generic"][ "stairs_down" ]						= %ai_staircase_run_down_v1;	
	
	// intro anims
	level.scr_anim["reznov"]["intro"] = %ch_berlin3_intro_resnov;
	level.scr_anim["chernov"]["intro"] = %ch_berlin3_intro_chernov;
	level.scr_anim["redshirt1"]["intro"] = %ch_berlin3_intro_redshirt;
	
	addNotetrack_dialogue( "reznov", "Ber3_INT_000A_REZN", "intro", "Ber3_INT_000A_REZN" );
	addNotetrack_dialogue( "reznov", "Ber3_INT_300A_REZN", "intro", "ber3_INT_300A_REZN" );
	addNotetrack_dialogue( "reznov", "Ber3_INT_301A_REZN", "intro", "ber3_INT_301A_REZN" );
	addNotetrack_dialogue( "reznov", "Ber3_INT_302A_REZN", "intro", "ber3_INT_302A_REZN" );
	addNotetrack_dialogue( "reznov", "Ber3_INT_001A_REZN", "intro", "Ber3_INT_001A_REZN" );
	addNotetrack_dialogue( "reznov", "Ber3_INT_003A_REZN", "intro", "Ber3_INT_003A_REZN" );
	addNotetrack_dialogue( "reznov", "Ber3_INT_005A_REZN", "intro", "Ber3_INT_005A_REZN" );
	addNotetrack_dialogue( "reznov", "Ber3_INT_006A_REZN", "intro", "Ber3_INT_006A_REZN" );
	addNotetrack_dialogue( "reznov", "Ber3_INT_008A_REZN", "intro", "Ber3_INT_008A_REZN" );	
	
	// commissar
	level.scr_anim["commissar"]["comm_waving"][0] = %ch_berlin3_commissar_waving2_loop;
	level.scr_anim["commissar"]["comm_talking"] = %ch_berlin3_commissar_waving;
	addNotetrack_dialogue( "commissar", "dialog", "comm_talking", "Ber3_INT_012A_COMM" );	
	addNotetrack_dialogue( "commissar", "dialog", "comm_talking", "Ber3_INT_013A_COMM" );	
	level.scr_anim["commissar"]["comm_whistle"] = %ch_berlin3_commissar_idle;
	level.scr_anim["commissar"]["comm_whistle_idle"][0] = %ch_berlin3_commissar_whistle;
	
	level.scr_anim["redshirt"]["comm_listen_idle"][0] = %casual_stand_idle;
	level.scr_anim["redshirt"]["comm_listen_idle"][1] = %casual_stand_idle_twitch;
	level.scr_anim["redshirt"]["comm_listen_idle"][2] = %casual_stand_idle_twitchB;
	
	level.scr_anim["redshirt"]["comm_listen_idle2"][0] = %casual_stand_v2_idle;
	level.scr_anim["redshirt"]["comm_listen_idle2"][1] = %casual_stand_v2_twitch_shift;
	level.scr_anim["redshirt"]["comm_listen_idle2"][2] = %casual_stand_v2_twitch_talk;
	
	// Pak43 animations
	level.scr_anim["lbrace_pusher"]["e1_push_pak"] = %ch_berlin3_pak43_lbrace_push;
	level.scr_anim["lbrace_pusher"]["e1_settle_pak"] = %ch_berlin3_pak43_lbrace_settle;
	level.scr_anim["lbrace_pusher"]["e1_fire_pak"][0] = %ch_berlin3_pak43_lbrace_fire;
	level.scr_anim["lbrace_pusher"]["e1_fire_pak"][1] = %ch_berlin3_pak43_lbrace_fire;
	
	level.scr_anim["lwheel_pusher"]["e1_push_pak"] = %ch_berlin3_pak43_lwheel_push;
	level.scr_anim["lwheel_pusher"]["e1_settle_pak"] = %ch_berlin3_pak43_lwheel_settle;
	level.scr_anim["lwheel_pusher"]["e1_fire_pak"][0] = %ch_berlin3_pak43_lwheel_fire;
	level.scr_anim["lwheel_pusher"]["e1_fire_pak"][1] = %ch_berlin3_pak43_lwheel_fire;
	
	level.scr_anim["rbrace_pusher"]["e1_push_pak"] = %ch_berlin3_pak43_rbrace_push;
	level.scr_anim["rbrace_pusher"]["e1_settle_pak"] = %ch_berlin3_pak43_rbrace_settle;
	level.scr_anim["rbrace_pusher"]["e1_fire_pak"][0] = %ch_berlin3_pak43_rbrace_fire;
	level.scr_anim["rbrace_pusher"]["e1_fire_pak"][1] = %ch_berlin3_pak43_rbrace_fire;
	
	level.scr_anim["rwheel_pusher"]["e1_push_pak"] = %ch_berlin3_pak43_rwheel_push;
	level.scr_anim["rwheel_pusher"]["e1_settle_pak"] = %ch_berlin3_pak43_rwheel_settle;
	level.scr_anim["rwheel_pusher"]["e1_fire_pak"][0] = %ch_berlin3_pak43_rwheel_fire;
	level.scr_anim["rwheel_pusher"]["e1_fire_pak"][1] = %ch_berlin3_pak43_rwheel_fire;


	
	// flagbearer special anims
	//level.scr_anim["flagbearer"]["covercrouch"] = %ai_flagbearer_covercrouch;
	//level.scr_anim["flagbearer"]["coverstand"] = %ai_flagbearer_coverstand;
	//level.scr_anim["flagbearer"]["pickup"] = %ai_flagbearer_pickup;
	//level.scr_anim["flagbearer"]["standingidle"] = %ai_flagbearer_standingidle;
	
	// flagbearer deaths
	//level.scr_anim["flagbearer_death_e2"]["death"] = %ch_berlin3_e2_bearerdeath;	
	
	// russian officer
	level.scr_anim["officer"]["signal"] = %ch_berlin3_officer_signaling;
	level.scr_anim["officer"]["signal_loop"][0] = %ch_berlin3_officer_signaling;
	
	// Used for molotov toss
	level.scr_anim["russian"]["toss_molotov"] = %ch_seelow1_pickup_molotov_a;		

	// Outro animations
	level.scr_anim["chernov"]["chernov_in"] = %ch_berlin3_outro_chernov_in;
	addNotetrack_customFunction( "chernov", "resnov", maps\ber3_event_steps::reznov_outro_anims, "chernov_in" );
	addNotetrack_dialogue( "chernov", "dialog", "chernov_in", "Ber3_IGD_028A_CHER_A" );
	addNotetrack_dialogue( "chernov", "dialog", "chernov_in", "ru_che_death_large_00_H" );
	addNotetrack_dialogue( "chernov", "dialog", "chernov_in", "ru_che_death_large_00_D" );
	addNotetrack_dialogue( "chernov", "dialog", "chernov_in", "ru_che_breathing_large_00_A" );
	addNotetrack_customFunction( "chernov", "detach", maps\ber3_event_steps::outro_flag_notify_unlink, "chernov_in");
	level.scr_anim["chernov"]["chernov_loop"][0] = %ch_berlin3_outro_chernov_loop;
	//level.scr_anim["chernov"]["chernov_death"] = %ch_berlin3_outro_chernov_die;
	//level.scr_anim["chernov"]["chernov_death_loop"][0] = %ch_berlin3_outro_chernov_die_loop;

	level.scr_anim["reznov"]["chernov_in"] = %ch_berlin3_outro_resnov_in;
	addNotetrack_dialogue( "reznov", "dialog", "chernov_in", "Ber3_IGD_102A_REZN" );
	addNotetrack_dialogue( "reznov", "dialog", "chernov_in", "Ber3_IGD_037A_REZN" );
	addNotetrack_dialogue( "reznov", "dialog", "chernov_in", "Ber3_IGD_038A_REZN" );
	//addNotetrack_attach( "reznov", "attach", "static_berlin_books_diary", "chernov_in" );
	//addNotetrack_detach( "reznov", "detach", "static_berlin_books_diary", "chernov_in" );
	addNotetrack_customFunction( "reznov", "attach", maps\ber3_event_steps::reznov_outro_attach_book, "chernov_in" );
	addNotetrack_customFunction( "reznov", "detach", maps\ber3_event_steps::reznov_outro_detach_book, "chernov_in" );
	
	//addNotetrack_dialogue( "reznov", "dialog", "chernov_in", "Ber3_IGD_038A_REZN" );	// used to be Ber3_IGD_030A_REZN
	level.scr_anim["reznov"]["chernov_loop"] = %ch_berlin3_outro_resnov_loop;
	level.scr_anim["reznov"]["chernov_death"] = %ch_berlin3_outro_resnov_book;
	//addNotetrack_dialogue( "reznov", "dialog", "chernov_death", "Ber3_IGD_038A_REZN" );

	// Chernov animations
	level.scr_anim["chernov"]["fire_death"] = %ai_flame_death_a;
}



audio_loader()
{

	////////////////////////////////////////////////////////////////////////////////////////////////////////
	//	Intro
	////////////////////////////////////////////////////////////////////////////////////////////////////////

	///// REZNOV /////
//	// "You will be okay... Do you hear me?"
//	level.scr_sound["reznov"]["intro_rez_01"] = "Ber3_INT_000A_REZN";
//	// "You will be okay."
//	level.scr_sound["reznov"]["intro_rez_02"] = "Ber3_INT_001A_REZN";
//	// "Relax for a few minutes - Breathe deeply."
//	level.scr_sound["reznov"]["intro_rez_03"] = "Ber3_INT_003A_REZN";
//	// "Which do you think will lead us home?  Writing about this war or fighting it?"
//	level.scr_sound["reznov"]["intro_rez_04"] = "Ber3_INT_005A_REZN";
//	// "No one will ever read this."
//	level.scr_sound["reznov"]["intro_rez_05"] = "Ber3_INT_006A_REZN";
//	// "If you lack the stomach to kill for your country - at least show me that you are willing to die for it."
//	level.scr_sound["reznov"]["intro_rez_06"] = "Ber3_INT_008A_REZN";
	// "We are in the final hours of Berlin's downfall…"
	level.scr_sound["reznov"]["intro_rez_07"] = "Ber3_INT_010A_REZN";
	// "We must all play our part…"
	level.scr_sound["reznov"]["intro_rez_08"] = "Ber3_INT_011A_REZN";
	// "Yes, Commissar."
	level.scr_sound["reznov"]["intro_rez_09"] = "Ber3_INT_014A_REZN";
	// "You heard him, comrades... To the left!"
	level.scr_sound["reznov"]["intro_rez_10"] = "Ber3_INT_015A_REZN";
	// "This way!"
	level.scr_sound["reznov"]["intro_rez_11"] = "Ber3_INT_016A_REZN";
	// "Look Chernov, the Germans hang their cowards from trees."
	level.scr_sound["reznov"]["intro_rez_12"] = "Ber3_IGD_000A_REZN";
	
	///// COMMISSAR /////
	// "Brave comrades - This day - The Fascist empire will yield to the iron fist of the Red Army."
	level.scr_sound["commissar"]["intro_comm_1"] = "Ber3_INT_002A_COMM";	
	// "Cut down those in front of you as though they are but fields of wheat and rye."
	level.scr_sound["commissar"]["intro_comm_2"] = "Ber3_INT_004A_COMM";
	// "We are Russia’s blood. "
	level.scr_sound["commissar"]["intro_comm_3"] = "Ber3_INT_007A_COMM";
	// "Drown this wretched Germany in the blood of its own!!!"
	level.scr_sound["commissar"]["intro_comm_4"] = "Ber3_INT_009A_COMM";
	// "Sergeant…"
	//level.scr_sound["commissar"]["intro_comm_5"] = "Ber3_INT_012A_COMM";
	// "Take the left flank and eradicate whatever scum remains in defense of each building."
	//level.scr_sound["commissar"]["intro_comm_6"] = "Ber3_INT_013A_COMM";
	
	
	
	// Event 1

	// "Make sure you keep hold of that  flag, Chernov."
	level.scr_sound["reznov"]["e1_rez_01"] = "Ber3_IGD_001A_REZN";
	// "Keep fire on that building!"
	level.scr_sound["reznov"]["e1_rez_02"] = "Ber3_IGD_002A_REZN";
	// "Flank the building from both sides!"
	level.scr_sound["reznov"]["e1_rez_03"] = "Ber3_IGD_003A_REZN";
	// "Dimitri - With me!"
	level.scr_sound["reznov"]["e1_rez_04"] = "Ber3_IGD_004A_REZN";
	// "Keep pushing forward!"
	level.scr_sound["reznov"]["e1_rez_05"] = "Ber3_IGD_005A_REZN";
	// "Through the window - GO!"
	level.scr_sound["reznov"]["e1_rez_window"] = "Ber3_IGD_200A_REZN";
	// "Our tanks will have to find another way around."
	level.scr_sound["reznov"]["e1_rez_06"] = "Ber3_IGD_006A_REZN";
	// "We take the direct route!"
	level.scr_sound["reznov"]["e1_rez_07"] = "Ber3_IGD_007A_REZN";
	// "Go!"
	level.scr_sound["reznov"]["e1_rez_08"] = "Ber3_IGD_008A_REZN";
// "Wait for the signal."
	level.scr_sound["reznov"]["e1_rez_wait_signal"] = "Ber3_IGD_100A_REZN";	
	// "It is almost over."
	level.scr_sound["reznov"]["e1_rez_09"] = "Ber3_IGD_009A_REZN";
	// "Today is the day of our glorious vengeance! For ourselves... and for mother Russia!"
	level.scr_sound["reznov"]["e1_rez_10"] = "Ber3_IGD_010A_REZN";
	// "Charge!!!"
	level.scr_sound["reznov"]["e1_rez_11"] = "Ber3_IGD_011A_REZN";
	
	level.scr_sound["basement_guy1"]["wait_dialog"] 				= "print: Alright comrades, wait for the signal before we go";
	level.scr_sound["basement_guy1"]["charge_dialog"] 				= "print: That's the signal, Charge!";


	
	// Event 2
	// "We need to destroy the 88s before our can armor move up!"
	level.scr_sound["reznov"]["e2_rez_01"] = "Ber3_IGD_012A_REZN";
	// "Killing the crews is not enough…"
	level.scr_sound["reznov"]["e2_rez_02"] = "Ber3_IGD_013A_REZN";
	// "The emplacement itself must be obliterated!"
	level.scr_sound["reznov"]["e2_rez_03"] = "Ber3_IGD_014A_REZN";
	// "Plant charges... Find a bazooka…"
	level.scr_sound["reznov"]["e2_rez_04"] = "Ber3_IGD_015A_REZN";
	// "Do whatever it takes to blow the bastards to hell!!!"
	level.scr_sound["reznov"]["e2_rez_05"] = "Ber3_IGD_016A_REZN";
	// "One down - three to go!"
	level.scr_sound["reznov"]["e2_rez_flak3_1"] = "Ber3_IGD_017A_REZN";
	// "Keep going, Dimitri!"
	level.scr_sound["reznov"]["e2_rez_flak3_2"] = "Ber3_IGD_018A_REZN";
	// "Another one destroyed!"
	level.scr_sound["reznov"]["e2_rez_flak2_1"] = "Ber3_IGD_019A_REZN";
	// "Two more remain!"
	level.scr_sound["reznov"]["e2_rez_flak2_2"] = "Ber3_IGD_020A_REZN";
	// "Ha! Dimitri... You are unstoppable!"
	level.scr_sound["reznov"]["e2_rez_flak1_1"] = "Ber3_IGD_021A_REZN";
	// "Get to the last 88!"
	level.scr_sound["reznov"]["e2_rez_flak1_2"] = "Ber3_IGD_022A_REZN";
	// "Their artillery is in ruins!"
	level.scr_sound["reznov"]["e2_rez_flak0_1"] = "Ber3_IGD_023A_REZN";
	// "MOVE IN!!!"
	level.scr_sound["reznov"]["e2_rez_flak0_2"] = "Ber3_IGD_024A_REZN";

	
	
	// Event 3
	// "Push them back!"
	level.scr_sound["reznov"]["stairs_rez_01"] = "Ber3_OrderPushBack_Reznov_00";
	// "Move forward!"
	level.scr_sound["reznov"]["stairs_rez_02"] = "Ber3_OrderForward_Reznov_01";
	// "Forward, men!"
	level.scr_sound["reznov"]["stairs_rez_03"] = "Ber3_OrderForward_Reznov_00";
	// "Come with me!"
	level.scr_sound["reznov"]["stairs_rez_04"] = "Ber3_OrderFollow_Reznov_00";	
				
	// "The bunkers are heavily fortified."
	level.scr_sound["reznov"]["e3_rez_01"] = "Ber3_IGD_025A_REZN";
	// "Move inside."
	level.scr_sound["reznov"]["e3_rez_02"] = "Ber3_IGD_026A_REZN";
	// "Take out those positions!"
	level.scr_sound["reznov"]["e3_rez_03"] = "Ber3_IGD_027A_REZN";
	// "Dimitri! He is suffering."
	level.scr_sound["reznov"]["e3_rez_04"] = "Ber3_IGD_029A_REZN";
	// "You know what you should do…"
	level.scr_sound["reznov"]["e3_rez_05"] = "Ber3_IGD_030A_REZN";
	// "Finish them!"
	level.scr_sound["reznov"]["e3_rez_06"] = "Ber3_IGD_031A_REZN";
	// "Shoot their fuel tanks!"
	level.scr_sound["reznov"]["e3_rez_07"] = "Ber3_IGD_032A_REZN";
	// "URA!"
	level.scr_sound["reznov"]["e3_rez_08"] = "Ber3_IGD_033A_REZN";
	// "URA! URA!"
	level.scr_sound["reznov"]["e3_rez_09"] = "Ber3_IGD_034A_REZN";
	// "Dimitri!"
	level.scr_sound["reznov"]["e3_rez_10"] = "Ber3_IGD_037A_REZN";
	// "Someone should read this…"
	level.scr_sound["reznov"]["e3_rez_11"] = "Ber3_IGD_038A_REZN";
	// "This is what you came here for!"
	level.scr_sound["reznov"]["out_rez_01"] = "RU_rez_threat_infantry_exposed_10";
	// "Kill them all!"
	level.scr_sound["reznov"]["out_rez_02"] = "RU_rez_threat_infantry_exposed_08";
	// "Spare no one!"
	level.scr_sound["reznov"]["out_rez_03"] = "RU_rez_order_action_boost_08";
	// "Pound them into the dust!"
	level.scr_sound["reznov"]["out_rez_04"] = "RU_rez_order_action_boost_02";

		
	// "URA!!!"
	level.scr_sound["chernov"]["e3_chernov_01"] = "Ber3_IGD_028A_CHER";

	// "URA!"
	level.scr_sound["redshirt"]["e3_redshirt_01"] = "Ber3_IGD_035A_RURS";
	// "URA! URA!"
	level.scr_sound["redshirt"]["e3_redshirt_02"] = "Ber3_IGD_036A_RURS";
	
}



preview_anim_single( triggerTN, animname, anime, isAxis )
{
	trig = GetEnt( triggerTN, "targetname" );
	ASSERTEX( IsDefined( trig ), "trigger can't be found." );
	
	animSpot = GetStruct( trig.target, "targetname" );
	ASSERTEX( IsDefined( animSpot ), "anim spot (targetname " + trig.target + ") can't be found." );
	
	trig waittill ("trigger");
	trig Delete();
	
	// set up the guy
	guy = Spawn( "script_model", animSpot.origin );
	guy.angles = animSpot.angles;
	
	if( !IsDefined( isAxis ) )
	{
		isAxis = false;
	}
	
	if( isAxis )
	{
		guy setup_axis_char_model();
	}
	else
	{
		guy setup_ally_char_model();
	}
	
	guy UseAnimTree( #animtree );
	guy.animname = animname;
	guy.targetname = animname + "_guy";
	
	// play the anim
	animSpot anim_single_solo( guy, anime );
	guy waittill( "single anim" );

	wait( 1 );
	guy Delete();
}


// --- UTIL ---

// self = the script_model being set up
setup_ally_char_model()
{
	// TODO randomize?
	//self character\char_rus_r_ppsh::main();
}

setup_axis_char_model()
{
	// TODO randomize?
	//self character\char_ger_pnzgren_mp44::main();
}

#using_animtree( "player" );

setup_player_interactive_anims()
{
	level.scr_animtree["player_hands"] = #animtree;
	level.scr_model["player_hands"] = "viewmodel_rus_guard_player";
	level.scr_anim["player_hands"]["intro"] = %int_berlin3_intro;
}



#using_animtree( "ber3_alley_bricks" );
setup_brick_anims()
{
	level.scr_animtree["e1_wall_bricks"] 				= #animtree; 	
	level.scr_model["e1_wall_bricks"] 				= "anim_alley_brick_chunks"; 	
	level.scr_anim["e1_wall_bricks"]["e1_alley_brick_chunks"] = %o_berlin3_alley_brick_chunks;
}

#using_animtree( "ber3_reich_flag" );
setup_flag_anims()
{
	level.scr_animtree["reich_flag"] 				= #animtree; 	
	level.scr_model["reich_flag"] 				= "anim_berlin_nazi_burnt_flag"; 	
	level.scr_anim["reich_flag"]["flag_wave"] = %o_berlin3_stag_flag;
}

#using_animtree( "ber3_russian_flag" );
setup_rus_flag_anims()
{
	level.scr_animtree["rus_flag"] 				= #animtree; 	
	level.scr_model["rus_flag"] 				= "anim_berlin_rus_flag_rolled"; 	
	level.scr_anim["rus_flag"]["intro"] = %o_berlin3_intro_flag;
}

#using_animtree( "ber3_reich_pillar" );
setup_pillar_anims()
{
	level.scr_animtree["reich_pillar"] 				= #animtree; 	
	level.scr_model["reich_pillar"] 				= "anim_berlin_stag_column"; 	
	level.scr_anim["reich_pillar"]["pillar_collapse"] = %o_berlin3_stag_column;
	
	// Notetracks for the dust effects
	addNotetrack_customFunction( "reich_pillar", "chunk1_impact", maps\ber3_event_steps::e3_pillar_FX1n2, "pillar_collapse" );  // gunshot fx
	addNotetrack_customFunction( "reich_pillar", "chunk234_impact", maps\ber3_event_steps::e3_pillar_FX3, "pillar_collapse" );  // gunshot fx
	addNotetrack_customFunction( "reich_pillar", "chunk5_impact", maps\ber3_event_steps::e3_pillar_FX4, "pillar_collapse" );  // gunshot fx
	addNotetrack_customFunction( "reich_pillar", "chunk6_impact", maps\ber3_event_steps::e3_pillar_FX5, "pillar_collapse" );  // gunshot fx
	
}

#using_animtree( "ber3_pak43" );
setup_pak_anims()
{
	level.scr_animtree["e1_pak43"] 				= #animtree; 	
	
	level.scr_anim["e1_pak43"]["e1_push_pak"] = %o_berlin3_pak43_push;
	level.scr_anim["e1_pak43"]["e1_settle_pak"] = %o_berlin3_pak43_settle;
	addNotetrack_customFunction( "e1_pak43", "pak43_fire", maps\ber3_event_intro::e1_pak_fire, "e1_settle_pak" );
	level.scr_anim["e1_pak43"]["e1_fire_pak"][0] = %o_berlin3_pak43_fire;
	addNotetrack_customFunction( "e1_pak43", "pak43_fire", maps\ber3_event_intro::e1_pak_fire, "e1_fire_pak" );
}

#using_animtree( "ber3_tank" );
setup_tank_trap_tank()
{
	level.scr_animtree["ber3_dtank"] 				= #animtree; 	
	level.scr_anim["ber3_dtank"]["fall_into_trap"] = %o_berlin3_tanktrap;	
}