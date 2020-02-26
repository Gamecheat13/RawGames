// seelow 2 anim file
#include common_scripts\utility;
#include maps\_utility;
#include maps\_anim;
#include maps\_music;

#using_animtree ("generic_human");

main()
{
	maps\_anim::init();
	
	setup_field_anims();
	setup_radiotower_anims();
	setup_fueldepot_anims();
	setup_lastbattle_anims();
	setup_train_station_anims();
	setup_generic_anims();
	setup_player_interactive_anims();
}

setup_field_anims()
{
	// Retreat smoke grenadiers
	level.scr_anim["trench guy"]["grenade1"] = %exposed_grenadeThrowB;
	level.scr_anim["trench guy"]["grenade2"] = %exposed_grenadeThrowC;
	
	// Commissar
	level.scr_sound["commissar"]["intro1"] = "See2_IGD_000A_COMM"; //"print: Brave Comrades of the 3rd Shock Army...";
	level.scr_sound["commissar"]["intro2"] = "See2_IGD_001A_COMM"; //"print: Today we lay waste to the German line!";
	// "Remember - you are vulnerable when reloading!"
	level.scr_sound["commissar"]["intro3"] = "See2_IGD_101A_COMM";
	level.scr_sound["commissar"]["more_88s"] = "See2_IGD_020A_COMM"; //"print: Push forward!!! More 88s remain - west and south of your position";
	level.scr_sound["commissar"]["fire"] = "See2_IGD_037A_COMM"; //"print: Fire on them!";
	// "Push forward to the trainstation!"
	level.scr_sound["commissar"]["intro4"] = "See2_IGD_101A_COMM";
	// "Keep pushing!"
	level.scr_sound["commissar"]["keep_pushing"] = "See2_IGD_103A_COMM";
	
	//Reznov
	level.scr_sound["reznov"]["flame_tip"] = "See2_IGD_002A_REZN"; //"print: Dimitri - ready the flamethrower";;
	level.scr_sound["reznov"]["flame_success"] = "See2_IGD_003A_REZN"; //"print: Good. Now take a closer look at those rats on the horizon";
	level.scr_sound["reznov"]["ads_success"] = "See2_IGD_004A_REZN"; //"print: They will be the first to burn this day!";
	level.scr_sound["reznov"]["flame_prompt"] = "See2_IGD_005A_REZN"; //"print: Fire the flamethrower - Incinerate them!";
	level.scr_sound["reznov"]["first_88"] = "See2_IGD_007A_REZN"; //"print: First 88... southwest!";
	level.scr_sound["reznov"]["first_88_destroy"] = "See2_IGD_009A_REZN"; //"print: Ha! The first of many, my friend.";
	level.scr_sound["reznov"]["reloading"] = "See2_IGD_011A_REZN"; //"print: Remember - We are vulnerable when reloading - Make every shell count!"; 
	level.scr_sound["reznov"]["second_88"] = "See2_IGD_017A_REZN"; //"print: Second 88 on the hill!... Southwest!";
	level.scr_sound["reznov"]["second_88_destroy"] = "See2_IGD_019A_REZN"; //"print: Two down!";
	level.scr_sound["reznov"]["route"] = "See2_IGD_021A_REZN"; //"print: Dimitri - Choose our route!";
	level.scr_sound["reznov"]["route2"] = "See2_IGD_022A_REZN"; //"print: Stay on the road or push through the field!";
	level.scr_sound["reznov"]["road_88s"] = "See2_IGD_023A_REZN"; //"print: Two more 88s southwest!";
	level.scr_sound["reznov"]["88_destroy"] = "See2_IGD_024A_REZN"; //"print: Ha! On to the next one";
	level.scr_sound["reznov"]["road_88s_destroy"] = "See2_IGD_025A_REZN"; //"print: Two more remain - over to the north!!";
	level.scr_sound["reznov"]["field_88s"] = "See2_IGD_026A_REZN"; //"print: Two more 88s northwest!";
	level.scr_sound["reznov"]["field_88s_destroy"] = "See2_IGD_030A_REZN"; //"print: Two more remain - over to the south!!";
	level.scr_sound["reznov"]["last_group_88s"] = "See2_IGD_038A_REZN"; //"print: Push On! Destroy the last two 88s";
	level.scr_sound["reznov"]["second_last_88"] = "See2_IGD_039A_REZN"; //"print: Only one left!";
	level.scr_sound["reznov"]["last_88_destroy"] = "See2_IGD_040A_REZN"; //"print: Excellent work, Dimitri!";
	// "See - Our infantry advances!"
	level.scr_sound["reznov"]["other_army"] = "See2_IGD_102A_REZN";
	// "On to Berlin!!!"
	level.scr_sound["reznov"]["to_berlin"] = "See2_IGD_104A_REZN";
	
	geo_arty_tarp();
}
	
