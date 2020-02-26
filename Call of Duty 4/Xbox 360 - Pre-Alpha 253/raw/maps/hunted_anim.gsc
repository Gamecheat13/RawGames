#include maps\_anim;
#using_animtree("generic_human");

main()
{
	anims();
	run_anims();
	dialogue();
}

anims()
{
	// todo: how to make 2 dialog lines work.
	// Crash
	level.scr_anim[ "price" ][ "hunted_opening_price" ] =					%hunted_opening_price;
	addNotetrack_dialogue( "price", "dialog" ,"hunted_opening_price", "hunted_pri_youokay" );
	addNotetrack_dialogue( "price", "dialog" ,"hunted_opening_price", "hunted_pri_comeonsearchparties" );

	level.scr_anim[ "steve" ][ "hunted_woundedhostage_check" ] =			%hunted_woundedhostage_check_soldier;
	level.scr_anim[ "steve" ][ "hunted_woundedhostage_check_end" ] =		%hunted_woundedhostage_check_soldier_end;

//	todo: use notetrack
//	addNotetrack_sound( "steve", "anim_pose = \"stand\"" ,"hunted_woundedhostage_check_soldier", "hunted_gm1_outcold" );
	level.scr_sound[ "steve" ][ "check_soldier" ] =	"hunted_gm1_outcold";

	level.scr_anim[ "wounded" ][ "hunted_woundedhostage_check" ] =			%hunted_woundedhostage_check_hostage;
	level.scr_anim[ "wounded" ][ "hunted_woundedhostage_idle_start" ][0] =	%hunted_woundedhostage_idle_start;
	level.scr_anim[ "wounded" ][ "hunted_woundedhostage_idle_end" ][0] =	%hunted_woundedhostage_idle_end;

	// Dirt path 
	level.scr_anim[ "price" ][ "hunted_wave_chat" ] =				%hunted_wave_chat;
	addNotetrack_dialogue( "price", "dialog" ,"hunted_wave_chat", "hunted_pri_getunderbridge" );
	level.scr_anim[ "charlie" ][ "hunted_spotter_idle" ][0] =		%hunted_spotter_idle;
	level.scr_anim[ "charlie" ][ "hunted_spotter_idle" ][1] =		%hunted_spotter_twitch;
	level.scr_anim[ "charlie" ][ "hunted_spotter_wave_chat" ] =		%hunted_spotter_wave_chat;
	addNotetrack_dialogue( "charlie", "dialog" ,"hunted_spotter_wave_chat", "hunted_grg_vehiclesinbound" );

	// Tunnel
	level.scr_anim[ "mark" ][ "hunted_tunnel_guy1_runin" ] =		%hunted_tunnel_guy1_runin;
	level.scr_anim[ "mark" ][ "hunted_tunnel_guy1_idle" ][0] =		%hunted_tunnel_guy1_idle;
	level.scr_anim[ "mark" ][ "hunted_tunnel_guy1_lookup" ] =		%hunted_tunnel_guy1_lookup;
	level.scr_anim[ "mark" ][ "hunted_tunnel_guy1_runout" ] =		%hunted_tunnel_guy1_runout;
	level.scr_anim[ "price" ][ "hunted_tunnel_guy2_runin" ] =		%hunted_tunnel_guy2_runin;
	level.scr_anim[ "price" ][ "hunted_tunnel_guy2_idle" ][0] =		%hunted_tunnel_guy2_idle;
	level.scr_anim[ "price" ][ "hunted_tunnel_guy2_runout" ] =		%hunted_tunnel_guy2_runout;
	level.scr_sound[ "price" ][ "hunted_tunnel_guy2_runout" ]		= "hunted_pri_allclearmove";
	level.scr_anim[ "price" ][ "hunted_tunnel_guy2_runout_interrupt" ] =		%hunted_tunnel_guy2_runout;

	// Barn and small farm
	level.scr_anim[ "price" ][ "hunted_open_barndoor" ] =			%hunted_open_barndoor;
	level.scr_sound[ "price" ][ "hunted_open_barndoor" ]			= "hunted_pri_holdupcompany";
	level.scr_anim[ "price" ][ "hunted_open_barndoor_stop" ] =		%hunted_open_barndoor_stop;
	level.scr_anim[ "price" ][ "hunted_open_barndoor_idle" ][0] =	%hunted_open_barndoor_idle;
	level.scr_anim[ "price" ][ "hunted_open_barndoor_nodialogue" ] =	%hunted_open_barndoor;

	level.scr_anim[ "mark" ][ "door_kick_in" ] =					%door_kick_in;

	level.scr_anim[ "leader" ][ "hunted_farmsequence" ] =			%hunted_farmsequence_leader;
	level.scr_anim[ "farmer" ][ "hunted_farmsequence" ] =			%hunted_farmsequence_farmer;
	level.scr_anim[ "thug" ][ "hunted_farmsequence" ] =				%hunted_farmsequence_brute1;

	level.scr_anim[ "farmer" ][ "farmer_altending" ] =				%hunted_farmsequence_farmer_altending;

	level.scr_anim[ "farmer" ][ "hack_idle" ][0] =					%hunted_pronehide_idle_v3;


/*	addNotetrack_sound( "leader", "" ,"hunted_farmsequence", "hunted_ru1_dontplaystupid" );
	addNotetrack_sound( "leader", "" ,"hunted_farmsequence", "hunted_ru2_yougotanimals" );
	addNotetrack_sound( "leader", "" ,"hunted_farmsequence", "hunted_ru1_forgetit" );

	addNotetrack_sound( "farmer", "" ,"hunted_farmsequence", "hunted_ruf_whatsgoingon" );
	addNotetrack_sound( "farmer", "" ,"hunted_farmsequence", "hunted_ruf_hidingwho" );
	addNotetrack_sound( "farmer", "" ,"hunted_farmsequence", "hunted_ruf_american" );
*/
// todo: cange to use the above notetrack stuff.
	level.scr_sound[ "farmer" ][ "whatsgoingon" ] =					"hunted_ruf_whatsgoingon";
	level.scr_sound[ "leader" ][ "dontplaystupid" ] =				"hunted_ru1_dontplaystupid";
	level.scr_sound[ "farmer" ][ "hidingwho" ] =					"hunted_ruf_hidingwho";
	level.scr_sound[ "leader" ][ "yougotanimals" ] =				"hunted_ru2_yougotanimals";
	level.scr_sound[ "farmer" ][ "american" ] =						"hunted_ruf_american";
	level.scr_sound[ "leader" ][ "forgetit" ] =						"hunted_ru1_forgetit";


	// Field
	level.scr_anim[ "price" ][ "hunted_dive_2_pronehide" ] =		%hunted_dive_2_pronehide_v1;
	level.scr_anim[ "price" ][ "hunted_pronehide_idle" ][0] =		%hunted_pronehide_idle_v1;
	level.scr_anim[ "price" ][ "hunted_pronehide_2_stand" ] =		%hunted_pronehide_2_stand_v1;
	level.scr_anim[ "mark" ][ "hunted_dive_2_pronehide" ] =			%hunted_dive_2_pronehide_v1;
	level.scr_anim[ "mark" ][ "hunted_pronehide_idle" ][0] =		%hunted_pronehide_idle_v1;
	level.scr_anim[ "mark" ][ "hunted_pronehide_2_stand" ] =		%hunted_pronehide_2_stand_v1;
	level.scr_anim[ "steve" ][ "hunted_dive_2_pronehide" ] =		%hunted_dive_2_pronehide_v2;
	level.scr_anim[ "steve" ][ "hunted_pronehide_idle" ][0] =		%hunted_pronehide_idle_v2;
	level.scr_anim[ "steve" ][ "hunted_pronehide_2_stand" ] =		%hunted_pronehide_2_stand_v2;
	level.scr_anim[ "charlie" ][ "hunted_dive_2_pronehide" ] =		%hunted_dive_2_pronehide_v3;
	level.scr_anim[ "charlie" ][ "hunted_pronehide_idle" ][0] =		%hunted_pronehide_idle_v3;
	level.scr_anim[ "charlie" ][ "hunted_pronehide_2_stand" ] =		%hunted_pronehide_2_stand_v3;

	level.scr_anim[ "mark" ][ "hunted_open_basement_door_kick" ] =		%hunted_open_basement_door_kick;
	
	// Basement
	level.scr_anim[ "price" ][ "hunted_basement_door_block" ] =		%hunted_basement_door_block;

	// creek

	level.scr_anim[ "price" ][ "hunted_open_creek_gate_stop" ] =	%hunted_open_barndoor_stop;
	level.scr_anim[ "price" ][ "hunted_open_creek_gate" ] =			%hunted_open_barndoor;

	level.scr_anim[ "guard1" ][ "roadblock_sequence" ] =			%hunted_roadblock_guy1_sequence;
	level.scr_anim[ "guard1" ][ "roadblock_startidle" ][0] =		%hunted_roadblock_guy1_startidle;
	level.scr_anim[ "guard2" ][ "roadblock_sequence" ] =			%hunted_roadblock_guy2_sequence;
	level.scr_anim[ "guard2" ][ "roadblock_startidle" ][0] =		%hunted_roadblock_guy2_startidle;


}


