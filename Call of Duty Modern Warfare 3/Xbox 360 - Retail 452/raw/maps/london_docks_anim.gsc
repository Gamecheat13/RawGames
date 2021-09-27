#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;

main()
{
	generic_anims();
//	docks_mole();
	sas_leader();
	sas_guy();
	radio();
	forklift();
	docks_loaders();
	docks_guard();
	warehouse();
	sniper_targets();
	props();
//	docks_roof();
//	crane_and_lynx_crash();
	sewer_pipes();
	delivery_truck();
	player_anims();
	drone_anims();
	
//	pip_eyes_on();
//	pip_inspecting_cargo();
//	pip_got_caught();
//	pip_takedown();
}

#using_animtree( "generic_human" );
generic_anims()
{
	// UAV section ----------------------------------------
	// NOTE: Using scr_radio so it plays on the player.

	// "Our guy say what was in those containers?"
	level.scr_radio[ "london_dlt2_guysay" ] 		= "london_dlt2_guysay";

	// "Tell em not to take too long.  I don't wanna be out here all night."
	level.scr_radio[ "london_dlt1_outallnight" ] 	= "london_dlt1_outallnight";

	// "There's a lot of movement near those windows…and they're packin heat."
	level.scr_radio[ "london_trk_packinheat" ] 		= "london_trk_packinheat";

	// Generic alert idle
	level.scr_anim[ "generic" ][ "alert_idle" ][0] 	= %stand_alertb_idle1;

	// Truck door guys
	level.scr_anim[ "truck_door_guy1" ][ "idle" ][ 0 ] = %london_deliverytruck_close_door_guy1_idle;
	level.scr_anim[ "truck_door_guy1" ][ "close_door" ] = %london_deliverytruck_close_door_guy1;
	level.scr_anim[ "truck_door_guy2" ][ "idle" ][ 0 ] = %london_deliverytruck_close_door_guy2_idle;
	level.scr_anim[ "truck_door_guy2" ][ "close_door" ] = %london_deliverytruck_close_door_guy2;

	// Alley Section --------------------------------------
	level.scr_anim[ "generic" ][ "enemy_cellphone" ] 			= %london_warehouse_phone_walk;
	level.scr_anim[ "generic" ][ "enemy_cellphone_death" ] 		= %london_warehouse_phone_death;
	level.scr_anim[ "generic" ][ "enemy_cellphone_react" ]		= %london_warehouse_phone_reaction;

	level.scr_sound[ "generic" ][ "cellphone_line1" ]			= "london_ru3_fathercomesin";
	level.scr_sound[ "generic" ][ "cellphone_line2" ]			= "london_ru3_brothersbirthday";
	level.scr_sound[ "generic" ][ "cellphone_line3" ]			= "london_ru3_getoverit";

	level.scr_anim[ "generic" ][ "enemy_sleeping" ][ 0 ] 		= %london_warehouse_sleeper_idle;
	level.scr_anim[ "generic" ][ "enemy_sleeping_death" ] 		= %london_warehouse_sleeper_death;
	level.scr_anim[ "generic" ][ "enemy_sleeping_react" ] 		= %london_warehouse_sleeper_getup;


	level.scr_anim[ "generic" ][ "enemy_sleeping2" ][ 0 ] 		= %parabolic_guard_sleeper_idle;
	level.scr_anim[ "generic" ][ "enemy_sleeping2_death" ] 		= %parabolic_guard_sleeper_react;
	level.scr_anim[ "generic" ][ "enemy_sleeping2_react" ] 		= %parabolic_guard_sleeper_react;

	level.scr_anim[ "generic" ][ "surprise_react_left" ]		= %london_surprise_turnaround_left;
	level.scr_anim[ "generic" ][ "surprise_react_right" ]		= %london_surprise_turnaround_right;

	// Warehouse2 Breachers -------------------------------

	// "Ready"
	level.scr_sound[ "generic" ][ "london_dlt1_ready" ] 		= "london_dlt1_ready";

	// Warehouse Section ----------------------------------
//	addNotetrack_dialogue( "generic", "wave", "warehouse_breach_cut_enter", "london_dlt1_move" );

	// Enemies in warehouse
	level.scr_anim[ "generic" ][ "warehouse_computer_death" ] 		= %london_warehouse_computer_death;
	level.scr_anim[ "generic" ][ "warehouse_computer_react" ] 		= %london_warehouse_computer_reaction;
	level.scr_anim[ "generic" ][ "warehouse_computer" ][ 0 ]		= %london_warehouse_computer_idle;
	level.scr_anim[ "generic" ][ "warehouse_tv_watcher1" ][ 0 ]		= %london_warehouse_tv_idle_a;
	level.scr_anim[ "generic" ][ "warehouse_tv_watcher2" ][ 0 ]		= %london_warehouse_tv_idle_b;
	level.scr_anim[ "generic" ][ "warehouse_tv_watcher1_death" ] 	= %london_warehouse_tv_death_a;
	level.scr_anim[ "generic" ][ "warehouse_tv_watcher2_death" ] 	= %london_warehouse_tv_death_b;
	level.scr_anim[ "generic" ][ "warehouse_tv_watcher1_react" ] 	= %london_warehouse_tv_reaction_a;
	level.scr_anim[ "generic" ][ "warehouse_tv_watcher2_react" ] 	= %london_warehouse_tv_reaction_b;

	level.scr_anim[ "generic" ][ "standing_death" ] 				= %exposed_death_nerve;

//	level.scr_anim[ "generic" ][ "warehouse_breach_reaction1" ] 	= %london_boltcut_death_1;
//	addNotetrack_customFunction( "generic", "kill", ::anim_kill_ai, "warehouse_breach_reaction1" );
//	level.scr_anim[ "generic" ][ "warehouse_breach_reaction2" ] 	= %london_boltcut_death_2;
//	addNotetrack_customFunction( "generic", "kill", ::anim_kill_ai, "warehouse_breach_reaction2" );
//	level.scr_anim[ "generic" ][ "warehouse_breach_reaction3" ] 	= %london_boltcut_frantic_3;
//	addNotetrack_customFunction( "generic", "gun_in_hand", ::warehouse_reaction3, "warehouse_breach_reaction3" );

	// Walks
	level.scr_anim[ "generic" ][ "walk_casual" ]				= %london_inspector_walk;
	level.scr_anim[ "generic" ][ "walk_gunup" ] 				= %london_dock_soldier_walk_gunup;
	level.scr_anim[ "generic" ][ "walk_point" ] 				= %london_dock_soldier_walk_point;
	level.scr_anim[ "generic" ][ "walk_gundown" ] 				= %london_dock_soldier_walk;

	// Warehouse Exit -------------------------------------
	level.scr_anim[ "generic" ][ "window_explosion_reaction_idle" ][ 0 ]	= %london_kickout_window_idle_reaction;
	level.scr_anim[ "generic" ][ "window_explosion_reaction" ]				= %london_kickout_window_kick_reaction;

	// "RPG loose!  RPG loose!!!!"
	level.scr_sound[ "generic" ][ "london_spt_rpgloose" ] 				= "london_spt_rpgloose";

	// "Clear, boss!"
	level.scr_sound[ "generic" ][ "london_myr_clearboss" ] 				= "london_myr_clearboss";

	// 2nd warehouse, using above warehouse breacher anims as well.
	level.scr_anim[ "generic" ][ "warehouse2_cutter_enter" ] 			= %breach_kick_kickerR1_enter;
	addNotetrack_customFunction( "generic", "kick", ::warehouse2_door_open, "warehouse2_cutter_enter" );

	level.scr_anim[ "generic" ][ "warehouse2_breacher2_enter" ] 		= %breach_kick_stackl1_enter;

	level.scr_anim[ "generic" ][ "warehouse2_breacher_trans" ] 		= %breach_stackL_approach;
	level.scr_anim[ "generic" ][ "warehouse2_breacher_idle" ][ 0 ] 	= %explosivebreach_v1_stackL_idle;
	level.scr_anim[ "generic" ][ "warehouse2_breacher_enter" ] 		= %explosivebreach_v1_stackL_enter;

	// Docks Section --------------------------------------
	level.scr_anim[ "generic" ][ "mole_walk" ]				= %london_inspector_walk;
	level.scr_anim[ "generic" ][ "stack_right1_idle" ][ 0 ]	= %breach_flash_R1_idle;
	level.scr_anim[ "generic" ][ "stack_right2_idle" ][ 0 ]	= %breach_flash_R2_idle;
	level.scr_anim[ "generic" ][ "stack_left1_idle" ][ 0 ]	= %explosivebreach_v1_stackL_idle;
	level.scr_anim[ "generic" ][ "stack_left2_idle" ][ 0 ]	= %explosivebreach_v1_detcord_idle;

	level.scr_anim[ "generic" ][ "stack_left2_idle" ][ 0 ]	= %explosivebreach_v1_detcord_idle;

	// "CONTACT!!!!!!"
	level.scr_sound[ "generic" ][ "london_myr_contact" ] = "london_myr_contact";
	// "AMBUSH!!!!"
	level.scr_sound[ "generic" ][ "london_sasl_gotcompany" ] = "london_sasl_gotcompany";
}