setup_radiotower_anims()
{
	// Commissar
	level.scr_sound["commissar"]["radio_tower_obj"] = "See2_IGD_042A_COMM"; //"print: Attention, Comrades! (...) Push forward and obliterate the Fascist radio tower";
	
	// Reznov
	level.scr_sound["reznov"]["onward"] = "See2_IGD_041A_REZN"; //"print: Onward!";
	level.scr_sound["reznov"]["next_area"] = "See2_IGD_043A_REZN"; //"print: Follow the road to the northwest!";
	level.scr_sound["reznov"]["radio_tower_prompt"] = "See2_IGD_044A_REZN"; //"print: Radio tower to the North!";
	level.scr_sound["reznov"]["radio_tower2"] = "See2_IGD_045A_REZN"; //"print: Annihilate it!";
	level.scr_sound["reznov"]["radio_tower_destroy"] = "See2_IGD_046A_REZN"; //"print: Good work Dimitri, there will be no cry for reinforcements!";
	// "Enough talk - We must push forward to the train station!"
	level.scr_sound["reznov"]["train3"] = "See2_IGD_535A_REZN";
	geo_tower_fall();
}

setup_fueldepot_anims()
{
	// Reznov
	// "We will fight on to the train station... And then - on to Berlin!"
	level.scr_sound["reznov"]["train1"] = "See2_IGD_532A_REZN";
	// "There - we will prepare for the final push to the train station."
	level.scr_sound["reznov"]["train2"] = "See2_IGD_534A_REZN";
	// "The final push before we move onto Berlin."
	level.scr_sound["reznov"]["final_push"] = "See2_IGD_536A_REZN";
}

setup_lastbattle_anims()
{
	// Commissar
	// "The train station is within our grasp!"
	level.scr_sound["commissar"]["almost_there1"] = "See2_IGD_703A_COMM";
	// "Crush their final positions!"
	level.scr_sound["commissar"]["almost_there2"] = "See2_IGD_704A_COMM";
}

setup_train_station_anims()
{
	// "Comrades!  A great victory is ours!"
	level.scr_sound["commissar"]["victory1"] = "See2_IGD_705A_COMM";
	// "On to Berlin!!!"
	level.scr_sound["commissar"]["victory2"] = "See2_IGD_706A_COMM";
	// "Ura!!!!"
	level.scr_sound["commissar"]["victory3"] = "See2_IGD_707A_COMM";
	
	// outro
	level.scr_anim["guyl1"]["outro"] = %ch_seelow1_outro_left_russian_guy1;
	level.scr_anim["guyl2"]["outro"] = %ch_seelow1_outro_left_russian_guy2;
	level.scr_anim["guyl3"]["outro"] = %ch_seelow1_outro_left_russian_guy3;
	level.scr_anim["guyl4"]["outro"] = %ch_seelow1_outro_left_russian_guy4;
	level.scr_anim["guyl5"]["outro"] = %ch_seelow1_outro_left_russian_guy5;
	level.scr_anim["guyl6"]["outro"] = %ch_seelow1_outro_left_russian_guy6;

	// left guy 5 is chernov
	addnotetrack_dialogue( "guyc1", "dialog", "outro", "See2_OUT_010A_CHER" );

	level.scr_anim["guyc1"]["outro"] = %ch_seelow1_outro_middle_russian_guy1;
	level.scr_anim["guyc2"]["outro"] = %ch_seelow1_outro_middle_russian_guy2;
	level.scr_anim["guyc3"]["outro"] = %ch_seelow1_outro_middle_russian_guy3;
	level.scr_anim["guyc4"]["outro"] = %ch_seelow1_outro_middle_russian_guy4;
	level.scr_anim["guyc5"]["outro"] = %ch_seelow1_outro_middle_russian_guy5;
	level.scr_anim["guyc6"]["outro"] = %ch_seelow1_outro_middle_russian_guy6;

	// center guy 3 is reznov
	addnotetrack_attach( "guyc3", "attach_knife",  "weapon_rus_reznov_knife", "tag_weapon_left", "outro");
	addnotetrack_dialogue( "guyc3", "dialog", "outro", "See2_OUT_002A_REZN" );
	addnotetrack_dialogue( "guyc3", "dialog", "outro", "See2_OUT_001A_REZN" );
	addnotetrack_dialogue( "guyc3", "dialog", "outro", "See2_OUT_012A_REZN" );
	addnotetrack_dialogue( "guyc3", "dialog", "outro", "See2_OUT_013A_REZN" );
	addnotetrack_dialogue( "guyc3", "dialog", "outro", "See2_OUT_014A_REZN" );
	addnotetrack_dialogue( "guyc3", "dialog", "outro", "See2_OUT_015A_REZN" );
	//addnotetrack_dialogue( "guyc3", "dialog", "outro", "See2_OUT_015A_REZN" );
	
	// center guy # is redshirt 1
	addnotetrack_dialogue( "guyc5", "dialog", "outro", "See2_OUT_004A_RUR1" );
	addnotetrack_dialogue( "guyc5", "dialog", "outro", "See2_OUT_008A_RUR1" );
	addnotetrack_dialogue( "guyc5", "dialog", "outro", "See2_OUT_009A_RUR1" );
	
	// center guy # is redshirt 2
	addnotetrack_dialogue( "guyc6", "dialog", "outro", "See2_OUT_005A_RUR2" );
	addnotetrack_dialogue( "guyc6", "dialog", "outro", "See2_OUT_011A_RUR2" );

	level.scr_anim["guyr1"]["outro"] = %ch_seelow1_outro_right_russian_guy1;
	level.scr_anim["guyr2"]["outro"] = %ch_seelow1_outro_right_russian_guy2;
}