run_anims()
{
	level.scr_anim[ "price" ][ "path_slow" ] =				%huntedrun_1_idle;
	level.scr_anim[ "price" ][ "path_slow_left" ] =			%huntedrun_1_look_left;
	level.scr_anim[ "price" ][ "path_slow_right" ] =		%huntedrun_1_look_right;
	level.scr_anim[ "price" ][ "sprint" ] =					%sprint1_loop;

	level.scr_anim[ "mark" ][ "path_slow" ] =				%huntedrun_1_idle;
	level.scr_anim[ "mark" ][ "sprint" ] =					%sprint1_loop;

	level.scr_anim[ "steve" ][ "path_slow" ] =				%huntedrun_2;
	level.scr_anim[ "steve" ][ "sprint" ] =					%sprint1_loop;

	level.scr_anim[ "charlie" ][ "path_slow" ] =			%huntedrun_1_idle;
	level.scr_anim[ "charlie" ][ "sprint" ] =				%sprint1_loop;

	level.scr_anim[ "thug" ][ "walk_slow" ] =				%huntedrun_2;

	level.scr_anim[ "guard1" ][ "patrolwalk" ] =			%active_patrolwalk_v1;
	level.scr_anim[ "guard2" ][ "patrolwalk" ] =			%active_patrolwalk_v2;

	level.scr_anim[ "axis" ][ "patrolwalk_1" ] =			%active_patrolwalk_v1;
	level.scr_anim[ "axis" ][ "patrolwalk_2" ] =			%active_patrolwalk_v2;
	level.scr_anim[ "axis" ][ "patrolwalk_3" ] =			%active_patrolwalk_v3;
	level.scr_anim[ "axis" ][ "patrolwalk_4" ] =			%active_patrolwalk_v4;
	level.scr_anim[ "axis" ][ "patrolwalk_5" ] =			%active_patrolwalk_v5;
	level.scr_anim[ "axis" ][ "patrolwalk_pause" ] =		%active_patrolwalk_pause;
	level.scr_anim[ "axis" ][ "patrolwalk_turn" ] =			%active_patrolwalk_turn_180;

	level.scr_anim[ "axis" ][ "dazed_a" ] =					%hunted_dazed_walk_A_zombie;
	level.scr_anim[ "axis" ][ "dazed_b" ] =					%hunted_dazed_walk_B_blind;
	level.scr_anim[ "axis" ][ "dazed_c" ] =					%hunted_dazed_walk_C_limp;
}