warehouse()
{
	level.scr_anim[ "attacker" ][ "warehouse_melee1" ]	= %cornersdl_melee_wind_attacker;
	level.scr_anim[ "defender" ][ "warehouse_melee1" ]	= %cornersdl_melee_wind_defender;
	level.scr_animSound[ "attacker" ][ "warehouse_melee1" ] = "scn_london_corner_melee";

	addnotetrack_customfunction( "attacker", "unsync", ::anim_can_kill, "warehouse_melee1" );
	addnotetrack_customfunction( "attacker", "melee_death", ::anim_kill_ai, "warehouse_melee1" );
	addnotetrack_customfunction( "defender", "fire_spray", ::melee_blood_fx, "warehouse_melee1" );
	addnotetrack_sound( "attacker", "playsound_kneehit", "warehouse_melee1", "scn_london_corner_melee_hit" );
}

sniper_targets()
{
	level.scr_anim[ "target1" ][ "idle" ][ 0 ] 	= %london_sniper_death_allen_idle;
	level.scr_anim[ "target1" ][ "death" ]		= %london_sniper_death_allen;
	level.scr_anim[ "target2" ][ "idle" ][ 0 ] 	= %london_sniper_death_lateef_idle;
	level.scr_anim[ "target2" ][ "death" ]		= %london_sniper_death_lateef;

	addnotetrack_customfunction( "target1", "impact", ::anim_nodeath, "death" );
	addnotetrack_customfunction( "target2", "impact", ::anim_nodeath, "death" );
}