setup_generic_anims()
{
	// Drones
	level.scr_anim["truck drone"]["sit2"][0] = %crew_truck_guy1_sit_idle;
	level.scr_anim["truck drone"]["sit3"][0] = %crew_truck_guy2_sit_idle;
	level.scr_anim["truck drone"]["sit4"][0] = %crew_truck_guy3_sit_idle;
	level.scr_anim["truck drone"]["sit5"][0] = %crew_truck_guy4_sit_idle;
	level.scr_anim["truck drone"]["sit6"][0] = %crew_truck_guy5_sit_idle;
	level.scr_anim["truck drone"]["sit7"][0] = %crew_truck_guy6_sit_idle;
	level.scr_anim["truck drone"]["sit8"][0] = %crew_truck_guy7_sit_idle;
	level.scr_anim["truck drone"]["sit9"][0] = %crew_truck_guy8_sit_idle;
	
	level.scr_anim["truck drone"]["die2"] = %death_explosion_forward13;
	level.scr_anim["truck drone"]["die3"] = %death_explosion_left11;
	level.scr_anim["truck drone"]["die4"] = %death_explosion_left11;
	level.scr_anim["truck drone"]["die5"] = %death_explosion_back13;
	level.scr_anim["truck drone"]["die6"] = %death_explosion_forward13;
	level.scr_anim["truck drone"]["die7"] = %death_explosion_right13;
	level.scr_anim["truck drone"]["die8"] = %death_explosion_right13;
	level.scr_anim["truck drone"]["die9"] = %death_explosion_back13;
	
	//-- TODO: SWITCH THE [1] INDEX BACK TO "_c_" after verifying that "_b_" works
	level.scr_anim["flame_bunker"]["front_death"][0] = %ch_seelow2_flamedeath_b_front;
	level.scr_anim["flame_bunker"]["front_death"][1] = %ch_seelow2_flamedeath_b_front;
	level.scr_anim["flame_bunker"]["rear_death"][0] = %ch_seelow2_flamedeath_b_rear; 
	level.scr_anim["flame_bunker"]["rear_death"][1] = %ch_seelow2_flamedeath_b_rear; 
	level.scr_anim["flame_bunker"]["side_death"][0] = %ch_seelow2_flamedeath_b_side; 
	level.scr_anim["flame_bunker"]["side_death"][1] = %ch_seelow2_flamedeath_b_side; 
	
	
	level.drone_anims[ "stand" ][ "idle" ] = %drone_stand_idle;
	level.drone_anims[ "stand" ][ "run" ]	= %drone_stand_run;
	level.drone_anims[ "stand" ][ "aim_straight" ] =	%stand_aim_straight;
	level.drone_anims[ "stand" ][ "aim_up" ] = %stand_aim_up;	
	level.drone_anims[ "stand" ][ "aim_down" ] = %stand_aim_down;
	level.drone_anims[ "stand" ][ "reload" ] = %exposed_crouch_reload;
	
	// Infantry
	level.scr_sound["reznov"]["infantry1"] = "See2_IGD_500A_REZN"; //"print: More infantry!";
	// "German infantry!"
	level.scr_sound["reznov"]["infantry2"] = "See2_IGD_105A_REZN";
	// "Rip the flesh from their bones!"
	level.scr_sound["reznov"]["infantry3"] = "See2_IGD_107A_REZN";
	level.scr_sound["reznov"]["infantry_close1"] = "See2_IGD_501A_REZN"; //"print: Ha, they have nowhere to run!";
	level.scr_sound["reznov"]["infantry_close2"] = "See2_IGD_502A_REZN"; //"print: Roll over them! Break their bones!";
	// "Take them out!"
	level.scr_sound["reznov"]["infantry_close3"] = "See2_IGD_604A_REZN";
	// "Burn them!"
	level.scr_sound["reznov"]["infantry_close4"] = "See2_IGD_605A_REZN";
	// "Flame them!"
	level.scr_sound["reznov"]["infantry_close5"] = "See2_IGD_606A_REZN";
	// "Incinarate them!"
	level.scr_sound["reznov"]["infantry_close6"] = "See2_IGD_607A_REZN";
	// "Crush them!"
	level.scr_sound["reznov"]["REFERENCE"] = "See2_IGD_106A_REZN";

	// Tanks
	level.scr_sound["reznov"]["generic_tank1"] = "See2_IGD_503A_REZN"; //"print: German armor!";
	level.scr_sound["reznov"]["generic_tank2"] = "See2_IGD_504A_REZN"; //"print: Enemy tanks!";
	level.scr_sound["reznov"]["generic_tank3"] = "See2_IGD_505A_REZN"; //"print: Another tank!";
	level.scr_sound["reznov"]["tiger"] = "See2_IGD_506A_REZN"; //"print: King Tiger!";
	level.scr_sound["reznov"]["panzer"] = "See2_IGD_508A_REZN"; //"print: Panzer!";
	
	// Towers
	level.scr_sound["reznov"]["tower1"] = "See2_IGD_034A_REZN"; //"print: Panzerschreck!... In the tower";
	level.scr_sound["reznov"]["tower2"] = "See2_IGD_035A_REZN"; //"print: More panzerschrecks";
	level.scr_sound["reznov"]["tower3"] = "See2_IGD_036A_REZN"; //"print: Bring down the towers!";
	// "More Panzershrek fire!... Take them all out!"
	level.scr_sound["reznov"]["tower4"] = "See2_IGD_533A_REZN";
	// "Bring down those towers!"
	level.scr_sound["reznov"]["tower5"] = "See2_IGD_537A_REZN";
	// "Tower!"
	level.scr_sound["reznov"]["tower6"] = "See2_IGD_610A_REZN";
	// "Take down that tower!"
	level.scr_sound["reznov"]["tower7"] = "See2_IGD_611A_REZN";
	// "Destroy the tower!"
	level.scr_sound["reznov"]["tower8"] = "See2_IGD_612A_REZN";
	
	//Bunkers
	// "German bunker!"
	level.scr_sound["reznov"]["bunker1"] = "See2_IGD_608A_REZN";
	// "German stronghold!"
	level.scr_sound["reznov"]["bunker2"] = "See2_IGD_609A_REZN";
	
	//Trucks
	level.scr_sound["reznov"]["truck"] = "See2_IGD_509A_REZN"; //"print: Infantry transport!";
	
	//Retreaters
	level.scr_sound["reznov"]["retreaters1"] =  "See2_IGD_510A_REZN";//"print: Do not let them escape!";
	level.scr_sound["reznov"]["retreaters2"] = "See2_IGD_511A_REZN"; //"print: Blow them to pieces!";
	level.scr_sound["reznov"]["retreaters3"] = "See2_IGD_027A_REZN"; //"print: Finish them!!!";
	
	//Generic destroys
	level.scr_sound["reznov"]["generic_destroy1"] = "See2_IGD_028A_REZN"; //"print: Dasvidania!!!";
	level.scr_sound["reznov"]["generic_destroy2"] = "See2_IGD_029A_REZN";// "print: Ura!";
	// "Dasvidanya, Scum!"
	level.scr_sound["reznov"]["generic_destroy3"] = "See2_IGD_625A_REZN";
	// "Good Aim!"
	level.scr_sound["reznov"]["generic_destroy4"] = "See2_IGD_626A_REZN";
	// "Direct hit!"
	level.scr_sound["reznov"]["generic_destroy5"] = "See2_IGD_627A_REZN";
	// "Perfect shot!"
	level.scr_sound["reznov"]["generic_destroy6"] = "See2_IGD_628A_REZN";
	// "Ha Ha!"
	level.scr_sound["reznov"]["generic_destroy7"] = "See2_IGD_629A_REZN";
	// "Destroyed!"
	level.scr_sound["reznov"]["generic_destroy8"] = "See2_IGD_630A_REZN";
	level.scr_sound["reznov"]["generic_destroy9"] = "See2_IGD_016A_REZN"; //"print: Good hunting!";
	// "Good work, comrades!"
	level.scr_sound["commissar"]["generic_destroy10"] = "See2_IGD_623A_COMM";
	// "Show no mercy!"
	level.scr_sound["commissar"]["generic_destroy11"] = "See2_IGD_624A_COMM";
	
	// Fire Lines
	// "Shoot!!!"
	level.scr_sound["reznov"]["shoot1"] = "See2_IGD_600A_REZN";
	// "Fire!!!"
	level.scr_sound["reznov"]["shoot2"] = "See2_IGD_601A_REZN";
	// "Blow it to pieces!"
	level.scr_sound["reznov"]["shoot3"] = "See2_IGD_602A_REZN";
	// "Fire now!!!"
	level.scr_sound["reznov"]["shoot4"] = "See2_IGD_603A_REZN";
	level.scr_sound["reznov"]["shoot5"] = "See2_IGD_014A_REZN"; //"print: Fire!!!";
	level.scr_sound["reznov"]["shoot6"] = "See2_IGD_018A_REZN"; //"print: Fire!";
	level.scr_sound["reznov"]["shoot7"] = "See2_IGD_008A_REZN"; //"print: Take aim";
	
	// Dawdling Lines
	// "Get moving!"
	level.scr_sound["reznov"]["idle1"] = "See2_IGD_108A_REZN";
	// "Don't just sit here, Dimitri!"
	level.scr_sound["reznov"]["idle2"] = "See2_IGD_109A_REZN";
	// "Hurry... Dimitri!"
	level.scr_sound["reznov"]["idle3"] = "See2_IGD_110A_REZN";
	// "We could be burning Germans right now!"
	level.scr_sound["reznov"]["idle4"] = "See2_IGD_111A_REZN";
	// "What are you waiting for?!"
	level.scr_sound["reznov"]["idle5"] = "See2_IGD_112A_REZN";
	// "Get us out of here!"
	level.scr_sound["reznov"]["idle6"] = "See2_IGD_113A_REZN";

	
	//Directions
	level.scr_sound["reznov"]["ahead1"] = "See2_IGD_520A_REZN"; //"print: Straight ahead!";
	// "Straight ahead!"
	level.scr_sound["reznov"]["ahead2"] = "See2_IGD_621A_REZN";
	// "Turn right!"
	level.scr_sound["reznov"]["right1"] = "See2_IGD_613A_REZN";
	// "To the right!"
	level.scr_sound["reznov"]["right2"] = "See2_IGD_614A_REZN";
	// "Right of us!"
	level.scr_sound["reznov"]["right3"] = "See2_IGD_615A_REZN";
	// "Hard right!"
	level.scr_sound["reznov"]["right4"] = "See2_IGD_616A_REZN";
	// "Turn left!"
	level.scr_sound["reznov"]["left1"] = "See2_IGD_617A_REZN";
	// "To the left!"
	level.scr_sound["reznov"]["left2"] = "See2_IGD_618A_REZN";
	// "Left of us!"
	level.scr_sound["reznov"]["left3"] = "See2_IGD_619A_REZN";
	// "Hard left!"
	level.scr_sound["reznov"]["left4"] = "See2_IGD_620A_REZN";
	level.scr_sound["reznov"]["behind1"] = "See2_IGD_521A_REZN"; //"print: Behind us!";
	// "Behind us!"
	level.scr_sound["reznov"]["behind2"] = "See2_IGD_622A_REZN";
	
	// Hit response
	level.scr_sound["reznov"]["hit1"] = "See2_IGD_525A_REZN"; //"print: We are in his sights!";
	level.scr_sound["reznov"]["hit2"] = "See2_IGD_526A_REZN"; //"print: Move to a better position.";
	level.scr_sound["reznov"]["hit3"] = "See2_IGD_527A_REZN"; //"print: We are taking fire!";
	level.scr_sound["reznov"]["hit4"] = "See2_IGD_528A_REZN"; //"print: We are taking damage! MOVE!";
	level.scr_sound["reznov"]["hit5"] = "See2_IGD_531A_REZN"; //"print: Move!!!";
	level.scr_sound["reznov"]["hit6"] = "See2_IGD_010A_REZN"; //"print: Keep moving!";
	level.scr_sound["reznov"]["half_dead"] = "See2_IGD_529A_REZN"; //"print: Our armor is weakening!";
	level.scr_sound["reznov"]["near_death"] = "See2_IGD_530A_REZN"; //"print: If we take much more, we will burn to death!";
	
	//Enemy designations
	level.designation["vehicle_ger_tracked_panzer4v1"][0] = "generic_tank1";
	level.designation["vehicle_ger_tracked_panzer4v1"][1] = "generic_tank2";
	level.designation["vehicle_ger_tracked_panzer4v1"][2] = "generic_tank3";
	level.designation["vehicle_ger_tracked_panzer4v1"][3] = "panzer";
	
	level.designation["vehicle_ger_tracked_king_tiger"][0] = "generic_tank1";
	level.designation["vehicle_ger_tracked_king_tiger"][1] = "generic_tank2";
	level.designation["vehicle_ger_tracked_king_tiger"][2] = "generic_tank3";
	level.designation["vehicle_ger_tracked_king_tiger"][3] = "tiger";
	
	level.designation["vehicle_ger_tracked_panther"][0] = "generic_tank1";
	level.designation["vehicle_ger_tracked_panther"][1] = "generic_tank2";
	level.designation["vehicle_ger_tracked_panther"][2] = "generic_tank3";
	
	level.designation["vehicle_ger_wheeled_covered_opel_blitz"][0] = "truck";
	
	level.designation["actor_axis_ger_ber_wehr_reg_gewehr43"][0] = "infantry1";
	level.designation["actor_axis_ger_ber_wehr_reg_gewehr43"][1] = "infantry2";
	level.designation["actor_axis_ger_ber_wehr_reg_gewehr43"][2] = "infantry3";
	
	level.designation["actor_axis_ger_ber_wehr_reg_kar98k"][0] = "infantry1";
	level.designation["actor_axis_ger_ber_wehr_reg_kar98k"][1] = "infantry2";
	level.designation["actor_axis_ger_ber_wehr_reg_kar98k"][2] = "infantry3";
	
	level.designation["actor_axis_ger_ber_wehr_reg_panzerschrek"][0] = "infantry1";
	level.designation["actor_axis_ger_ber_wehr_reg_panzerschrek"][1] = "infantry2";
	level.designation["actor_axis_ger_ber_wehr_reg_panzerschrek"][2] = "infantry3";
	
	level.designation["bunker"][0] = "bunker1";
	level.designation["bunker"][1] = "bunker2";
	
	level.designation["guard_tower"][0] = "tower1";
	level.designation["guard_tower"][1] = "tower2";
	level.designation["guard_tower"][2] = "tower3";
	level.designation["guard_tower"][3] = "tower4";
	level.designation["guard_tower"][4] = "tower5";
	level.designation["guard_tower"][5] = "tower6";
	level.designation["guard_tower"][6] = "tower7";
	level.designation["guard_tower"][7] = "tower8";
}

