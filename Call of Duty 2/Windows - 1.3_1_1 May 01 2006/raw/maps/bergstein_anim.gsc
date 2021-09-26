#using_animtree("generic_human");
main()
{	
	
	//animations
	level.scr_anim["left"]["kickdoor"]		= (%kickdoor_guy2);
	
	
	//Randall setting up the door kick	
	level.scr_anim["randall"]["randall_doorkick_yell"]		= (%bergstein_doorkick_sgt_yell);
	
	level.scr_notetrack["randall"][0]["notetrack"]		= "dialogue01";
	level.scr_notetrack["randall"][0]["dialogue"]				= "Bergstein_rnd_onmycommand";
	
	level.scr_notetrack["randall"][1]["notetrack"]		= "dialogue02";
	level.scr_notetrack["randall"][1]["dialogue"]				= "Bergstein_rnd_ready";
	
	level.scr_notetrack["randall"][2]["notetrack"]		= "start_kick_anim";

	level.scr_notetrack["randall"][3]["notetrack"]		= "dialogue03";
	level.scr_notetrack["randall"][3]["dialogue"]				= "Bergstein_rnd_now";
	
	level.scr_anim["kicker"]["fh_kickdoor"]		= (%bergstein_doorkick_kicker_kick);
	
	//run to door
	level.scr_anim["randall"]["run_to_door"]		= (%bergstein_doorkick_sgt_yell);
	level.scr_anim["kicker"]["run_to_door"]		= (%bergstein_doorkick_kicker_kick);
	level.scr_anim["grenade_guy"]["run_to_door"]		= (%corner_left_crouch_alertidle);
	
	//grenade guy animations
	level.scr_anim["grenade_guy"]["grenade_idle"][0]		= (%corner_left_crouch_alertidle);
	level.scr_anim["grenade_guy"]["grenade_idle"][1]		= (%corner_left_crouch_alerttwitch1);
	level.scr_anim["grenade_guy"]["grenade_idle"][2]		= (%corner_left_crouch_alerttwitch2);
	
	level.scr_anim["grenade_guy"]["grenade_throw_crouch"]	= %corner_left_crouch_alertgrenadeleft;
	
	//Randall grenade throw
	level.scr_anim["randall"]["smoke_throw"]	= %crouch_grenade_throw;
	
	
	//gate kick, Price end of level
	level.scr_anim["generic"]["gatekick"]		= (%crossroads_gatekick);
	
	//randalls outro speech animation
	
	
	
	//***********************
	//Dialogue
	//***********************

	//randall smoke grenade BC 
	level.scrsound["randall"]["smoke_screen"]		= "US_0_order_action_smoke";

	// Randall: Battalion wants us freezing our asses off on top of that hill by the end of tomorrow. 
	// But first we've got to kick Jerry out of this cute little town.
	level.scrsound["randall"]["intro"]		= "Bergstein_rnd_battalionwants";
	level.scr_face["randall"]["intro"] 		= %bergstein_rnd_sc01_01_t2_head;
	
	// Randall: This house is clear, move on to the next one!
	level.scrsound["randall"]["house_clear1"]		= "Bergstein_rnd_houseisclear";
	
	// Randall: House cleared, let's go!
	level.scrsound["randall"]["house_clear2"]		= "Bergstein_rnd_housecleared";
	
	//Randall:  Private, get the 30cal set up in that window and lay down suppressing fire!!! 
	level.scrsound["randall"]["setupMG"]		= "bergstein_rnd_setupmg";
	
	//Ranger 1: Yes Sir!
	level.scrsound["ranger1"]["yes_sir"]		= "bergstein_gr1_yessir";
	
	// Randall: Okay, we cleared this house!
	level.scrsound["randall"]["house_clear3"]		= "Bergstein_rnd_okwecleared";

	// Randall: First squad! Regroup at the road block!
	level.scrsound["randall"]["regroup"]		= "Bergstein_rnd_firstsquad";
	
	// Randall: All right. This road's blocked off. 
	// We're gonna to have to cut east. Let's go.
	level.scrsound["randall"]["blocked"]		= "Bergstein_rnd_roadsblockedoff";
	level.scr_face["randall"]["blocked"] 		= %bergstein_rnd_sc05_02_t1_head;
	
	// Randall: Mortars!
	level.scrsound["randall"]["mortars"]		= "Bergstein_rnd_mortars";
	
	//Randall: Don't stop!
	level.scrsound["randall"]["dont_stop"]		= "Bergstein_rnd_dontstop";
	
	//Randall: Keep moving!
	level.scrsound["randall"]["keep_moving"]		= "Bergstein_rnd_keepmoving";
	
	//Randall: More Krauts in that house to the east!! Taylor! Move up!! 
	//		   Use your grenades and clear that house room by room!!! Go! 
	level.scrsound["randall"]["eastHP"]		= "bergstein_rnd_easthardpoint";
	
	//Randall: Good work, now let's head north to those enemy mortars!
	level.scrsound["randall"]["good_work"]		= "Bergstein_rnd_goodwork";
	
	//Ranger 1: Look out, MG42!
	level.scrsound["ranger1"]["look_out"]		= "Bergstein_gr1_lookoutmg42";

	//Ranger 2: MG42, get back!
	level.scrsound["ranger2"]["get_back"]		= "Bergstein_gr2_mg42getback";
	
	//Randall: Taylor, move up there and take out that MG42.
	level.scrsound["randall"]["takeout_mg42"]		= "Bergstein_rnd_takeoutmg42";
	
	//Randall: Let's go Taylor, get moving.
	level.scrsound["randall"]["lets_go"]		= "Bergstein_rnd_letsgotaylor";
	
	//Randall: Squad, move up! Nice work, Taylor.
	level.scrsound["german"]["move_up"]		= "Bergstein_rnd_squadmoveup";
	
	//German:
	level.scrsound["german"]["holedup1"]		= "bergstein_german_holedup1";
	
	//German
	level.scrsound["german"]["holedup2"]		= "bergstein_german_holedup2";
	
	//German
	level.scrsound["german"]["holedup3"]		= "bergstein_german_holedup3";
	
	//German
	level.scrsound["german"]["holedup4"]		= "bergstein_german_holedup4";
	
	// Randall: Listen up! We've got to clear this house. 
	level.scrsound["randall"]["listen_up"]		= "Bergstein_rnd_listenup";
	level.scr_face["randall"]["listen_up"] 		= %bergstein_rnd_sc10_01_t3_head;
	
	//Randall: On my command, kick open the door and frag those krauts.
	level.scrsound["randall"]["on_my_command"]		= "Bergstein_rnd_onmycommand";
	level.scr_face["randall"]["on_my_command"] 		= %bergstein_rnd_sc10_02_t4_head;
	
	//Randall: Ready?
	level.scrsound["randall"]["ready"]		= "Bergstein_rnd_ready";
	level.scr_face["randall"]["ready"] 		= %bergstein_rnd_sc10_03_t2_head;
	
	//Randall: Now!
	level.scrsound["randall"]["now"]		= "Bergstein_rnd_now";
	level.scr_face["randall"]["now"] 		= %bergstein_rnd_sc11_01_t2_head;
	
	//Randall: Go go go!
	level.scrsound["randall"]["go"]		= "Bergstein_rnd_gogogo";
	level.scr_face["randall"]["go"] 		= %bergstein_rnd_sc12_01_t1_head;
	
	//Ranger5: Kraut mortar in the church yard!
	level.scrsound["ranger1"]["kraut_mortar"]		= "bergstein_gr5_churchmortar";
	
	//Randall: Silence out those mortars! 
	level.scrsound["randall"]["silence_mortars"]		= "Bergstein_rnd_silencemortars";
	
	//Randall: I want those mortars taken out!
	level.scrsound["randall"]["mortars_takenOut"]		= "Bergstein_rnd_iwantmortars";
	
	//Randall: Corporal Taylor, take out that panzerwerfer! Move!!
	level.scrsound["randall"]["panzerwerfer"]		= "bergstein_rnd_killpanzerwerf";
	
	//Randall: All right, move in! Secure the church!!
	level.scrsound["randall"]["secure_church"]		= "bergstein_rnd_enterchurch";
		
	//Randall: We've got to clear that church. Taylor, take point!
	level.scrsound["randall"]["clear_church"]		= "Bergstein_rnd_gottaclearchurch";
	
	//Randall: All right fellas, ....	 
	level.scrsound["randall"]["outro"]		= "Bergstein_rnd_alrightfellas";
	
	//animation
	level.scr_anim["randall"]["outro_anim"]		= (%bergstein_end_dialogue);

	//Ranger1: 3rd squad! Spread out!
	level.scrsound["g_ranger1"]["backup1"]		= "bergstein_ranger_backup1";	
	
	//Ranger2: I want the .30 cal right over here!
	level.scrsound["g_ranger2"]["backup2"]		= "bergstein_ranger_backup2";	
	
	//Ranger3: 3Put some guards on the intersection!
	level.scrsound["g_ranger3"]["backup3"]		= "bergstein_ranger_backup3";	
	
	//Ranger4: Search those bodies for intel!
	level.scrsound["g_ranger4"]["backup4"]		= "bergstein_ranger_backup4";	
	
	//Ranger5: Tie up the flanks!
	level.scrsound["g_ranger5"]["backup5"]		= "bergstein_ranger_backup5";	
	
	//Ranger6: Private! Let’s check out that roadblock! Follow me!
	level.scrsound["g_ranger6"]["backup6"]		= "bergstein_ranger_backup6";	


/* CUT

	//Ranger 1: Jerries over by that 88!
	level.scrsound["ranger1"]["jerries_by_88"]		= "Bergstein_gr1_jerriesby88";
	
	//Randall: Heads up, Jerry in the church yard!
	level.scrsound["randall"]["heads_up"]		= "Bergstein_rnd_headsup";
	
	//Ranger 2: They're using the 88 against us!
	level.scrsound["ranger2"]["using_88"]		= "Bergstein_gr2_againstus";
	
	//Ranger 2: Get downstairs! Take cover!
	level.scrsound["ranger2"]["get_downstairs"]		= "Bergstein_gr2_getdownstairs";
	
	//Randall: They're shooting at us with that 88!
	level.scrsound["randall"]["shooting_at_us"]		= "Bergstein_rnd_theyreshooting";


*/



}