docks_loaders()
{
	level.scr_anim[ "docks_loader1" ][ "idle" ][ 0 ] 		= %london_loader1_idle;
	level.scr_anim[ "docks_loader1" ][ "idle" ][ 1 ]		= %london_loader1_twitch;
	level.scr_anim[ "docks_loader1" ][ "loading" ] 			= %london_loader1_loading;
	level.scr_anim[ "docks_loader1" ][ "stepback" ]			= %london_loader1_stepback;
	level.scr_anim[ "docks_loader1" ][ "twitch" ] 			= %london_loader1_twitch;
	level.scr_anim[ "docks_loader1" ][ "unloading" ] 		= %london_loader1_unloading;
//	level.scr_anim[ "docks_loader2" ][ "idle" ][ 0 ] 		= %london_loader2_idle;
//	level.scr_anim[ "docks_loader2" ][ "idle" ][ 1 ] 		= %london_loader2_twitch;
//	level.scr_anim[ "docks_loader2" ][ "loading" ] 			= %london_loader2_loading;
//	level.scr_anim[ "docks_loader2" ][ "stepback" ] 		= %london_loader2_stepback;
//	level.scr_anim[ "docks_loader2" ][ "unloading" ] 		= %london_loader2_unloading;

	level.scr_anim[ "guard" ][ "idle" ][ 0 ] 				= %london_loader3_idle;
	level.scr_anim[ "guard" ][ "idle" ][ 1 ] 				= %london_loader3_twitch;
	level.scr_anim[ "guard" ][ "loading" ] 					= %london_loader3_loading;
	level.scr_anim[ "guard" ][ "shove" ] 					= %london_loader3_shove;
	level.scr_anim[ "guard" ][ "shootout" ] 				= %london_loader3_shootout;
}

docks_guard()
{
	level.scr_anim[ "docks_guard" ][ "mole_shake_hands" ] 	= %london_guard_handshake;
	level.scr_anim[ "docks_guard" ][ "idle" ][ 0 ] 			= %london_guard_idle1;
	level.scr_anim[ "docks_guard" ][ "idle" ][ 1 ] 			= %london_guard_idle2;
	level.scr_anim[ "docks_guard" ][ "idle" ][ 2 ] 			= %london_guard_twitch_lookleft1;
	level.scr_anim[ "docks_guard" ][ "idle" ][ 3 ] 			= %london_guard_twitch_lookright1;
	level.scr_anim[ "docks_guard" ][ "idle" ][ 4 ] 			= %london_guard_twitch_lookright2;
	level.scr_anim[ "docks_guard" ][ "idle" ][ 5 ]			= %london_guard_twitch_stretch;
}