dialogue()
{
//	level.scr_sound[ "price" ][ "hunted_opening_price" ] =	"hunted_pri_youokay";
//	addNotetrack_sound( "price", "dialog", ,"", "" );

	// crash
	level.scr_sound[ "price" ][ "getequipoutchopper" ] =	"hunted_pri_getequipoutchopper";
	level.scr_sound[ "mark" ][ "howsourvip" ] =				"hunted_grg_howsourvip";
//	level.scr_sound[ "steve" ][ "outcold" ] =				"hunted_gm1_outcold";
	level.scr_sound[ "steve" ][ "yessir" ] =				"hunted_gm1_yessir";

	// path
	level.scr_sound[ "price" ][ "letsgo" ] =				"hunted_pri_letsgo";

	// barn
	level.scr_sound[ "price" ][ "wastebeforekill" ] =		"hunted_pri_wastebeforekill";
	level.scr_sound[ "price" ][ "goodtogo" ] =				"hunted_pri_goodtogo";
	level.scr_sound[ "charlie" ][ "goodtogo" ] =			"hunted_gm2_goodtogo";

	level.scr_sound[ "thug" ][ "newgoverment" ] =			"hunted_ru1_newgoverment";
	level.scr_sound[ "thug" ][ "whatcharge" ] =				"hunted_ru2_whatcharge";
	level.scr_sound[ "thug" ][ "absolutelynothing" ] =		"hunted_ru1_absolutelynothing";
	level.scr_sound[ "thug" ][ "bullshit" ] =				"hunted_ru2_bullshit";
	level.scr_sound[ "thug" ][ "laugh1" ] =					"hunted_ru1_laugh";
	level.scr_sound[ "thug" ][ "laugh2" ] =					"hunted_ru2_laugh";

	// field
	level.scr_sound[ "price" ][ "spotlighthitdeck" ] =		"hunted_pri_spotlighthitdeck";
	level.scr_sound[ "price" ][ "basementdooropen" ] =		"hunted_pri_basementdooropen";
	level.scr_sound[ "price" ][ "gethousegogo" ] =			"hunted_pri_gethousegogo";
	level.scr_sound[ "mark" ][ "contactsix" ] =				"hunted_grg_contactsix";

	// basement
	level.scr_sound[ "price" ][ "takepointscout" ] =		"hunted_pri_takepointscout";

	// farm
	level.scr_sound[ "steve" ][ "tooquiet" ] =				"hunted_gm1_tooquiet";
	level.scr_sound[ "mark" ][ "regroupin" ] =				"hunted_grg_regroupin";

	// creek
	level.scr_sound[ "mark" ][ "helicopterscomin" ] =		"hunted_grg_helicopterscomin";
	level.scr_sound[ "price" ][ "theyvelostus" ] =			"hunted_pri_theyvelostus";
	level.scr_sound[ "price" ][ "dontknowexactly" ] =		"hunted_pri_dontknowexactly";

	// todo: get correct dialogue for these lines.
	level.scr_sound[ "price" ][ "helicopter_cover" ]		= "hunted_pri_holdupcompany";
	level.scr_sound[ "price" ][ "bridge_holdup" ]			= "hunted_pri_dontknowexactly";
	level.scr_sound[ "price" ][ "creek_move_now" ]			= "hunted_pri_letsgo";


	// greenhouse
	level.scr_sound[ "mark" ][ "stingermissles" ] =			"hunted_grg_stingermissles";
	level.scr_sound[ "price" ][ "grabastinger" ] =			"hunted_pri_grabastinger";
	level.scr_sound[ "mark" ][ "youdaman" ] =				"hunted_grg_youdaman";
	level.scr_sound[ "price" ][ "goodwork" ] =				"hunted_pri_goodwork";

	// ac130
	level.scr_sound[ "mark" ][ "bringingintanks" ] =		"hunted_grg_bringingintanks";
	level.scr_sound[ "price" ][ "packagesecure" ] =			"hunted_pri_packagesecure";
	level.scr_sound[ "hqr" ][ "requestfire" ] =				"hunted_hqr_requestfire";
	level.scr_sound[ "mark" ][ "airsupport" ] =				"hunted_grg_airsupport";

	level.scr_sound[ "acc" ][ "usesomehelp" ] =				"hunted_acc_usesomehelp";
	level.scr_sound[ "price" ][ "150meterseast" ] =			"hunted_pri_150meterseast";
	level.scr_sound[ "acc" ][ "comindown" ] =				"hunted_acc_comindown";
	level.scr_sound[ "mark" ][ "ohyeah" ] =					"hunted_grg_ohyeah";

	level.scr_sound[ "charlie" ][ "hellyeah" ] =			"hunted_gm3_hellyeah";
	level.scr_sound[ "acc" ][ "getmovin" ] =				"hunted_acc_getmovin";
	level.scr_sound[ "price" ][ "movinnow" ] =				"hunted_pri_movinnow";

}