play_player_anim_outro( i, player, anim_node )
{
	//wait( 2 );
	hands = spawn_anim_model( "player_hands" );
	hands.animname = "player_hands";
	if( i != 0 )
	{
		hands Hide();
	}

	hands.origin = anim_node.origin;
	hands.angles = anim_node.angles;
	//hands.attachedplayer = player;
	
	//player thread lerp_player_view_to_tag( hands, "tag_player", 1.75, 1, 0, 0, 0, 0  );
	//player PlayerLinkTo( hands, "tag_player", 1.75, 30, 30, 30, 30 );
	player PlayerLinkTo( hands, "tag_player", 1.75, 0, 0, 0, 0 );
	flag_set( "player_ready_for_outro" );

	//TUEY - Set's music state to LEVEL_END
	setmusicstate("LEVEL_END");

	while( !flag( "player_ready_for_outro" ) || !flag( "outro_group_1_ready" ) || !flag( "outro_group_2_ready" ) )
	{
		wait(0.05);
	}

	anim_node anim_single_solo( hands, "outro" ); 

	//player Unlink();
	hands Delete();
}

#using_animtree( "see2_models" ); 
geo_arty_tarp()
{
	PrecacheModel( "anim_seelow_flak_tarp" );

	level.scr_animtree["arty tarp"] 				= #animtree; 	
	level.scr_model["arty tarp"] 				= "anim_seelow_flak_tarp"; 
	level.scr_anim["arty tarp"]["fire_flap"]	 	= %o_seelow2_flak_tarp;	
	level.scr_animtree["dummy"] 				= #animtree; 	
	level.scr_anim["dummy"]["tank_scan_straight"] = %v_seelow2_t34scan_straight;
	level.scr_anim["dummy"]["tank_scan_right"] = %v_seelow2_t34scan_right;
}