sas_leader()
{
	// UAV intro ------------------------------------------
	// NOTE: Using scr_radio so it plays on the player.

	// "You seeing this, Overlord?"
	level.scr_radio[ "london_ldr_seeingthis" ] 					= "london_ldr_seeingthis";

	// "The trucks are leaving the docks right now."
	level.scr_radio[ "london_ldr_trucksaremovin" ] = "london_ldr_trucksaremovin";

	// "Wait…focus on those trucks for me."
	level.scr_radio[ "london_ldr_focusontrucks" ] 				= "london_ldr_focusontrucks";

	// "The trucks are movin…Vulture 2-1?"
	level.scr_radio[ "london_ldr_trucksaremovin" ] 				= "london_ldr_trucksaremovin";

	// "Only that they're planning something big.  We've seen incresed activity for weeks.  This is too coordinated for…The trucks are moving.  Vulture 2-1?"
	level.scr_radio[ "london_ldr_somethingbig" ] 				= "london_ldr_somethingbig";

	// "Grinch, bad guys rolling out - 15 meters from you."
	level.scr_radio[ "london_ldr_rollingout" ] 					= "london_ldr_rollingout";

	// "Heh.  Wilco."
	level.scr_radio[ "london_ldr_wilco" ] 						= "london_ldr_wilco";

	// "That's why I want eyes open and fingers on the trigger.  No need for things to go South."
	level.scr_radio[ "london_ldr_eyesopen" ] 					= "london_ldr_eyesopen";

	// "Overlord, the vans are moving out and Vulture 2-1 is shadowing.  We're ready to rock and roll."
	level.scr_radio[ "london_ldr_readytorock" ] 				= "london_ldr_readytorock";

	// "Alright gentlemen, time to get to work."
	level.scr_radio[ "london_ldr_gettowork" ] 					= "london_ldr_gettowork";
	level.scr_sound[ "sas_leader" ][ "london_ldr_gettowork" ] 	= "london_ldr_gettowork";


	// Alley Section -------------------------------------
	level.scr_anim[ "sas_leader" ][ "alley_comm_check" ] 				= %london_sandman_intro;
	level.scr_anim[ "sas_leader" ][ "alley_comm_idle" ][ 0 ]			= %london_sandman_talk_idle;
	level.scr_anim[ "sas_leader" ][ "alley_comm_trans" ] 				= %london_sandman_talk_trans_cqb;

	// "That's the warehouse in front of us.  Burns, we'll sweep - you clean."
	level.scr_sound[ "sas_leader" ][ "london_ldr_youclean" ] 			= "london_ldr_youclean";

	// "Weapons free."
	level.scr_sound[ "sas_leader" ][ "london_ldr_weaponsfree" ] 		= "london_ldr_weaponsfree";

	// "Alley Clear, move"
	level.scr_sound[ "sas_leader" ][ "london_ldr_alleyclear" ] 		= "london_ldr_alleyclear";

	// "Make sure they don't wake up."
	level.scr_sound[ "sas_leader" ][ "london_ldr_keepemsilent" ] 		= "london_ldr_keepemsilent";

	// "Go go go"
//	level.scr_sound[ "sas_leader" ][ "london_ldr_gogogo" ] 			= "london_ldr_gogogo";
	// "Bravo Nine's right on time."
	level.scr_sound[ "sas_leader" ][ "london_ldr_bravo9ontime" ] 		= "london_ldr_bravo9ontime";

	// Warehouse Section ----------------------------------
	// "Take 'em down."
	level.scr_sound[ "sas_leader" ][ "london_ldr_onme" ] = "london_ldr_onme";

	// "Burns, stack up on the door."
	level.scr_sound[ "sas_leader" ][ "stackup_nag1" ] 		= "london_ldr_stackupdoor";
	// "Are you daft?  Stack up on the door."
	level.scr_sound[ "sas_leader" ][ "stackup_nag2" ] 		= "london_ldr_stackupletsgo";

	// "Stack up."
	level.scr_sound[ "sas_leader" ][ "warehouse_breacher_trans" ] 		= "london_ldr_stackup";
	level.scr_anim[ "sas_leader" ][ "warehouse_breacher_trans" ] 		= %london_boltcut_b_entry;

	level.scr_anim[ "sas_leader" ][ "warehouse_breacher_idle" ][ 0 ] 	= %london_boltcut_b_idle;
	level.scr_anim[ "sas_leader" ][ "warehouse_breacher_enter" ] 		= %london_boltcut_b_breach_quiet;
	// "Alright. Cut it."
	level.scr_sound[ "sas_leader" ][ "warehouse_breacher_enter" ] 		= "london_ldr_alrightcutit";
	addNotetrack_customFunction( "sas_leader", "door_open", ::warehouse_door_open, "warehouse_breacher_enter" );

	// "Frost, take point"
	level.scr_sound[ "sas_leader" ][ "london_ldr_takepoint" ] 			= "london_ldr_takepoint";
	// "You're up, Burns.  Let's go."
	level.scr_sound[ "sas_leader" ][ "takepoint_nag" ] 					= "london_ldr_youreup";

	// "Sounds like more around the corner."
	level.scr_sound[ "sas_leader" ][ "london_ldr_checkthosecorners" ] = "london_ldr_checkthosecorners";

	// "Move."
	level.scr_sound[ "sas_leader" ][ "london_ldr_move" ] 				= "london_ldr_move";

	// "Room clear."
	level.scr_sound[ "sas_leader" ][ "london_ldr_roomclear" ] 			= "london_ldr_roomclear";
	// "Up the stairs."
	level.scr_sound[ "sas_leader" ][ "london_ldr_upstairs" ] 			= "london_ldr_upstairs";

	// New Warehouse exit
	level.scr_anim[ "sas_leader" ][ "window_kick_enter" ]				= %london_kickout_window_entrance;
	level.scr_anim[ "sas_leader" ][ "window_kick_idle" ][ 0 ]			= %london_kickout_window_idle;
	level.scr_anim[ "sas_leader" ][ "window_kick_action" ]				= %london_kickout_window_kick;
	level.scr_anim[ "sas_leader" ][ "window_kick_end_idle" ][ 0 ]		= %london_kickout_window_end_idle;

	level.scr_anim[ "sas_leader" ][ "door_kick" ]						= %doorkick_2_stand;

	// Warehouse exit -------------------------------------
	// "Greenlight on all teams.  Go!"
	level.scr_sound[ "sas_leader" ][ "london_ldr_bravostatus" ] 		= "london_ldr_bravostatus";

	// "Through the glass!"
	level.scr_sound[ "sas_leader" ][ "london_trk_whatthehell" ] 	= "london_trk_whatthehell";

	// Get Down here NAG
	// "Let's GO!"
	level.scr_sound[ "sas_leader" ][ "downhere_nag1" ] = "london_ldr_letsgo2";
	// "Move it!"
	level.scr_sound[ "sas_leader" ][ "downhere_nag2" ] = "london_ldr_moveit";
	// "Let's go!"
	level.scr_sound[ "sas_leader" ][ "downhere_nag3" ] = "london_ldr_letsgo";
	// "Burns!  Get down here, let's go!!"
	level.scr_sound[ "sas_leader" ][ "downhere_nag4" ] = "london_ldr_getdownhere";


	// Docks Section --------------------------------------

	// TODO !!! Once we get the sniper support
	// "Sierra 1, we're on foot!  Keep us covered!"
	level.scr_sound[ "sas_leader" ][ "london_ldr_onfoot" ] = "london_ldr_onfoot";

	// "All clear?!"
	level.scr_sound[ "sas_leader" ][ "london_ldr_allclear2" ] = "london_ldr_allclear2";

	// "Set up a perimeter!"
	level.scr_sound[ "sas_leader" ][ "london_ldr_perimetersecure" ] = "london_ldr_perimetersecure";
	// "Baseplate, the lorry is secure.  What's the status on the rest of em?"
	level.scr_sound[ "sas_leader" ][ "london_ldr_lorrysecure" ] 	= "london_ldr_lorrysecure";
	// "Roger.  Keep us posted.  Out."
	level.scr_sound[ "sas_leader" ][ "london_ldr_keepusposted" ] = "london_ldr_keepusposted";


	level.scr_sound[ "sas_leader" ][ "london_ldr_opendoors" ] = "london_ldr_opendoors";
	level.scr_anim[ "sas_leader" ][ "search_truck_entry" ] 		= %london_truck_search_wallcroft_entry;
	addnotetrack_customfunction( "sas_leader", "point", ::truck_point_dialogue, "search_truck_entry" );
	
	level.scr_anim[ "sas_leader" ][ "search_truck_idle" ]		= %london_truck_search_wallcroft_idle;
	level.scr_anim[ "sas_leader" ][ "search_truck_point" ]		= %london_truck_search_wallcroft_point;
	level.scr_anim[ "sas_leader" ][ "search_truck_lookinside" ] = %london_truck_search_wallcroft_lookinside; // "london_ldr_nickedweapons"
	addnotetrack_customfunction( "sas_leader", "ps_london_ldr_nickedweapons", ::truck_ambush_dialogue, "search_truck_lookinside" );

	// "Say again, Baseplate…."
	level.scr_sound[ "sas_leader" ][ "london_ldr_welcomingparty" ] = "london_ldr_welcomingparty";

	// "Tangos on the catwalk!!  Vulture 2 - sort em out!"
	level.scr_sound[ "sas_leader" ][ "london_ldr_tangosoncatwalk" ] = "london_ldr_tangosoncatwalk";

	
	// Nag-like Lines
	// "Burns, what are you waiting for?"
	level.scr_sound[ "sas_leader" ][ "frost_nag1" ] 		= "london_ldr_waitingfor";
	// "Burns, you're holding us back."
	level.scr_sound[ "sas_leader" ][ "frost_nag2" ] 		= "london_ldr_holdingusback";
	// "Burns, they're going to escape, come on."
	level.scr_sound[ "sas_leader" ][ "frost_nag3" ] 		= "london_ldr_goingtoescape";
	// "Move up Burns."
	level.scr_sound[ "sas_leader" ][ "frost_nag4" ] 		= "london_ldr_moveupfrost";
	// "Move, move!"
	level.scr_sound[ "sas_leader" ][ "frost_nag5" ] 		= "london_ldr_movemove";
	// "Let's GO!"
	level.scr_sound[ "sas_leader" ][ "frost_nag6" ] 		= "london_ldr_letsgo2";
	// "Go go go!"	
	level.scr_sound[ "sas_leader" ][ "frost_nag7" ] 		= "london_ldr_gogogo2";
	// "Move it!"
	level.scr_sound[ "sas_leader" ][ "frost_nag8" ] 		= "london_ldr_moveit";
	// "Let's go!"
	level.scr_sound[ "sas_leader" ][ "frost_nag9" ] 		= "london_ldr_letsgo";

	// "Vulture2, this is Sandman, where are the hostiles headed?"
//	level.scr_sound[ "sas_leader" ][ "london_ldr_whereheaded" ] 			= "london_ldr_whereheaded";

	// Construction Section -------------------------------
	// "Vulture 2 - keep us covered!"
	level.scr_sound[ "sas_leader" ][ "london_ldr_keepuscovered" ] 	= "london_ldr_keepuscovered";

	// "Vulture 2, we're still taking fire from the West!  I need you to hit em again!"
	level.scr_sound[ "sas_leader" ][ "london_ldr_firefromwest" ] 	= "london_ldr_firefromwest";

	// "Baseplate, hostiles rabbit on their toes back to the tube.  We're pushin on foot!"
	level.scr_sound[ "sas_leader" ][ "london_ldr_pursuing" ] 		= "london_ldr_pursuing";
}

