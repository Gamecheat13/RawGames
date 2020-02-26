#include maps\_utility;
#include maps\_anim;

#using_animtree ("generic_human");
main()
{
	event1();
	event1_bunker_doors();
	event2();
	event3();
	event4();
	
	new_dialogue();
	level thread do_collectible_corpse();
	
}

// this should play as of 8/13 - Jesse
new_dialogue()
{

// "Our Tanks are getting hammered by mortar fire!"\
level.scr_sound["roebuck"]["intro1"] = "Pel1A_IGD_100A_ROEB";
// "We need to clear these trenches and knock out each mortar pit!"\
level.scr_sound["roebuck"]["intro2"] = "Pel1A_IGD_101A_ROEB";
// "Get ready with that flamethrower!"\
level.scr_sound["roebuck"]["intro3"] = "Pel1A_IGD_102A_ROEB";
// "Incoming!!!"\
level.scr_sound["roebuck"]["intro4"] = "Pel1A_IGD_103A_ROEB";


// "MG up on that hill!"\
level.scr_sound["polonsky"]["first_mg1"] = "Pel1A_IGD_104A_POLO";
// "It's tearing up our men!"\
level.scr_sound["polonsky"]["first_mg2"] = "Pel1A_IGD_105A_POLO";
// "Throw some smoke for cover!... Or it will rip us to shreds!"\
level.scr_sound["roebuck"]["first_mg3"] = "Pel1A_IGD_106A_ROEB";
// "Throw smoke!"\
level.scr_sound["polonsky"]["first_mg4"] = "Pel1A_IGD_107A_POLO";
// "Go!"\
level.scr_sound["roebuck"]["first_mg5"] = "Pel1A_IGD_108A_ROEB";
//// "Is that MG is history?"\
//level.scr_sound["roebuck"]["first_mg6"] = "Pel1A_IGD_109A_ROEB";
// "All right... let's keep on 'em!"\
level.scr_sound["roebuck"]["first_mg7"] = "Pel1A_IGD_110A_ROEB";
// "This way!"\
level.scr_sound["roebuck"]["first_mg8"] = "Pel1A_IGD_111A_ROEB";

// "shit"
level.scr_sound["roebuck"]["darn"] = "Pel1A_IGD_142A_ROEB";


// "Eyes open!"\
level.scr_sound["roebuck"]["first_mortar_pit1"] = "Pel1A_IGD_112A_ROEB";
// "First mortar pit up ahead!"\
level.scr_sound["polonsky"]["first_mortar_pit2"] = "Pel1A_IGD_115A_POLO";
// "Go clear it out, Miller…"\
level.scr_sound["roebuck"]["first_mortar_pit3"] = "Pel1A_IGD_116A_ROEB";
// "One down.  Move on!"\
level.scr_sound["roebuck"]["first_mortar_pit4"] = "Pel1A_IGD_117A_ROEB";



// "Get up there!"\
level.scr_sound["roebuck"]["up_hill1"] = "Pel1A_IGD_113A_ROEB";
// "Take the high ground!"\
level.scr_sound["roebuck"]["up_hill2"] = "Pel1A_IGD_114A_ROEB";



// "There's the next mortar pit!"\
level.scr_sound["polonsky"]["second_mortar_pit1"] = "Pel1A_IGD_118A_POLO";
// "Burn 'em!!!!"\
level.scr_sound["roebuck"]["second_mortar_pit2"] = "Pel1A_IGD_119A_ROEB";
// "Taken out - One more pit to clear."\
level.scr_sound["roebuck"]["second_mortar_pit3"] = "Pel1A_IGD_120A_ROEB";
// "Keep it up."\
level.scr_sound["roebuck"]["second_mortar_pit4"] = "Pel1A_IGD_121A_ROEB";


// "Take cover!  Behind the barrels, get down!"\
level.scr_sound["roebuck"]["barrel_enemies1"] = "Pel1A_IGD_122A_ROEB";

// "Look out!  Enemies on the ridge!"\
level.scr_sound["polonsky"]["ridge_enemies1"] = "Pel1A_IGD_123A_POLO";

// "Last mortar pit's dead ahead - Move!"\
level.scr_sound["roebuck"]["third_mortar_pit1"] = "Pel1A_IGD_124A_ROEB";
// "We're almost done here."\
level.scr_sound["roebuck"]["third_mortar_pit2"] = "Pel1A_IGD_125A_ROEB";
// "Get in there and clear those tunnels!"\
level.scr_sound["roebuck"]["third_mortar_pit3"] = "Pel1A_IGD_126A_ROEB";
//// "Clear those tunnels!"\
//level.scr_sound["roebuck"]["third_mortar_pit4"] = "Pel1A_IGD_127A_ROEB";
// "Outstanding!"\
level.scr_sound["roebuck"]["third_mortar_pit5"] = "Pel1A_IGD_128A_ROEB";



//"Sir - Mortar pits have been neutralized... Tanks are now en route to the point."\
level.scr_sound["radio_man"]["outro1"] = "Pel1A_IGD_131A_RADO";
// "Tanks are moving up!"\
level.scr_sound["polonsky"]["outro2"] = "Pel1A_IGD_156A_POLO";

// "Tanks are moving up!"\
level.scr_sound["roebuck"]["we_made_it"] = "Pel1A_IGD_157A_ROEB";
// "Radio command - Tell 'em we've cleared the mortar pits."\
level.scr_sound["roebuck"]["outro3"] = "Pel1A_IGD_129A_ROEB";
// "Good work, Marines…"\
level.scr_sound["roebuck"]["outro4"] = "Pel1A_IGD_130A_ROEB";

	// "We got snipers in the trees!"
level.scr_sound["polonsky"]["treesnipers"] = "Oki2_IGD_100A_POLO";
}