geo_tower_fall()
{
	PrecacheModel( "anim_seelow_radiotower_d" );
	
	level.scr_animtree["radiotower"] = #animtree;
	level.scr_model["radiotower"] = "anim_seelow_radiotower_d";
	level.scr_anim["radiotower"]["fall"] = %o_seelow2_radiotower_dest;
}

deprecated_lines()
{
	level.scr_sound["reznov"]["first_panther1"] = "See2_IGD_012A_REZN"; //"print: Panther - Moving in from the west!";
	level.scr_sound["reznov"]["first_panther2"] = "See2_IGD_013A_REZN"; //"print: Destroy it! The Panther's speed makes it a deadly adversary!";
	level.scr_sound["reznov"]["first_panther4"] = "See2_IGD_015A_REZN"; //"print: Again! Before it targets our position.";
	
	level.scr_sound["commissar"]["depot_obj1"] = "print: Today - we break this line!"; //"See2_IGD_047A_COMM";
	level.scr_sound["commissar"]["depot_obj1"] = "print: Move in to destroy the fuel depot - Cripple their military machine!"; //"See2_IGD_048A_COMM";
	level.scr_sound["reznov"]["tank_fire_tiger"] =  "See2_IGD_507A_REZN";//"print: The hide of the King Tiger is strong - FIRE AGAIN!";
	
	level.scr_sound["reznov"]["north"] = "See2_IGD_512A_REZN"; //"print: North!";
	level.scr_sound["reznov"]["northeast"] = "See2_IGD_513A_REZN"; //"print: Northeast!";
	level.scr_sound["reznov"]["east"] = "See2_IGD_514A_REZN"; //"print: East!";
	level.scr_sound["reznov"]["southeast"] = "See2_IGD_515A_REZN"; //"print: Southeast!";
	level.scr_sound["reznov"]["south"] = "See2_IGD_516A_REZN"; //"print: South!";
	level.scr_sound["reznov"]["southwest"] = "See2_IGD_517A_REZN"; //"print: Southwest!";
	level.scr_sound["reznov"]["west"] = "See2_IGD_518A_REZN"; //"print: West!";
	level.scr_sound["reznov"]["northwest"] = "See2_IGD_519A_REZN"; //"print: northwest!";
	
	level.scr_sound["reznov"]["in_field"] = "See2_IGD_522A_REZN"; //"print: In the field!";
	level.scr_sound["reznov"]["on_hill"] = "See2_IGD_523A_REZN"; //"print: On the hill!";
	level.scr_sound["reznov"]["in_marsh"] = "See2_IGD_524A_REZN"; //"print: In the marshland!";
	
	level.scr_sound["reznov"]["center_map1"] = "See2_IGD_031A_REZN"; //"print: German tanks all around, Dimitri!";
	level.scr_sound["reznov"]["center_map2"] = "See2_IGD_032A_REZN"; //"print: We are vulnerable to attack from all sides!";
	level.scr_sound["reznov"]["center_map3"] = "See2_IGD_033A_REZN"; //"print: Keep Moving!";
}

#using_animtree( "player" );

setup_player_interactive_anims()
{
	level.scr_animtree["player_hands"] = #animtree;
	level.scr_model["player_hands"] = "viewmodel_rus_guard_player";
	level.scr_anim["player_hands"]["outro"] = %int_seelow1_outro_player;
}