truck_point_dialogue( guy )
{
	guy dialogue_queue( "london_ldr_opendoors" );
	flag_set( "player_open_doors" );	
}

truck_ambush_dialogue( guy )
{
	wait( 3 );
	thread radio_dialogue( "london_com_headedyourway" );
//	wait( 3 );
//	level.sas_leader dialogue_queue( "london_ldr_welcomingparty" );
}

sas_guy()
{
	// Alley Section --------------------------------------
	level.scr_anim[ "sas_guy" ][ "alley_fence_traverse" ] 		= %london_fence_drop;

	// "Got two more inside.  Sounds like they're getting some kip."
	level.scr_sound[ "sas_guy" ][ "london_trk_dozin" ]			= "london_trk_dozin";

	// "Two targets down the alley.  10 meters."
	level.scr_sound[ "sas_guy" ][ "london_trk_10meters" ] 		= "london_trk_10meters";
	// "Alley clear."
	level.scr_sound[ "sas_guy" ][ "london_trk_alleyclear" ] 	= "london_trk_alleyclear";

	// Warehouse Section ----------------------------------
	level.scr_anim[ "sas_guy" ][ "warehouse_breach_cut_trans" ] 	= %london_boltcut_a_entry;
	level.scr_anim[ "sas_guy" ][ "warehouse_breach_cut_idle" ][ 0 ]	= %london_boltcut_a_idle;
	level.scr_anim[ "sas_guy" ][ "warehouse_breach_cut_enter" ] 	= %london_boltcut_a_breach;	
	addnotetrack_customfunction( "sas_guy", "attach_boltcutters", ::attach_boltcutters, "warehouse_breach_cut_trans" );
	addnotetrack_customfunction( "sas_guy", "detach_boltcutters", ::detach_boltcutters, "warehouse_breach_cut_enter" );

	// "Got a shadow around the corner!"
	level.scr_sound[ "sas_guy" ][ "london_gfn_gotashadow" ] 		= "london_gfn_gotashadow";

	// "C'mon you slag, get up there."
	level.scr_sound[ "sas_guy" ][ "takepoint_nag" ] 				= "london_gfn_youslag";

	// "Mornin', gents."
	level.scr_sound[ "sas_guy" ][ "london_gfn_morningents" ] 		= "london_gfn_morningents";

	// "Room - clear."
	level.scr_sound[ "sas_guy" ][ "london_trk_roomclear" ] 			= "london_trk_roomclear";

	// Docks Section --------------------------------------
	// "Bollocks.  There's sod all in here."
	level.scr_sound[ "sas_guy" ][ "london_gfn_nickedweapons" ] 		= "london_gfn_nickedweapons";

	// "Clear!"
	level.scr_sound[ "sas_guy" ][ "london_gfn_clear2" ] = "london_gfn_clear2";

	// Construction Section -------------------------------
	// "They're falling back to the tube!"
	level.scr_sound[ "sas_guy" ][ "london_gfn_tothetube" ] 			= "london_gfn_tothetube";
}