#using_animtree( "generic_human" );
do_collectible_corpse()
{
	wait_for_first_player();
	spot = getstruct("collectible_body_align", "targetname");
	corpse = spawn( "script_model" , spot.origin );
	corpse character\char_jap_makpel_rifle::main();
	corpse UseAnimTree(#animtree);
	corpse.angles = spot.angles;
	corpse.animname = "collectible_dude";
	spot anim_single_solo (corpse, "hes_dead");
}

event1()
{
	// Opening Animation
	
	level.scr_anim["collectible_dude"]["hes_dead"] 			= %ch_pel1a_collectible;
	
	level.scr_anim["roebuck"]["event1_open_door"] 			= %ch_peleliu1a_intro_char1;
	level.scr_anim["polonsky"]["event1_open_door"] 			= %ch_peleliu1a_intro_char2;

	level.scr_sound["roebuck"]["intro_talk"]	 			= "Pel01_C1A_ROEB_004A";
	level.scr_sound["polonsky"]["intro_talk"] 				= "Pel01_C1A_POLO_003A";

	// Opening line
	// TODO: Dialogue needs to be changed to: Mortar fire incoming! Go left! -Into the trench! - Now!
	level.scr_sound["roebuck"]["mortars_to_the_trenches"] 	= "Pel1A_G1A_ROEB_001A";

	// Requesting air support ----------------------------------------//
	level.scr_sound["radio_man"]["air_support"]				= "Pel1A_G1A_RADI_002A";

	// Right when the player enters the trench -----------------------//
	level.scr_sound["roebuck"]["mg_stay_low"] 				= "Pel1A_G1A_ROEB_002A";

//	// Objective to eliminate mortars
//	level.scr_sound["roebuck"]["eliminate_mortars"] 		= "print:We have to take out these Mortar Crews!";

	// When the plane gets shot down ----------------------------------//
	// "Plane overhead - one of ours!"
	level.scr_sound["polonsky"]["plane_down1"]				= "Pel1A_G1A_POLO_003A";

	// "Shit! He's hit!"
	level.scr_sound["polonsky"]["plane_down2"] 				= "Pel1A_G1A_POLO_006A";
	
	// Guy running into the trench ------------------------------------//
	// "Shit shit shit!"
	level.scr_sound["joiner"]["rush_talk"] 					= "Pel1A_G1A_ARS3_022A";

	// Pop Smoke Scene ------------------------------------------------//
	// "Take cover! Wait for the smoke! That mg is right on us!"
	level.scr_sound["roebuck"]["will_pop_smoke"] 			= "Pel1A_G1A_ROEB_005A";
	level.scr_sound["roebuck"]["popped_smoke"] 				= "Pel1A_G1A_ROEB_006A";
}

event2()
{
	// "MG DEAD AHEAD, TAKE COVER!"
	level.scr_sound["polonsky"]["take_out_mg"]				= "Pel1A_G1A_POLO_007A";
}

event3()
{
	// Look out! Enemies on the ridge!
	level.scr_sound["polonsky"]["lookout"]					= "Pel1A_G1A_POLO_012A";
}

event4()
{
	// Tanks seen over head
	// Couldn’t armor show up sooner? Infantry’s been getting torn apart."
	level.scr_sound["polonsky"]["tanks_show_up"] 			= "Pel1A_G1A_POLO_013A";

	// CONVERSATION:

	// "Everybody has, Polonsky... The 200’s on the point are still hammering the beach."
	level.scr_sound["roebuck"]["glad_to_see"] 				= "Pel1A_G1A_ROEB_014A";

	// "That the same damn guns that hit Sullivan’s LVT? "
	level.scr_sound["polonsky"]["same_gun"] 				= "Pel1A_G1A_POLO_017A";

	// "That the same damn guns that hit Sullivan’s LVT? "
	level.scr_sound["roebuck"]["detour"]					= "Pel1A_G1A_ROEB_016A";

	// Door kick, at the end of the level
	level.scr_anim["event4_door_kicker"]["kick_door"] = %door_kick_in;
	maps\_anim::addNotetrack_customFunction("event4_door_kicker", "kick", ::event4_kick_door_open, "kick_door");

	// Found an officers
	level.scr_sound["talker"]["found_one"]					="Pel1A_G1A_ARS2_019A";
	level.scr_sound["talker"]["more_info"]					="Pel1A_G1A_ARS3_023A";

	level.scr_sound["polonsky"]["3days"]					="Pel1A_G1A_ARS3_023A";

	// Guys A, pushed onto the floor anim
	level.scr_anim["event4_push_a_ally"]["intro"] 			= %ch_peleliu1_pushed_a_guy1_intro;
	level.scr_anim["event4_push_a_ally"]["loop"][0] 		= %ch_peleliu1_pushed_a_guy1_loop;
	level.scr_anim["event4_push_a_axis"]["intro"] 			= %ch_peleliu1_pushed_a_guy2_intro;
	level.scr_anim["event4_push_a_axis"]["loop"][0] 		= %ch_peleliu1_pushed_a_guy2_loop;

	// Guys B, pushed against the wall
	level.scr_anim["event4_push_b_ally"]["intro"] 			= %ch_peleliu1_pushed_b_guy1_intro;
	level.scr_anim["event4_push_b_ally"]["loop"][0] 		= %ch_peleliu1_pushed_b_guy1_loop;
	level.scr_anim["event4_push_b_axis"]["intro"] 			= %ch_peleliu1_pushed_b_guy2_intro;
	level.scr_anim["event4_push_b_axis"]["loop"][0] 		= %ch_peleliu1_pushed_b_guy2_loop;

	// Hara Kiri
	PrecacheModel( "weapon_jap_katana" );
	level.scr_anim["event4_officer1"]["hara_kiri_idle"][0]	= %ch_peleliu1a_outro_guy1_idle;
	level.scr_anim["event4_officer1"]["hara_kiri"] 			= %ch_peleliu1a_outro_guy1;

	level.scr_anim["event4_officer2"]["hara_kiri_idle"][0]	= %ch_peleliu1a_outro_guy2_idle;
	level.scr_anim["event4_officer2"]["hara_kiri"] 			= %ch_peleliu1a_outro_guy2;

	// Road runners
	//level.scr_anim["generic"]["roadrunner0"]						= %combat_jog;
	level.scr_anim["generic"]["patroller" ]			 	 			= %patrol_bored_patrolwalk;
	level.scr_anim["generic"]["weary1"]									= %Ai_walk_weary_c;
	level.scr_anim["generic"]["weary2"]									= %Ai_walk_weary_d;
	level.scr_anim["generic"]["traffic_dude"][0]						= %ch_holland3_traffic;
	level.scr_anim["generic"]["traffic_dude_reach"]						= %ch_holland3_traffic;	
	
	
	
	// "Shit, I just don't get these guys"
	level.scr_sound["last_captor"]["shocked"]				="Pel1A_G1A_ARS3_025A";

	// Change to, "Three days? ... These bastards ain't giving up any time."
	level.scr_sound["polonsky"]["hara_kiri"]				="Pel1A_G1A_POLO_026A";
}

// Called from an animation
event4_kick_door_open( guy )
{
	door = GetEnt( "kick_door1", "targetname" );
	door ConnectPaths();
	door RotateTo( ( 0, -115, 0 ), 0.5, 0, 0.1 );

	node = GetNode( "event4_kicker_spot1", "targetname" );
	guy SetGoalNode( node );

	flankers = get_ai_group_ai( "event4_flankers" );
	nodes = GetNodeArray( "event4_flank_nodes", "targetname" );
	for( i = 0; i < flankers.size; i++ )
	{
		flankers[i] SetGoalNode( nodes[i] );
	}
}

#using_animtree ("pel1a_bunker_doors");
event1_bunker_doors()
{
	PrecacheModel( "tag_origin_animate" );

	level.scr_animtree["bunker_door_left"] 					= #animtree;
	level.scr_animtree["bunker_door_right"] 				= #animtree;

	level.scr_model["bunker_door_left"] 					= "tag_origin_animate";
	level.scr_anim["bunker_door_left"]["open"] 				= %o_peleliu1a_intro_doorl;

	level.scr_model["bunker_door_right"] 					= "tag_origin_animate";
	level.scr_anim["bunker_door_right"]["open"] 			= %o_peleliu1a_intro_doorr;
}