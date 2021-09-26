#using_animtree("generic_human");
main()
{	
	
	//animations
	level.scr_anim["left"]["kickdoor"]		= (%crossroads_gatekick);
	
/*		
	level.scr_anim["price"]["talk_temp"][0]				= (%stand_alert_1);
	level.scr_anim["price"]["talk_tempweight"][0]		= 1;
	
	level.scr_anim["soldier1"]["talk_temp"][0]				= (%stand_alert_1);
	level.scr_anim["soldier1"]["talk_tempweight"][0]		= 1;
	
	level.scr_anim["soldier2"]["talk_temp"][0]				= (%stand_alert_1);
	level.scr_anim["soldier2"]["talk_tempweight"][0]		= 1;

	level.scr_anim["price"]["talk_temp2"]				= (%stand_alert_1);
	level.scr_anim["soldier1"]["talk_temp2"]				= (%stand_alert_1);
	level.scr_anim["soldier2"]["talk_temp2"]				= (%stand_alert_1);
	
//	level.scr_anim["price"]["mg42_warning"]				= (%crossroads_mg42stayback);
*/	
	
	level.scr_anim["price"]["letsgo_idle"]				= (%crossroads_letsgo_idle);
	
	level.scr_anim["price"]["wave2run"]				= (%crossroads_letsgo_wave2run);
	

	level.scr_anim["generic"]["signal_left"]				= (%crossroads_corner_wave);



	//Sounds	
	level.scr_sound["plane_1"]			= 	"crossroads_flyby1";
	
	

	//dialogue
	
	//1. Listen up lads! We've been ordered to take the crossroads of
	//this village and hold them until relieved! Let's go.
	level.scrsound["price"]["intro"]		= "cross_pri_introbrief";
	level.scr_anim["price"]["intro"]		= (%crossroads_listenuplads);
	
	//2. MG42! Stay back!!
	//level.scrsound["price"]["stay_back"]		= "cross_pri_stayback";
	
	//BS4: Careful lads! There's an MG42 at the end of this road!
	level.scrsound["generic"]["recon"]		= "cross_bs4_recon";
	level.scr_face["generic"]["recon"] 		= %crossroads_bs4_sc00_02_head;
	
	//Price: Sergeant Davis!!! Secure that building to our rear!!!  Go!!!
	level.scrsound["price"]["secure_ambush"]		= "cross_pri_ambushhouse";
	level.scr_face["price"]["secure_ambush"] 		= %crossroads_pri_sc02a_01_head;
	
	//BS 3: Bloody hell - Tiger taaaank!!!!!
	level.scrsound["generic"]["bloody_hell"]		= "cross_tigertank";
	
	//Price: Sergeant Davis!!! Find an anti-tank weapon and take out that tank! Go!
	level.scrsound["price"]["find_antitank"]		= "cross_pri_findatweapon";
	level.scr_face["price"]["find_antitank"] 		= %crossroads_pri_sc09a_07_head;
	
	//3. Flank left through that building! Take that bloody thing out!
	level.scrsound["price"]["flank_left"]		= "cross_pri_flankbuilding";
	
	//4. Davis! Strike through those buildings on the left!
	level.scrsound["price"]["flank_left2"]		= "cross_pri_davisstrike";
	level.scr_face["price"]["flank_left2"] 		= %crossroads_pri_sc03_01_t1_head;
	
	//5. Give him covering fire!
	level.scrsound["price"]["give_covering_fire"]		= "cross_pri_coveringfire";
	level.scr_face["price"]["give_covering_fire"] 		= %crossroads_pri_sc03_02_t1_head;
	
	//Price: That crossroads up ahead is our objective.
	level.scrsound["price"]["crossroads_ahead"]		= "cross_pri_crossroadisobjective";
	
	//Price: Get behind something! Enemy armor approaching from the crossroads!
	level.scrsound["price"]["get_behind"]		= "cross_pri_getbehindsomething";
	level.scr_face["price"]["get_behind"] 		= %crossroads_pri_sc04_02_t1_head;
	 
	//Price: Private, take out that halftrack!!!
	level.scrsound["price"]["ht_kill"]		= "cross_pri_halftrackkill";
	
	//BS1: Right away sir!
	level.scrsound["generic"]["yes_sir"]		= "cross_bs1_yessir";
	
	//Price: Well that's a spot of luck!
	level.scrsound["price"]["spot_of_luck"]		= "cross_pri_spotofluck";
	
	//BS4: They're falling back! We've held the crossroads!!!
	level.scrsound["generic"]["falling_back"]		= "cross_bs4_fallingback";
	level.scr_face["generic"]["falling_back"] 		= %crossroads_bs4_sc10a_01_head;

	//Price: That farm house controls this crossroads.
	// This uses a full body animation
	level.scrsound["price"]["farm_house"]		= "cross_pri_farmhousecontrols";
	level.scr_face["price"]["farm_house"] 		= %crossroads_pri_sc07_01_t1_head;
	
	
	//Price: Davis! Take some of the lads and check that farm house for Fritz.
	level.scrsound["price"]["take_some_lads"]		= "cross_pri_davisfarmhouse";
	level.scr_anim["price"]["take_some_lads"] 		= %crossroads_pri_sc07_02_t2_head;
	 
	
	//11. BS 1: Look out! Ambush!
	level.scrsound["soldier1"]["ambush"]		= "cross_bs1_lookambush";
	
	//12. BS 2: MG42 in the window!
	level.scrsound["soldier2"]["mg42_window"]		= "cross_bs2_mg42";
	
	//Price: Squad, deploy a smokescreen and move in! Take control of that farmhouse, move, move!!!!  
	level.scrsound["price"]["farmMg42"]		= "cross_pri_farmmg42";
	level.scr_face["price"]["farmMg42"] 		= %crossroads_pri_sc07_03_head;
	 	
	//BS 3: The house is clear!
	level.scrsound["soldier3"]["house_clear"]		= "cross_bs3_houseisclear";
	
	//Price: Good. Now check the barn.
	level.scrsound["price"]["check_barn"]		= "cross_pri_checkbarn";
	
	//Price: Sergeant Davis! Search the barn for enemy radios and put them out of commission! 
	level.scrsound["price"]["barn_radio"]		= "cross_pri_barnradio";
	level.scr_face["price"]["barn_radio"] 		= %crossroads_pri_sc09_03_head;
	
	
	//BS4: Counterattaaack!!! Enemy approaching across the road!!!
	level.scrsound["soldier4"]["counter_attack2"]		= "cross_counterattack_warning2";
	
	//BS3: Jerries moving in from the west!!!
	level.scrsound["soldier3"]["counter_attack"]		= "cross_counterattack_warning";
	
	//Price: Take up defensive positions lads!! Hold them off until the convoy arrives!!! 
	level.scrsound["price"]["def_positions"]		= "cross_pri_counterattack";
	
	//Price: Sergeant Davis! Get on the German machine gun! Move!!
	level.scrsound["price"]["use_mg"]		= "cross_pri_usemg";	
	
	//Tiger tank coming down the road from the north!!!
	level.scrsound["soldier1"]["panzer_tank"]		= "cross_bs3_firsttiger";
	
	//18. That tank is going to blow us away!
	level.scrsound["soldier3"]["blow_us_away"]		= "cross_bs3_blowusaway";
	
	//19. What do we do?!
	level.scrsound["soldier4"]["what_do_we_do"]		= "cross_bs4_dowedo";
	
	//20. We should run!
	level.scrsound["soldier2"]["we_should_run"]		= "cross_bs2_shouldrun";
	
	//21. Yea! Its gonna kill us all!
	level.scrsound["soldier3"]["gonna_kill_us"]		= "cross_bs3_gonnakillus";
	
	//Price: Shut it
	level.scrsound["price"]["shut_it"]		= "cross_pri_shutit";
	
	//Price: Keep quiet!
	level.scrsound["price"]["keep_quiet"]		= "cross_pri_keepquiet";
	
	//Price: We run when I bloody say we run! No sooner!
	level.scrsound["price"]["we_run"]		= "cross_pri_runwhenisay";
	
	//23. That's got him!
	level.scrsound["soldier1"]["thats_got_him"]		= "cross_bs1_thatsgothim";
	
	//Price: God bless the bloody RAF!
	level.scrsound["price"]["god_bless"]		= "cross_pri_godbless";
	
	//Price: Lads! Listen up! We're pulling out!
	level.scrsound["price"]["pulling_out"]		= "cross_pri_pullingout";
	level.scr_face["price"]["pulling_out"] 		= %crossroads_pri_sc12_01_t1_head;	
	
	//Price: All right, everyone regroup at the crossroads! Let's go!
	level.scrsound["price"]["meet_convoy"]		= "cross_pri_meetconvoy";
	level.scr_face["price"]["meet_convoy"] 		= %crossroads_pri_sc01a_02_head;
	
	//price: Well done lads. We're to escort the tanks through the next town. 
	//       More Jerry armor's been spotted moving around to the north, so be on your guard. 
	//		 All right, let's get moving.
	level.scrsound["price"]["outro"]		= "cross_pri_outro";
	level.scr_face["price"]["outro"] 		= %crossroads_pri_sc14_01_head;
	
	
	
}