radio()
{
	// UAV Intro ------------------------------------------
	// "Roger, Sandman, we have eyes."
	level.scr_radio[ "london_com_haveeyes" ] 		= "london_com_haveeyes";

	// "Roger, Sandman.  All teams - mission is a GO.  Repeat, mission is a GO."
	level.scr_radio[ "london_com_missionisgo" ] 	= "london_com_missionisgo";

	// UAV INTRO FLAVOR BURSTS ----------------------------
	// "Overlord, this is Weatherman.  We're just checkin' in with you….tape's rollin…"
	level.scr_radio[ "london_uav1_tapesrollin" ] 		= "london_uav1_tapesrollin";
	// "We're about 2 miles out, Overlord."
	level.scr_radio[ "london_uav2_2miles" ] 			= "london_uav2_2miles";
	// "Copy, 2 miles.  Just to, uhhhh, confirm…you are not cleared to fire, Weatherman…just monitor…"
	level.scr_radio[ "london_ovl_copy2miles" ] 			= "london_ovl_copy2miles";
	// "Roger that.  Not cleared to fire until we have your permission."
	level.scr_radio[ "london_uav1_notcleared" ] 		= "london_uav1_notcleared";
	// "Weatherman, there are multiple trucks…looks like 5 trucks in the center area of the docks - oriented North-South.  Do you see those?"
	level.scr_radio[ "london_ovl_5trucks" ] 			= "london_ovl_5trucks";
	// "That's affirmative.  5 vehicles in the center of the docks there."
	level.scr_radio[ "london_uav1_5vehicles" ] 			= "london_uav1_5vehicles";
	// "Tracking…"
	level.scr_radio[ "london_uav2_tracking" ] 			= "london_uav2_tracking";
//	// "Roger that, Weatherman.  Keep tracking…"
//	level.scr_radio[ "london_ovl_keeptracking" ] 		= "london_ovl_keeptracking";
	// "Roger."
	level.scr_radio[ "london_uav1_roger" ] 				= "london_uav1_roger";
	// "The vehicles are rollin out..."
	level.scr_radio[ "london_uav2_rollinout" ] 			= "london_uav2_rollinout";
	// "Overlord the vehicles are moving out right now."
	level.scr_radio[ "london_uav1_movingout" ] 			= "london_uav1_movingout";
	// "Ok, outside the gate at the corner there are two vans…You do see those, correct?"
	level.scr_radio[ "london_ovl_twovans" ] 			= "london_ovl_twovans";
//	// "Affirmative.  Those are the only two uhhhh…the only two vehicles we have on the ground."
//	level.scr_radio[ "london_ovl_onlytwowehave" ] 		= "london_ovl_onlytwowehave";
	// "Now, do you…do you see the big square building to the North of the docks?"
	level.scr_radio[ "london_ovl_squarebuilding" ] 		= "london_ovl_squarebuilding";
	// "Roger that."
	level.scr_radio[ "london_uav1_rogerthat" ] 			= "london_uav1_rogerthat";
	// "I got enemy personnel in the windows."
	level.scr_radio[ "london_uav2_inwindows" ] 			= "london_uav2_inwindows";
	// "Yeah, Overlord, the square building has enemy personnel visible in the windows."
	level.scr_radio[ "london_uav1_visible" ] 			= "london_uav1_visible";
	// "Weatherman, can you identify any weapons on the personnel?"
	level.scr_radio[ "london_ovl_identifyweapons" ] 	= "london_ovl_identifyweapons";
	// "Affirmative, Overlord.  They have weapons of some sort…definitely hot."
	level.scr_radio[ "london_uav1_definitelyhot" ] 		= "london_uav1_definitelyhot";
	// "I made out an RPG on one of em."
	level.scr_radio[ "london_uav2_maderpg" ] 			= "london_uav2_maderpg";

	// Alley Section --------------------------------------

	// SAS Warehouse Breachers ----------------------------
	// "Copy."
	level.scr_radio[ "london_sasl_copy" ] 				= "london_sasl_copy";

	

	// Warehouse Section ----------------------------------

	// Sniper Team
	// "delta_leader, this is Sierra 1, 2 hostiles on top floor of your building -- Taking the shot."
	level.scr_radio[ "london_spt_takingtheshot" ] 	= "london_spt_takingtheshot";
	// "Send them..."
	level.scr_radio[ "london_spt_sendthem" ] 		= "london_spt_sendthem";

	// Warehouse EXIT -------------------------------------
	// "In position, mate.  On your go."
	level.scr_radio[ "london_sasl_inpositionmate" ] = "london_sasl_inpositionmate";

	// "Outer perimeter's secure. "
	level.scr_radio[ "london_ldr_grinchup" ] = "london_ldr_grinchup";


	// TODO: PUT THIS IN WHEN WE HAVE SNIPER SUPPORT IN THE DOCKS #######################################################

	// ##################################################################################################################

	// Docks Section --------------------------------------

	// TODO: PUT THIS IN WHEN WE HAVE SNIPER SUPPORT IN THE DOCKS #######################################################
	// "Roger, boss.  Way ahead of ya…"
	level.scr_radio[ "london_sr1_rogerboss" ] = "london_sr1_rogerboss";

	// "Sandman, lots of movement out there.  Recommend you move through the buildings."
	level.scr_radio[ "london_sr1_thrubuildings" ] = "london_sr1_thrubuildings";

	// "RPG!!!!!!!!!!!!!!"
	level.scr_radio[ "london_gfn_rpg" ] 		= "london_gfn_rpg";
	// "Pull up!!!  Pull up!!!!"
	level.scr_radio[ "london_hp2_pullup" ] 		= "london_hp2_pullup";


	// ##################################################################################################################

	// Docks / Truck --------------------------------------
	// "Bravo Six, Sierra One.  You're all clear."
	level.scr_radio[ "london_sr1_thrubuildings" ] 			= "london_sr1_thrubuildings";

	// "Bravo Six, large *static* of your location.  *static*  FLIR shows *static* your way, over."
	level.scr_radio[ "london_com_headedyourway" ] 			= "london_com_headedyourway";

	// "Roger.  Inbound and hot."
	level.scr_radio[ "london_hp2_engaging" ] 				= "london_hp2_engaging";

	// Construction Section -------------------------------
	// "Copy.  Inbound for gun run."
	level.scr_radio[ "london_hp2_wereonit" ] 				= "london_hp2_wereonit";

	// "Coming back around.  Danger close."
	level.scr_radio[ "london_hp2_backaround" ] 				= "london_hp2_backaround";

	// "Copy that.  Vulture 2-2, scout ahead and check stops.  Find out where they're headed."
	level.scr_radio[ "london_com_awaitorders" ] 			= "london_com_awaitorders";
	// "Vulture 2-2, breaking away."
	level.scr_radio[ "london_hp2_maintainshadow" ] 			= "london_hp2_maintainshadow";
}

drone_anims()
{
	level.scr_anim[ "drone" ][ "body" ] 					= %body;
	level.scr_anim[ "drone" ][ "windowclimb" ] 				= %windowclimb;
	level.scr_anim[ "drone" ][ "stand_2_prone" ] 			= %stand_2_prone;
	level.scr_anim[ "drone" ][ "prone_2_stand" ] 			= %prone_2_stand;	
	level.scr_anim[ "drone" ][ "walk_CQB_F_relative" ] 		= %walk_CQB_F_relative;
	level.scr_anim[ "drone" ][ "reload" ]					= %prone_reload;
	level.scr_anim[ "drone" ][ "fire" ]						= %prone_fire_1;
}


#using_animtree( "vehicles" );
forklift()
{
//	level.scr_anim[ "forklift_a" ][ "forklift_anim1" ] 	= %london_docks_forkliftA;
//	level.scr_anim[ "forklift_b" ][ "forklift_anim1" ] 	= %london_docks_forkliftB;
	level.scr_animtree[ "forklift" ] 					= #animtree;
	level.scr_anim[ "forklift" ][ "up" ] 				= %london_docks_forklift_up;
	level.scr_anim[ "forklift" ][ "down" ] 				= %london_docks_forklift_down;
}

forklift_up()
{
	self SetAnimKnobAllRestart( self getanim( "up" ), %root );
}

forklift_down()
{
	self SetAnimKnobAllRestart( self getanim( "down" ), %root );
}

delivery_truck()
{
	
	level.scr_animtree[ "delivery_truck" ] 				= #animtree;
	level.scr_model[ "delivery_truck" ] 				= "vehicle_uk_delivery_truck_flir";

	level.scr_anim[ "delivery_truck" ][ "docks_doors_open" ] 			= %london_dock_truck_doors;
	level.scr_sound[ "delivery_truck" ][ "docks_doors_open" ]			= "scn_docks_truck_door_open";
	level.scr_anim[ "delivery_truck" ][ "docks_doors_close" ] 			= %london_dock_truck_doors_close;

	level.scr_anim[ "delivery_truck" ][ "close1" ] = %london_deliverytruck_close_door_guy1_truck;
	level.scr_anim[ "delivery_truck" ][ "idle1" ][ 0 ] = %london_deliverytruck_close_door_guy1_truck_idle;
	level.scr_anim[ "delivery_truck" ][ "close2" ] = %london_deliverytruck_close_door_guy2_truck;
	level.scr_anim[ "delivery_truck" ][ "idle2" ][ 0 ] = %london_deliverytruck_close_door_guy2_truck_idle;

	level.scr_anim[ "delivery_truck" ][ "docks_doors_open_nosound" ] 	= %london_dock_truck_doors;

	level.scr_anim[ "delivery_truck" ][ "player_open_truck_doors" ]		= %london_truck_open_doors;
}

truck_doors_idle()
{
	idle1 = self getanim( "idle1" );
	idle2 = self getanim( "idle2" );

	self SetAnimRestart( idle1[ 0 ] );
	self SetAnimRestart( idle2[ 0 ] );
}

truck_doors_close()
{
	close1 = self getanim( "close1" );
	close2 = self getanim( "close2" );

	self SetFlaggedAnimKnobRestart( "close_door1", close1 );
	self SetFlaggedAnimKnobRestart( "close_door2", close2 );
	self waittillmatch( "close_door2", "end" );
}

#using_animtree( "script_model" );

props()
{
	// Boltcutter animations - in sync with above anim.
	level.scr_animtree[ "boltcutters" ] 					 				= #animtree;
	level.scr_anim[ "boltcutters" ][ "warehouse_breach_cut_trans" ] 		= %london_boltcut_boltcutters_entry;
	level.scr_anim[ "boltcutters" ][ "warehouse_breach_cut_idle" ][ 0 ]		= %london_boltcut_boltcutters_idle;
	level.scr_anim[ "boltcutters" ][ "warehouse_breach_cut_enter" ] 		= %london_boltcut_boltcutters_breach;

	level.scr_anim[ "enemy_sleeping2_prop" ][ "enemy_sleeping2_death" ]			 = %parabolic_guard_sleeper_react_chair;
	level.scr_animtree[ "enemy_sleeping2_prop" ] 								 = #animtree;
	level.scr_model[ "enemy_sleeping2_prop" ] 									 = "com_folding_chair";
}

sewer_pipes()
{
	level.scr_animtree[ "sewer_pipe1" ] = #animtree;
	level.scr_animtree[ "sewer_pipe2" ] = #animtree;
	level.scr_animtree[ "sewer_pipe3" ] = #animtree;
	level.scr_animtree[ "bulldozer" ] 	= #animtree;

	level.scr_anim[ "sewer_pipe1" ][ "sewer_pipe_roll" ]		= %london_concrete_pipe_roll_1;
	addnotetrack_customFunction( "sewer_pipe1", "end", ::end_flag_set, "sewer_pipe_roll" );
	level.scr_anim[ "sewer_pipe2" ][ "sewer_pipe_roll" ]		= %london_concrete_pipe_roll_2;
	addnotetrack_customFunction( "sewer_pipe2", "end", ::end_flag_set, "sewer_pipe_roll" );

	level.scr_anim[ "sewer_pipe3" ][ "sewer_pipe_roll" ]		= %london_concrete_pipe_roll_3;
	level.scr_anim[ "bulldozer" ][ "sewer_pipe_roll" ]			= %london_concrete_pipe_roll_bulldozer;
}

end_flag_set( ent )
{
	ent ent_Flag_set( "end" );
}

// Custom Animation functions -----------------------------
warehouse_door_open( guy )
{
	door = GetEnt( "warehouse_door", "targetname" );

	handles = GetEntArray( door.target, "targetname" );
	array_call( handles, ::LinkTo, door );

	door PlaySound( "scn_london_door_slow_open" );
	door ConnectPaths();
	door RotateYaw( 140, 3, 0.25 );

    flag_set( "london_warehouse_door_kicked" );
}

warehouse2_door_open( guy )
{
	door = GetEnt( "warehouse2_door", "targetname" );
	door ConnectPaths();
	door PlaySound( "metal_door_kick" );
	door RotateYaw( 120, 0.5 );	

	// Have the enemies react now
	guys = GetEntArray( "sas_breacher_enemy_ai", "targetname" );
	guys = array_removedead_or_dying( guys );
	foreach ( guy in guys )
	{
		guy notify( "react" );
	}
}

melee_blood_fx( guy )
{
	if ( !IsDefined( guy.melee_attacker ) )
	{
		return;
	}

	tags = [ "J_Clavicle_LE", "J_Shoulder_LE" ];
	effects = [ "impact_fx_nonfatal", "impact_fx" ];

	tag = tags[ RandomInt( tags.size ) ];
	fx = effects[ RandomInt( effects.size ) ];
	origin = guy.melee_attacker GetTagOrigin( tag );
	PlayFx( getfx( fx ), origin );
}

anim_can_kill( guy )
{
	guy.allowdeath = true;
	guy.forceRagdollImmediate = true;
	guy.ragdoll_directionscale = 10;
}

anim_kill_ai( guy )
{
	if ( !IsAlive( guy ) )
	{
		return;
	}

	guy.a.nodeath = true;
	guy.allowDeath = true;
	guy set_battlechatter( false );

	guy Kill();
}

anim_nodeath( guy )
{
	guy.a.nodeath = true;
}

anim_drop_weapon( guy )
{
	if ( !IsDefined( guy ) )
	{
		return;
	}

	guy animscripts\shared::DropAllAIWeapons();
	return true;
}

anim_gun_recall( guy )
{
	if ( !IsAlive( guy ) )
	{
		return;
	}

	guy gun_recall();
}

warehouse_open_window( guy )
{
	exploder( "warehouse_window_frame" );
}

warehouse_window_kick( guy )
{
	exploder( "warehouse_window_frame_med" );
}

attach_boltcutters( guy )
{
	guy.boltcutters Show();
}

detach_boltcutters( guy )
{
	guy.boltcutters anim_stopanimscripted();
}

#using_animtree( "player" );
player_anims()
{
	level.scr_animtree[ "player_rig" ] 					 			= #animtree;
	level.scr_model[ "player_rig" ] 					 			= "viewhands_player_sas";
	level.scr_anim[ "player_rig" ][ "player_open_truck_doors" ] 	= %london_truck_open_player;
}


rocking_items()
{
	wait( 0.1 ); // magic wait for structs to initialize
	rockers = getstructarray_delete( "water_rock", "script_noteworthy" );
	models = [];

	foreach ( r in rockers )
	{
		m = Spawn( "script_model", r.origin );
		m.angles = r.angles;
		m setModel( r.script_modelname );
		m thread water_rock( r );
		
		models = array_add( models, m );
	}
	
	rockers = undefined;

	wait( 1 );	
	flag_wait( "docks_littlebird_strafe" );
	
	array_call( models, ::delete );
}

water_rock( node )
{
	self endon( "death" );
	self childthread water_bob( node );
	self childthread water_rock_angles( node );
}

water_bob( node )
{
	old = node.origin;
	
	maxdist = 5;
	if ( isdefined( node.script_maxdist ) )
	{
		maxdist = node.script_maxdist;
	}
	mindist = maxdist * 0.5;
	
	maxtime = 8;
	if ( isdefined( node.script_duration ) )
	{
		maxtime = node.script_duration;
	}
	mintime = maxtime * 0.5;
	
	node = undefined;
	
	while( 1 )
	{
		dist = RandomFloatRange( mindist, maxdist );
		time = RandomFloatRange( mintime,maxtime );
		
		self moveTo( old + (0,0,dist), time, time/2.0, time/2.0 );
		self waittill( "movedone" );
		self moveTo( old - (0,0,dist), time, time/2.0, time/2.0 );
		self waittill( "movedone" );
	}
}

water_rock_angles( node )
{
	old = node.angles;
	
	maxdist = 5;
	if ( isdefined( node.script_max_left_angle ) )
	{
		maxdist = node.script_max_left_angle;
	}
	mindist = maxdist * 0.5;
	
	maxtime = 8;
	if ( isdefined( node.script_duration ) )
	{
		maxtime = node.script_duration;
	}
	mintime = maxtime * 0.5;
	
	node = undefined;
	
	while( 1 )
	{
		dist = ( RandomFloatRange( mindist, maxdist ), 0, RandomFloatRange( mindist, maxdist ) );
		time = RandomFloatRange( 5,8 );
		
		self rotateTo( old + dist, time, time/2.0, time/2.0 );
		self waittill( "rotatedone" );
		self rotateTo( old - dist, time, time/2.0, time/2.0 );
		self waittill( "rotatedone" );
	}
}