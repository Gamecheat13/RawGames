#include maps\_utility;
#include common_scripts\utility;
#include maps\_audio;

#using_animtree("generic_human");

main()
{
	// general
	flag_init( "dialogue_in_progress" );
	
	// river dialogue
	flag_init( "intro_line_1" );
	flag_init( "intro_line_2" );
	flag_init( "river_dialogue" );
	flag_init( "river_intro_vo_done" );
	flag_init( "dont_be_stupid_dialogue" );
	flag_init( "river_technical_dialogue" );
	flag_init( "second_beat_move_dialogue" );
	flag_init( "river_technicals_move_dialogue" );
	flag_init( "prone_encounter_start_dialogue" );
	flag_init( "prone_encounter_well_done_dialogue" );
	flag_init( "tire_necklace_dialogue" );
	flag_init( "off_the_road_dialogue" );
	flag_init( "river_big_moment_done_dialogue" );
	flag_init( "river_spotted_dialogue" );
	flag_init( "church_mouse_dialogue" );
	flag_init( "bridge_go_loud_dialogue" );
	flag_init( "bridge_guys_dead_dialogue" );
	flag_init( "victim_burn_vo" );
	flag_init( "technical_steal_broken_vo" );
	
	// infiltration/advance dialogue
	flag_init( "cover_us_dialogue" );
	flag_init( "multiple_guards_dialogue" );
	flag_init( "more_militia_dialogue" );
	flag_init( "push_forward_dialogue" );
	flag_init( "rally_on_me_dialogue" );
	flag_init( "go_noisy_dialogue" );
	flag_init( "inf_both_moving_dialogue" );
	flag_init( "large_militia_dialogue" );
	flag_init( "inf_spotted_dialogue" );
	flag_init( "large_group_dialogue" );
	flag_init( "breaching_factory_dialogue" );
	flag_init( "breaching_factory_dialogue_done" );
	flag_init( "inf_encounter_2_vo_done" );
	flag_init( "inf_nice_shot_vo" );
	flag_init( "no_ak_vo" );
	
	// technical
	flag_init( "player_technical_dialogue" );
	flag_init( "technical_1_dialogue" );
	flag_init( "roof_right_dialogue" );
	flag_init( "contact_front_1_dialogue" );
	flag_init( "contact_left_1_dialogue" );
	flag_init( "contact_left_2_dialogue" );
	flag_init( "technical_2_dialogue" );
	flag_init( "contact_front_2_dialogue" );
	flag_init( "contact_right_1_dialogue" );
	flag_init( "contact_left_3_dialogue" );
	flag_init( "contact_left_4_dialogue" );
	flag_init( "contact_front_3_dialogue" );
	flag_init( "technical_ahead_dialogue" );
	flag_init( "militia_vo_done" );
	
	// mortar run
	flag_init( "mortar_run_dialogue" );
	flag_init( "mortar_door_dialogue" );
	flag_init( "mortar_roof_fall_dialogue" );
	
	// player mortar
	flag_init( "head_to_mortar_dialogue" );
	flag_init( "keep_firing_mortar" );
	flag_init( "regroup_dialogue" );
	flag_init( "mortar_targets_dialogue" );
	
	// assault / super tech
	flag_init( "house_door_dialogue" );
	flag_init( "player_rpg_dialogue" );
	
	// warlord / protect
	flag_init( "getting_away_dialogue" );
	flag_init( "cleanupcrew_dialogue" );
	flag_init( "defensive_positions_dialogue" );
	flag_init( "secure_dialogue" );
	flag_init( "beautiful_relationship_dialogue" );
	flag_init( "money_wired_dialogue" );
	flag_init( "fast_pay_dialogue" );
	flag_init( "confrontation_vo_finished" );
	
	// unused?
	flag_init( "church_breach_ally_dialogue" );
	
	level.vo_interupt = false;
	
	prepare_dialogue();
	thread play_dialogue();
}

prepare_dialogue()
{
	// scene 1
	//Nikolai: Copy.  I'll pick you up in one hour.
	level.scr_radio[ "warlord_nik_onehour" ]		= "warlord_nik_onehour";
	
	//Maintain a low profile.  The militia's all over this area
	level.scr_sound[ "soap" ][ "warlord_pri_lowprofile" ] = "warlord_pri_lowprofile";
	
	//Price: Soap, try not to die this time.
	level.scr_sound[ "price" ][ "warlord_pri_trynottodie" ]		= "warlord_pri_trynottodie";
	
	//Soap: You worry 'bout yourself, old man.
	level.scr_sound[ "soap" ][ "warlord_mct_rogerthat" ]		= "warlord_mct_rogerthat";
	
	//Soap: So much for stealth.
	level.scr_sound[ "soap" ][ "warlord_pri_somuch" ]		= "warlord_pri_somuch";


	//Is everyone dead?
	level.scr_sound[ "militia" ][ "warlord_mlt1_everyonedead" ] = "warlord_mlt1_everyonedead";
	
	//Most but not all.
	level.scr_sound[ "militia" ][ "warlord_mlt2_notall" ] = "warlord_mlt2_notall";
	
	//Find the others.
	level.scr_sound[ "militia" ][ "warlord_mlt1_findothers" ] = "warlord_mlt1_findothers";
	
	//Tangos approaching.
	level.scr_sound[ "soap" ][ "warlord_mct_tangosapproaching" ] = "warlord_mct_tangosapproaching";
	
	//Duck.
	level.scr_sound[ "price" ][ "warlord_pri_duck" ] = "warlord_pri_duck";
	
	//Move.
	level.scr_sound[ "price" ][ "warlord_pri_move3" ] = "warlord_pri_move3";
	
	//Two x-rays, nine o'clock. Yuri, take the shot.
	level.scr_sound[ "soap" ][ "warlord_pri_twoxrays" ] = "warlord_pri_twoxrays";
	
	//Well done, Yuri.
	level.scr_sound[ "price" ][ "warlord_pri_welldoneyuri" ] = "warlord_pri_welldoneyuri";
	
	//Soap: Clear.
	level.scr_sound[ "soap" ][ "warlord_mct_clear2" ]		= "warlord_mct_clear2";

	
	//Militia 1: Did you know Hadams was killed last week?
	level.scr_sound[ "militia" ][ "warlord_mlt1_didyouknow" ]		= "warlord_mlt1_didyouknow";
	//Militia 2: Oh really?
	level.scr_sound[ "militia" ][ "warlord_mlt2_ohreally" ]		= "warlord_mlt2_ohreally";
	//Militia 1: Walked right into the middle of one of Waraabe's foreign deals.
	level.scr_sound[ "militia" ][ "warlord_mlt1_walkedright" ]		= "warlord_mlt1_walkedright";
	//Militia 1: Waraabe popped him twice without even looking.
	level.scr_sound[ "militia" ][ "warlord_mlt1_poppedhim" ]		= "warlord_mlt1_poppedhim";
	//Militia 3: No shit! Yeah, Hadams was an idiot.
	level.scr_sound[ "militia" ][ "warlord_mlt3_wasanidiot" ]		= "warlord_mlt3_wasanidiot";
	
	//Militia 1: Why'd they have to start this shit on my birthday?
	level.scr_sound[ "militia" ][ "warlord_mlt1_whydidthey" ]		= "warlord_mlt1_whydidthey";
	//Militia 3: I'd rather be here than at home eating my wife's cooking any day.
	level.scr_sound[ "militia" ][ "warlord_mlt3_ratherbehere" ]		= "warlord_mlt3_ratherbehere";
	//Militia 1: That's true…I've had your wife's cooking.
	level.scr_sound[ "militia" ][ "warlord_mlt1_thatstrue" ]		= "warlord_mlt1_thatstrue";
	//Militia 3: How much longer do we have to be out here?
	level.scr_sound[ "militia" ][ "warlord_mlt3_howmuch" ]		= "warlord_mlt3_howmuch";
	//Militia 1: Until I finish this cigarette..*laugh*
	level.scr_sound[ "militia" ][ "warlord_mlt1_cigarette" ]		= "warlord_mlt1_cigarette";
	//Militia 3: Well then make that last a few hours, ok?
	level.scr_sound[ "militia" ][ "warlord_mlt3_makeitlast" ]		= "warlord_mlt3_makeitlast";
	//Militia 1: You're a son of a bitch, you know that?
	level.scr_sound[ "militia" ][ "warlord_mlt1_sob" ]		= "warlord_mlt1_sob";
	//Militia 3: But your wife loves me!
	level.scr_sound[ "militia" ][ "warlord_mlt3_butyourwife" ]		= "warlord_mlt3_butyourwife";


	
	// scene 2
	
	//Militia 2: You thought you could outsmart us? Hide from us?
	level.scr_sound[ "militia" ][ "warlord_mlt2_outsmart" ]		= "warlord_mlt2_outsmart";
	//Civilian: No! No, it's not like that please…
	level.scr_sound[ "victim" ][ "warlord_civ_notlikethat" ]		= "warlord_civ_notlikethat";
	//Civilian: NOOOO!!! AHHHH! (Pain screams)
	level.scr_sound[ "victim" ][ "warlord_civ_scream" ]		= "warlord_civ_scream";

	//Price: We'll handle them later.  Focus on staying alive.
	level.scr_sound[ "price" ][ "warlord_pri_handlethemlater" ]		= "warlord_pri_handlethemlater";


	//Militia 2: Did you think we wouldn't find you?
	level.scr_sound[ "militia_1" ][ "warlord_mlt2_wouldnt" ]		= "warlord_mlt2_wouldnt";
	//Civilian: Please, my family… they need me!
	level.scr_sound[ "civ_1" ][ "warlord_civ_myfamily" ]		= "warlord_civ_myfamily";
	//Militia 2: It's time to pay the price.
	level.scr_sound[ "militia_1" ][ "warlord_mlt2_timetopay" ]		= "warlord_mlt2_timetopay";
	//Civilian: No, no, I'll do whatever you want! Please!
	level.scr_sound[ "civ_3" ][ "warlord_civ_noplease" ]		= "warlord_civ_noplease";
	//Militia 2: Waraabe is not a forgiving man. You should have given him what he wanted.
	level.scr_sound[ "militia_1" ][ "warlord_mlt2_whathewanted" ]		= "warlord_mlt2_whathewanted";
	
	//Hold your fire.  There's too many of them.
	level.scr_sound[ "price" ][ "warlord_pri_toomany" ] = "warlord_pri_toomany";
	
	//Soap: Looks like an execution. Want to intervene?
	level.scr_sound[ "soap" ][ "warlord_mct_execution" ]		= "warlord_mct_execution";

	//Price: Your call, Yuri.
	level.scr_sound[ "price" ][ "warlord_pri_yourcall" ]		= "warlord_pri_yourcall";
	
		//Soap: Bastards.
	level.scr_sound[ "soap" ][ "warlord_mct_bastards" ]		= "warlord_mct_bastards";

	
	//Take them out.
	level.scr_sound[ "price" ][ "warlord_pri_takethemout" ] = "warlord_pri_takethemout";
	
	//Don't do anything stupid lads.
	level.scr_sound[ "price" ][ "warlord_pri_bastards" ] = "warlord_pri_bastards";
	
	//Move up.
	level.scr_sound[ "price" ][ "warlord_pri_moveup2" ] = "warlord_pri_moveup2";
	
	//Price: Alright, get ready…
	level.scr_sound[ "price" ][ "warlord_pri_alrightgetready" ]		= "warlord_pri_alrightgetready";

	//Price: Get down!  Now!
	level.scr_sound[ "price" ][ "warlord_pri_getdownnow" ]		= "warlord_pri_getdownnow";

	
	//Get down! Get off the road!
	level.scr_sound[ "price" ][ "warlord_pri_getoffroad" ] = "warlord_pri_getoffroad";
	
	//Easy…
	level.scr_sound[ "price" ][ "warlord_pri_easy" ] = "warlord_pri_easy";
	
	//The witch doctor said a storm is coming.
	level.scr_sound[ "militia" ][ "warlord_mlt1_stormcoming" ] = "warlord_mlt1_stormcoming";
	
	//Did he say when?
	level.scr_sound[ "militia" ][ "warlord_mlt2_saywhen" ] = "warlord_mlt2_saywhen";
	
	//Today.
	level.scr_sound[ "militia" ][ "warlord_mlt1_today" ] = "warlord_mlt1_today";
	
	//All clear.
	level.scr_sound[ "price" ][ "warlord_pri_allclear" ] = "warlord_pri_allclear";
	
	// scene 3
	//Soap: Hold up.
	level.scr_sound[ "soap" ][ "warlord_mct_holdup" ]		= "warlord_mct_holdup";
	//Soap: Two more on the bridge.  We'll have to take them down.
	level.scr_sound[ "soap" ][ "warlord_mct_2moreonbridge" ]		= "warlord_mct_2moreonbridge";


	//Hostiles - on the bridge.  Wait for the truck to pass.
	level.scr_sound[ "price" ][ "warlord_pri_waitfortruck" ] = "warlord_pri_waitfortruck";
	
	//Drop'em.
	level.scr_sound[ "price" ][ "warlord_pri_dropem" ] = "warlord_pri_dropem";
	
	//Move up.
	level.scr_sound[ "price" ][ "warlord_pri_moveup" ] = "warlord_pri_moveup";
	
	// scene 4
	//Price: Makarov's in the factory up the road.
	level.scr_sound[ "soap" ][ "warlord_pri_uptheroad" ]		= "warlord_pri_uptheroad";
	
	
	//Yuri, you’re on overwatch. Take up a position on the roof and cover us.
	level.scr_sound[ "price" ][ "warlord_pri_coverus" ] = "warlord_pri_coverus";
	
	//Yuri, get up the ladder.
	level.scr_sound[ "price" ][ "warlord_pri_getupladder" ] = "warlord_pri_getupladder";
	
	//Yuri, get in position.
	level.scr_sound[ "price" ][ "warlord_pri_getinposition" ] = "warlord_pri_getinposition";
	
	// scene 5
	
	//Two hosites approaching, 5 meters.
	level.scr_sound[ "price" ][ "warlord_pri_twohostiles" ] = "warlord_pri_twohostiles";
	
	//I've got multiple guards approaching.  Take them down.
	level.scr_sound[ "soap" ][ "warlord_pri_multipleguards" ] = "warlord_pri_multipleguards";
	
	//Militia approaching on the roads.
	level.scr_sound[ "price" ][ "warlord_pri_militia" ] = "warlord_pri_militia";	
	
	//Bounding up.
	level.scr_sound[ "soap" ][ "warlord_mct_boundingup" ] = "warlord_mct_boundingup";
	
	//Moving.
	level.scr_sound[ "price" ][ "warlord_pri_moving" ] = "warlord_pri_moving";

	
	//Move!
	level.scr_sound[ "price" ][ "warlord_pri_move2" ] = "warlord_pri_move2";
	
	//Moving.
	level.scr_sound[ "soap" ][ "warlord_mct_moving" ] = "warlord_mct_moving";
	
	//Bounding.
	level.scr_sound[ "price" ][ "warlord_pri_bounding" ] = "warlord_pri_bounding";
	
	//Bounding.
	level.scr_sound[ "soap" ][ "warlord_mct_bounding2" ] = "warlord_mct_bounding2";
	
	// scene 6

	// scene 7
	

	// scene 8
	//Breaching the factory now.
	level.scr_sound[ "price" ][ "warlord_pri_breachingfactory" ] = "warlord_pri_breachingfactory";
	
	//Clear.
	level.scr_sound[ "price" ][ "warlord_mct_clear" ] = "warlord_mct_clear";
	//Soap: Clear?  The place is bloody empty.
	level.scr_sound[ "soap" ][ "warlord_mct_bloodyempty" ]		= "warlord_mct_bloodyempty";
	//Price: Nikolai, dry hole at the factory. Makarov isn't here.
	level.scr_radio[ "warlord_pri_dryhole" ]		= "warlord_pri_dryhole";
	//Nikolai: He must have moved to the militia's headquarters at the center of town.
	level.scr_radio[ "warlord_kgr_rvthere" ]		= "warlord_kgr_rvthere";
	//Price: We're moving there now.
	level.scr_sound[ "price" ][ "warlord_pri_hopetheydid" ]		= "warlord_pri_hopetheydid";

	
	//Heads up - we've got company.
	level.scr_sound[ "soap" ][ "warlord_mct_headsup" ] = "warlord_mct_headsup";

	// scene 9
	//We're compromised!  
	level.scr_sound[ "price" ][ "warlord_pri_compromised" ] = "warlord_pri_compromised";
	
	//Yuri, run!
	level.scr_sound[ "price" ][ "warlord_pri_yurirun" ] = "warlord_pri_yurirun";
	
	//Rally on me!
	level.scr_sound[ "price" ][ "warlord_pri_rallyonme2" ] = "warlord_pri_rallyonme2";
	
	//Yuri, push forward.
	level.scr_sound[ "price" ][ "warlord_pri_pushforward" ] = "warlord_pri_pushforward";
	
	//Contact Front!
	level.scr_sound[ "price" ][ "warlord_pri_contactfront" ] = "warlord_pri_contactfront";
	
	//Magazine!
	level.scr_sound[ "price" ][ "warlord_pri_magazine" ] = "warlord_pri_magazine";
	
	//Switch to your AK.
	level.scr_sound[ "price" ][ "warlord_pri_switchtoak" ] = "warlord_pri_switchtoak";
	
	//Changing mags!
	level.scr_sound[ "soap" ][ "warlord_mct_changingmags" ] = "warlord_mct_changingmags";
	
	//Magazine!
	level.scr_sound[ "soap" ][ "warlord_mct_magazine" ] = "warlord_mct_magazine";
	
	//Soap: Through here!  Let's go!
	level.scr_sound[ "soap" ][ "warlord_mct_throughhere" ]		= "warlord_mct_throughhere";
	//Soap: I think they know we're here.
	level.scr_sound[ "soap" ][ "warlord_mct_theyknow" ]		= "warlord_mct_theyknow";
	//Price: All that matters is Makarov's cargo.  Keep moving.
	level.scr_sound[ "price" ][ "warlord_pri_makarovscargo" ]		= "warlord_pri_makarovscargo";


	// scene 10
	//Technical dead ahead!
	level.scr_sound[ "price" ][ "warlord_pri_technical" ] = "warlord_pri_technical";
	
	//Yuri, man the 50-cal and lay down cover fire!
	level.scr_sound[ "price" ][ "warlord_pri_man50cal" ] = "warlord_pri_man50cal";
	
	//Yuri, get on that 50!
	level.scr_sound[ "price" ][ "warlord_pri_geton50" ] = "warlord_pri_geton50";
	
	//Rooftop on the right!
	level.scr_sound[ "price" ][ "warlord_pri_enemyrooftop" ] = "warlord_pri_enemyrooftop";
	
	//Enemy, rooftop, right!
	level.scr_sound[ "price" ][ "warlord_pri_enemyrooftop" ] = "warlord_pri_enemyrooftop";
	
	//Contact Left! 
	level.scr_sound[ "price" ][ "warlord_pri_contactleft" ] = "warlord_pri_contactleft";
	
	//Enemy technical incoming!  Take it out!
	level.scr_sound[ "price" ][ "warlord_pri_technicalincoming" ] = "warlord_pri_technicalincoming";
	
	//Put fire on the technical!
	level.scr_sound[ "price" ][ "warlord_pri_putfire" ] = "warlord_pri_putfire";
	
	//Contact left! 
	level.scr_sound[ "soap" ][ "warlord_mct_contactleft" ] = "warlord_mct_contactleft";
	
	//Right, right!
	level.scr_sound[ "soap" ][ "warlord_mct_rightright" ] = "warlord_mct_rightright";
	
	//Yuri, over here!
	level.scr_sound[ "price" ][ "warlord_pri_yurioverhere" ] = "warlord_pri_yurioverhere";
	
	
	//Mortar fire inbound!
	level.scr_sound[ "soap" ][ "warlord_mct_mortarfire" ] = "warlord_mct_mortarfire";
	
	//The whole militia is headed straight for us!
	level.scr_sound[ "soap" ][ "warlord_mct_wholemilitia" ] = "warlord_mct_wholemilitia";

	// scene 11
	
	//Go, go, go! 
	level.scr_sound[ "price" ][ "warlord_pri_gogogo" ] = "warlord_pri_gogogo";

	//Don’t stop moving. Or they'll dial us in!
	level.scr_sound[ "price" ][ "warlord_pri_triangulating" ] = "warlord_pri_triangulating";
	
	//Move!
	level.scr_sound[ "price" ][ "warlord_pri_move" ] = "warlord_pri_move";
	
	//Keep moving!
	level.scr_sound[ "price" ][ "warlord_pri_keepmoving" ] = "warlord_pri_keepmoving";
	
	//Go!
	level.scr_sound[ "price" ][ "warlord_pri_go2" ] = "warlord_pri_go2";
	
	//Run!
	level.scr_sound[ "price" ][ "warlord_pri_run" ] = "warlord_pri_run";
	
	//Don't stop moving!
	level.scr_sound[ "price" ][ "warlord_pri_dontstopmoving" ] = "warlord_pri_dontstopmoving";
	
	//Mortar, incoming!
	level.scr_sound[ "price" ][ "warlord_pri_mortarincoming" ] = "warlord_pri_mortarincoming";
	
	//Incoming left!
	level.scr_sound[ "price" ][ "warlord_pri_incomingleft" ] = "warlord_pri_incomingleft";
	
	//Mortar incoming left!
	level.scr_sound[ "price" ][ "warlord_pri_mortarleft" ] = "warlord_pri_mortarleft";
	
	//Incoming right!
	level.scr_sound[ "price" ][ "warlord_pri_incomingright" ] = "warlord_pri_incomingright";
	
	//Mortar incoming right!
	level.scr_sound[ "price" ][ "warlord_pri_mortarright" ] = "warlord_pri_mortarright";
	
	//Yuri's down!
	level.scr_sound[ "soap" ][ "warlord_mct_yurisdown" ] = "warlord_mct_yurisdown";
	
	//Yuri, keep moving!
	level.scr_sound[ "price" ][ "warlord_pri_keepmoving2" ] = "warlord_pri_keepmoving2";
	
	//Thought we lost you, mate!
	level.scr_sound[ "price" ][ "warlord_pri_lostyou" ] = "warlord_pri_lostyou";
	
	//Yuri, slot the bastard firing the mortar.
	level.scr_sound[ "price" ][ "warlord_pri_slotmortar" ] = "warlord_pri_slotmortar";
	
	//Mortar threat is down.
	level.scr_sound[ "soap" ][ "warlord_mct_mortardown" ] = "warlord_mct_mortardown";
	
	//Price: Then let's give them a proper welcome.  Yuri - man the mortar on the roof.
	level.scr_sound[ "price" ][ "warlord_pri_properwelcome" ]		= "warlord_pri_properwelcome";


	// scene 12
	//Yuri, head for the mortar tube on the rooftop.  We got a large group of militia headed our way.  Use the mortar to take them out!
	level.scr_sound[ "soap" ][ "warlord_pri_mortartube" ] = "warlord_pri_mortartube";
	
	//Yuri, take control of the mortar.
	level.scr_sound[ "price" ][ "warlord_pri_takecontrol" ] = "warlord_pri_takecontrol";
	
	//Use the mortar and hose those bastards down!
	level.scr_sound[ "price" ][ "warlord_pri_hosedown" ] = "warlord_pri_hosedown";
	
	//Looks like two technicals and a bunch of troops.  Light 'em up!
	level.scr_sound[ "price" ][ "warlord_pri_lightemup" ] = "warlord_pri_lightemup";
	
	//Start putting shells downrange!
	level.scr_sound[ "price" ][ "warlord_pri_shellsdownrange" ] = "warlord_pri_shellsdownrange";
	
	//Keep firing the mortar!
	level.scr_sound[ "soap" ][ "warlord_mct_keepfiringmortar" ] = "warlord_mct_keepfiringmortar";
	
	//All targets in the village are hostile!  If it moves, put a mortar shell on it!
	level.scr_sound[ "price" ][ "warlord_pri_targetsinvillage" ] = "warlord_pri_targetsinvillage";
	
	// scene 13
	//Sewer pipe up ahead.
	level.scr_sound[ "soap" ][ "warlord_mct_sewerpipe" ] = "warlord_mct_sewerpipe";
	
	//Regroup on me!
	level.scr_sound[ "price" ][ "warlord_pri_regroup" ] = "warlord_pri_regroup";

	//Let’s hit the church. We'll need to find a way in.
	level.scr_sound[ "price" ][ "warlord_pri_hitthechurch" ] = "warlord_pri_hitthechurch";

	//Price: Nikolai, approaching the church now. You're sure about this location?
	level.scr_sound[ "price" ][ "warlord_pri_youcertain" ]		= "warlord_pri_youcertain";
	
	//Nikolai: I've just got confirmation from my source on the ground.
	level.scr_radio[ "warlord_kgr_gotconfirmation" ]		= "warlord_kgr_gotconfirmation";
	
	//Soap: Let's hope he's right.
	level.scr_sound[ "soap" ][ "warlord_mct_letshope" ]		= "warlord_mct_letshope";

	
	//Price, I just got confirmation that the weapons are in the church.
	level.scr_radio[ "warlord_kgr_weaponsinchurch" ] = "warlord_kgr_weaponsinchurch";

	//Area clear.
	level.scr_sound[ "soap" ][ "warlord_mct_areaclear" ] = "warlord_mct_areaclear";

	//The church should be on the other side of this house. On me.
	level.scr_sound[ "price" ][ "warlord_pri_otherside" ] = "warlord_pri_otherside";

	//There’s the church.
	level.scr_sound[ "price" ][ "warlord_pri_thereschurch" ] = "warlord_pri_thereschurch";

	// scene 14

	//Push forward to the church!
	level.scr_sound[ "price" ][ "warlord_pri_pushtochurch" ]		= "warlord_pri_pushtochurch";
	
	//Price: Nikolai, an MI17 just flew overhead!
	level.scr_sound[ "soap" ][ "warlord_pri_justflewover" ]		= "warlord_pri_justflewover";
	
	//Price: We're out of time!  Get to that church, NOW!
	level.scr_sound[ "price" ][ "warlord_pri_gettothatchurch" ]		= "warlord_pri_gettothatchurch";
	
	//Price: Yuri, keep moving!
	level.scr_sound[ "price" ][ "warlord_pri_keepmoving3" ]		= "warlord_pri_keepmoving3";

	//Price: Alright, lads.  Let's do this.
	level.scr_sound[ "price" ][ "warlord_pri_alrightlads" ]		= "warlord_pri_alrightlads";

	//Soap: Church is clear!
	level.scr_sound[ "soap" ][ "warlord_mct_churchisclear" ]		= "warlord_mct_churchisclear";
	//Price: We're out of time! Yuri, on me!
	level.scr_sound[ "price" ][ "warlord_pri_outoftime" ]		= "warlord_pri_outoftime";
	//Price: Yuri - stack up!  Let's go!
	level.scr_sound[ "price" ][ "warlord_pri_stackupletsgo" ]		= "warlord_pri_stackupletsgo";
	//Price: Get the hell over here, Yuri!
	level.scr_sound[ "price" ][ "warlord_pri_getoverhere" ]		= "warlord_pri_getoverhere";
	

	//Price: Yuri, you're up.
	level.scr_sound[ "price" ][ "warlord_pri_kamarashome" ]		= "warlord_pri_kamarashome";
	
	// scene 15

	// scene 16

	// scene 17
	
	//Is Kamara alive?
	level.scr_radio[ "warlord_kgr_karamaalive" ] = "warlord_kgr_karamaalive";
	
	//On our way - 5 minutes out. Looks like we might have company.
	level.scr_radio[ "warlord_kgr_onourway" ] = "warlord_kgr_onourway";
	

	// scene 18
	//We got lots of hostiles on our tail. This place is gonna be a bullet magnet any second. Have your men dig in.
	level.scr_radio[ "warlord_kgr_bulletmagnet" ] = "warlord_kgr_bulletmagnet";

	// scene 19
	//Area’s secure. Load up the chemical weapons.
	level.scr_sound[ "kruger" ][ "warlord_kgr_loadup" ] = "warlord_kgr_loadup";

	//Good work, Price. I’ll have the money wired to your account in Luxembourg.
	level.scr_sound[ "kruger" ][ "warlord_kgr_moneywired" ] = "warlord_kgr_moneywired";
	
	//Nikolai: What about Makarov?
	level.scr_radio[ "warlord_nik_whatabout" ]		= "warlord_nik_whatabout";

	//Nikolai: Copy that. Sending a bird to pick you up.
	level.scr_radio[ "warlord_nik_sendingbird" ]		= "warlord_nik_sendingbird";
	
	//Price: We're spotted! Open fire!
	level.scr_sound[ "price" ][ "warlord_pri_werespotted" ]		= "warlord_pri_werespotted";
	//Price: They've seen us!
	level.scr_sound[ "price" ][ "warlord_pri_theyveseen" ]		= "warlord_pri_theyveseen";
	
	//Price: Yuri, this way!
	level.scr_sound[ "price" ][ "warlord_pri_yurithisway" ]		= "warlord_pri_yurithisway";


}

play_dialogue()
{
	flag_wait( "allies_spawned" );
	
	thread river_dialogue();
	thread river_technical_militia_dialogue();
	thread river_technical_stealth_broken_vo();
	thread prone_encounter_dialogue();
	thread executing_civilians_dialogue();
	thread burn_interrupt_dialogue();
	thread burn_happened_dialogue();
	thread river_big_moment_dialogue();
	thread river_spotted_dialogue();
	thread bridge_dialogue();
	thread cover_us_dialogue();
	thread overwatch_dialogue();
	thread rally_on_me_dialogue();
	thread go_noisy_dialogue();
	thread player_technical_dialogue();
	thread player_technical_technical_blocker_dialogue();
	thread player_technical_end_dialogue();
	thread mortar_run_dialogue();
	thread mortar_run_fire_dialogue();
	thread player_mortar_dialogue();
	thread assault_dialogue();
	thread church_dialogue();
	thread confrontation_dialogue();
}

dialogue_think(vo_line)
{
	if (isDefined (level.vo_interupt) && level.vo_interupt == false)
	{
		self dialogue_queue( vo_line );
	}
}

interupt_previous_lines(prev_lines_done_flag)
{
	if (!flag(prev_lines_done_flag))
	{
		level.vo_interupt = true;
		level.price stopSounds();
		level.soap stopSounds();
		wait (.5);
	}
}

river_dialogue()
{
	flag_wait( "play_river_dialogue" );
	wait( 14 );
	radio_dialogue( "warlord_nik_onehour" );
	
	wait( 4 );
	flag_set( "player_show_gun" );
	
	aud_send_msg( "mus_stop_intro_music" );
	
	wait( 4 );
	//Maintain a low profile and use the reeds for cover.  We don't want to get pinned down in this swamp.
	level.soap dialogue_queue( "warlord_pri_lowprofile" );
	//Price: Soap, try not to die this time.
	level.price dialogue_queue( "warlord_pri_trynottodie" );
	//Soap: Roger that.
	level.soap dialogue_queue( "warlord_mct_rogerthat" );
	flag_set( "river_intro_vo_done" );
	
	flag_wait( "river_technical_dialogue" );
	//Tangos approaching.
	level.soap dialogue_queue( "warlord_mct_tangosapproaching" );
	//Duck.
	level.price dialogue_queue( "warlord_pri_duck" );
	
	flag_wait( "river_technicals_move_dialogue" );
	level.price dialogue_queue( "warlord_pri_move3" );
}

ready_to_talk( guy )
{
	if ( IsDefined( guy ) && IsAlive( guy ) && guy ent_flag( "_stealth_normal" ) )
	{
		return true;
	}
	
	return false;
}

river_technical_militia_dialogue()
{
	level endon( "river_encounter_done" );
	flag_wait( "river_technical_militia_dialogue" );
	
	if ( ready_to_talk( level.river_technical_patrol[ 0 ] ) &&
		 ready_to_talk( level.river_technical_patrol[ 1 ] ) )
	{
		thread river_technical_militia_conversation();
	}
}

river_technical_stealth_broken_vo()
{
	level endon( "river_encounter_done" );
	flag_wait( "technical_steal_broken_vo" );
	level.price dialogue_queue( "warlord_pri_werespotted" );
}

river_technical_militia_conversation()
{
	river_technical_militia_conversation_lines();
}

river_technical_militia_conversation_lines()
{
	level endon( "conversation_interrupted" );
	level.river_technical_patrol[ 0 ] endon( "death" );
	level.river_technical_patrol[ 1 ] endon( "death" );
	
	level.river_technical_patrol[ 0 ] thread interrupt_river_technical_militia_line();
	level.river_technical_patrol[ 1 ] thread interrupt_river_technical_militia_line();
	
	//Is everyone dead?
	level.river_technical_patrol[ 0 ] dialogue_queue( "warlord_mlt1_everyonedead" );
	//Most but not all.
	level.river_technical_patrol[ 1 ] dialogue_queue( "warlord_mlt2_notall" );
	//Find the others.
	level.river_technical_patrol[ 0 ] dialogue_queue( "warlord_mlt1_findothers" );
}

interrupt_river_technical_militia_line()
{
	self endon( "death" );
	level endon( "conversation_interrupted" );
	
	self thread stop_speaking();
	
	self ent_flag_waitopen( "_stealth_normal" );
	level notify( "conversation_interrupted" );
}

stop_speaking()
{
	self endon( "death" );
	level waittill( "conversation_interrupted" );
	self stopSounds();
}

prone_encounter_dialogue()
{
	flag_wait( "prone_encounter_start_dialogue" );	
	//Two x-rays, nine o'clock. Yuri, take the shot.
	level.soap dialogue_queue( "warlord_pri_twoxrays" );
	//Take them out.
	level.price dialogue_queue( "warlord_pri_welldoneyuri" );
	
	flag_wait( "river_encounter_3_complete" );
	wait 0.05;
	
	if ( flag( "prone_encounter_well_done_dialogue" ) )
	{
		//Well done, Yuri.
		level.soap dialogue_queue( "warlord_mct_clear2" );
	}
}

executing_civilians_dialogue()
{
	flag_wait( "tire_necklace_dialogue" );
	//Soap: Looks like an execution. Want to intervene?
	level.soap dialogue_queue( "warlord_mct_execution" );
	
	wait( 1 );
	if( !flag( "river_burn_interrupted" ) )
	{
		//Price: Your call, Yuri.
		level.price dialogue_queue( "warlord_pri_yourcall" );
	}
	
	flag_wait( "allies_path_to_big_moment" );
	
	if( flag( "river_burn_interrupted" ) )
	{
		wait( 1 );
	}
	
	//Move up.
	level.price dialogue_queue( "warlord_pri_move3" );
}

burn_interrupt_dialogue()
{
	level endon( "river_house_burn_anim_finished" );
	flag_wait( "river_burn_interrupted" );
	//Take them out.
	level.price dialogue_queue( "warlord_pri_takethemout" );
}

burn_happened_dialogue()
{
	level endon( "river_burn_interrupted" );
	flag_wait( "river_house_burn_anim_finished" );
	//Soap: Bastards.
	level.soap dialogue_queue( "warlord_mct_bastards" );
	//Price: We'll handle them later.  Focus on staying alive.
	level.price dialogue_queue( "warlord_pri_handlethemlater" );
}

river_big_moment_dialogue()
{
	level endon( "river_big_moment_stealth_spotted" );
	
	flag_wait( "flag_player_first_beat" );
	
	// make sure you aren't spotted.  game could be in a situation
	//   where you are going from spotted to stealth and so the 
	//   river_big_moment_stealth_spotted has not been flagged yet
	flag_waitopen( "_stealth_spotted" );
	
	level.price dialogue_queue( "warlord_pri_moveup2" );
	//Hold your fire.  There's too many of them.
	level.price dialogue_queue( "warlord_pri_toomany" );

	flag_wait( "dont_be_stupid_dialogue" );
	//Don't do anything stupid lads.
	level.price dialogue_queue( "warlord_pri_bastards" );
	
	wait( 9 );
	//Price: Alright, get ready…
	level.price dialogue_queue( "warlord_pri_alrightgetready" );
	
	flag_wait( "second_beat_move_dialogue" );
	//Move!
	level.price dialogue_queue( "warlord_pri_move3" );
	
	flag_wait( "off_road_vo" );
	//Get down! Get off the road!
	level.price dialogue_queue( "warlord_pri_getoffroad" );

	flag_wait( "off_the_road_dialogue" );
	//Price: Get down!  Now!
	level.price dialogue_queue( "warlord_pri_getdownnow" );
	
	flag_wait( "river_burn_watchers_leave" );
	wait( 3 );
	//Easy…
	level.price dialogue_queue( "warlord_pri_easy" );
	
	wait( 9 );
	
	if(isalive(level.river_dialogue_guys[0]))
	{
		//The witch doctor said a storm is coming.
		level.river_dialogue_guys[ 0 ] dialogue_queue( "warlord_mlt1_stormcoming" );
		wait( 1 );

		if(isalive(level.river_dialogue_guys[1]))
		{
			//Did he say when?
			level.river_dialogue_guys[ 1 ] dialogue_queue( "warlord_mlt2_saywhen" );
			wait( 1 );

			if(isalive(level.river_dialogue_guys[0]))
			{
				//Today.
				level.river_dialogue_guys[ 0 ] dialogue_queue( "warlord_mlt1_today" );
			}
		}
	}
	
	flag_wait( "river_big_moment_done_dialogue" );
	wait( 2 );
	//All clear.
	level.price dialogue_queue( "warlord_pri_allclear" );
}

river_spotted_dialogue()
{
	level endon ( "price_door_triggered" );
	flag_wait( "river_spotted_dialogue" );
	
	//We're compromised!  
	level.price dialogue_queue( "warlord_pri_compromised" );
}

bridge_dialogue()
{
	level endon( "river_spotted_dialogue" );
	flag_wait( "flag_player_at_third_beat" );
	//Soap: Hold up.
	level.soap dialogue_queue( "warlord_mct_holdup" );
	
	flag_wait( "flag_go_to_bridge" );
	level.soap dialogue_queue( "warlord_mct_clear2" );
	
	flag_wait( "church_mouse_dialogue" );
	//Soap: Two more on the bridge.  We'll have to take them down.
	level.soap dialogue_queue( "warlord_mct_2moreonbridge" );
	//Hostiles - on the bridge.  Wait for the truck to pass.
	level.price dialogue_queue( "warlord_pri_waitfortruck" );
	
	flag_wait( "bridge_go_loud_dialogue" );
	//Drop'em.
	level.price dialogue_queue( "warlord_pri_dropem" );
	
	flag_wait( "bridge_guys_dead_dialogue" );
	//Move up.
	level.price dialogue_queue( "warlord_pri_moveup" );
}

cover_us_dialogue()
{
	level.price endon( "death" );
	level endon( "inf_stealth_spotted" );
	
	flag_wait( "large_group_dialogue" );
	//Price: Makarov's in the factory up the road.
	level.soap dialogue_queue( "warlord_pri_uptheroad" );	
	flag_wait( "cover_us_dialogue" );
	//Yuri, you’re on overwatch. Take up a position on the roof and cover us.
	level.price dialogue_queue( "warlord_pri_coverus" );
	thread cover_us_hurry_lines();
}

cover_us_hurry_lines()
{
	level endon( "inf_teleport_allies" );
	level endon( "infiltration_over" );
	level endon( "inf_stealth_spotted" );
	
	if ( flag( "infiltration_over" ) || flag( "inf_stealth_spotted" ) )
		return;
		
	//Yuri, get in position.
	current_line = "warlord_pri_getinposition";
	//Yuri, get up the ladder.
	next_line = "warlord_pri_getupladder";
	
	while( !flag( "inf_teleport_allies" ) )
	{
		wait( 5 );
		level.price dialogue_queue( current_line );
		temp = current_line;
		current_line = next_line;
		next_line = temp;
	}
}

overwatch_dialogue()
{
	thread overwatch_sniper_dialogue();
	thread factory_breach_dialogue();
}

overwatch_sniper_dialogue()
{
	level endon( "infiltration_over" );
	level endon( "inf_stealth_spotted" );
	
	flag_wait( "multiple_guards_dialogue" );
	//Two hosites approaching, 5 meters.
	level.price dialogue_queue( "warlord_pri_twohostiles" );
	
	flag_set( "inf_encounter_2_vo_done" );
	flag_wait( "inf_ramp_guys_dead" );
	//I've got multiple guards approaching.  Take them down.
	level.soap dialogue_queue( "warlord_pri_multipleguards" );
	
	flag_wait_all( "inf_ramp_guys_dead", "inf_talkers_dead" );
	//Bounding up.
	level.soap dialogue_queue( "warlord_mct_boundingup" );
	
	flag_wait( "more_militia_dialogue" );
	//Militia approaching on the roads.
	level.price dialogue_queue( "warlord_pri_militia" );
	
	flag_wait( "inf_both_moving_dialogue" );
	wait( 1 );
	//Moving.
	level.soap dialogue_queue( "warlord_mct_moving" );
	//Bounding.
	level.price dialogue_queue( "warlord_pri_moving" );
	wait( 1 );
	
	//Breaching the factory now.
	level.price dialogue_queue( "warlord_pri_breachingfactory" );
}

factory_breach_dialogue()
{
	flag_wait( "breaching_factory_dialogue" );
	wait( 1 );
	//Clear.
	level.price dialogue_queue( "warlord_mct_clear" );
	//Soap: Clear?  The place is bloody empty.
	level.soap dialogue_queue( "warlord_mct_bloodyempty" );
	//Price: Nikolai, dry hole at the factory. Makarov isn't here.
	radio_dialogue( "warlord_pri_dryhole" );
	//Nikolai: He must have moved to the militia's headquarters at the center of town.
	radio_dialogue( "warlord_kgr_rvthere" );
	//Price: We're moving there now.
	level.price dialogue_queue( "warlord_pri_hopetheydid" );
	if ( !flag( "inf_stealth_spotted" ) )
	{
		//Heads up - we've got company.
		level.soap dialogue_queue( "warlord_mct_headsup" );
	}
	wait( 1 );
	flag_set( "breaching_factory_dialogue_done" );
}

rally_on_me_dialogue()
{
	level.soap endon( "death" );
	level.price endon( "death" );
	
	flag_wait_any( "breaching_factory_dialogue_done", "inf_stealth_spotted" );
	aud_send_msg( "mus_go_hot" );
	//We're compromised!  
	level.price dialogue_queue( "warlord_pri_compromised" );
	wait( 3 );
	
	weapons = level.player GetWeaponsList( "primary" );
	
	flag_set( "no_ak_vo" );
	
	foreach( weapon in weapons )
	{
		if( isSubStr( weapon, "ak47" ) )
		{
			flag_clear( "no_ak_vo" );
		}
	}
	
	primary = level.player GetCurrentPrimaryWeapon();
	if( isSubStr( primary, "ak47" ) )
	{
		flag_set( "no_ak_vo" );
	}
	
	if( !flag( "no_ak_vo" ) )
	{
		//Switch to your AK.
		level.price dialogue_queue( "warlord_pri_switchtoak" );
	}
	
	wait( 3 );
	//Yuri, run!
	level.price dialogue_queue( "warlord_pri_yurirun" );
	wait( 3 );
	
	//Rally on me!
	level.price dialogue_queue( "warlord_pri_rallyonme2" );
}

advance_clear_and_nag_lines()
{
	if ( flag( "player_technical_spawn" ) )
		return;
	
	flag_wait( "advance_combat_complete" );
	
	wait( 1 );
	
	//Area clear.
	level.soap dialogue_queue( "warlord_mct_areaclear" );
	
	thread advance_nag_lines();
		
	//Soap: Through here!  Let's go!
	level.soap dialogue_queue( "warlord_mct_throughhere" );
	flag_wait( "player_technical_spawn" );
	wait( 1 );
	//Soap: I think they know we're here.
	level.soap dialogue_queue( "warlord_mct_theyknow" );
	//Price: All that matters is Makarov's cargo.  Keep moving.
	level.price dialogue_queue( "warlord_pri_makarovscargo" );
}

advance_nag_lines()
{
	lines = [];
	lines[0] = "warlord_pri_yurioverhere"; //Yuri, over here!
  	lines[1] = "warlord_pri_yurithisway"; //Yuri, get in position.

	thread maps\_shg_common::dialogue_reminder( level.price, "player_technical_spawn", lines, 5, 10 );
}

go_noisy_dialogue()
{
	level.price endon( "death" );
	
	flag_wait( "go_noisy_dialogue" );
	
	thread advance_clear_and_nag_lines();
	
	flag_wait( "push_forward_dialogue" );
	//Yuri, push forward.
	level.price dialogue_queue( "warlord_pri_pushforward" );
	
	flag_wait( "technical_ahead_dialogue" );
	if ( IsDefined( level.price.at_technical_area ) )
	{
		//Technical dead ahead!
		level.price dialogue_queue( "warlord_pri_technical" );
	}
}

player_technical_dialogue()
{
	level.soap endon( "death" );
	level.price endon( "death" );
	
	flag_wait( "player_technical_dialogue" );	

	if ( IsDefined( level.price.at_technical_area ) )
	{
		//Yuri, man the 50-cal and lay down cover fire!
		level.price dialogue_queue( "warlord_pri_man50cal" );
	}
	
	thread player_technical_hurry_dialogue();
	
	flag_wait( "technical_1_dialogue" );
	if ( IsDefined( level.price.at_technical_area ) )
	{
		//Put fire on the technical!
		level.price dialogue_queue( "warlord_pri_putfire" );
	}
	
	flag_wait( "roof_right_dialogue" );
	if ( IsDefined( level.price.at_technical_area ) )
	{
		//Enemy, rooftop, right!
		level.price dialogue_queue( "warlord_pri_enemyrooftop" );
	}
	
	//Contact Front!
	thread technical_call_out_guys( level.price, "contact_front_1_dialogue", "warlord_pri_contactfront" );
	//Contact Left!
	thread technical_call_out_guys( level.price, "contact_left_1_dialogue", "warlord_pri_contactleft" );
	//Contact left!
	thread technical_call_out_guys( level.soap, "contact_left_2_dialogue", "warlord_mct_contactleft" );
	//Contact Front!
	thread technical_call_out_guys( level.price, "contact_front_2_dialogue", "warlord_pri_contactfront" );
	//Right, right!
	thread technical_call_out_guys( level.soap, "contact_right_1_dialogue", "warlord_mct_rightright" );
	//Contact Left!
	thread technical_call_out_guys( level.price, "contact_left_3_dialogue", "warlord_pri_contactleft" );
	//Contact Left!
	thread technical_call_out_guys( level.price, "contact_left_4_dialogue", "warlord_pri_contactleft" );
	//Contact Front!
	thread technical_call_out_guys( level.price, "contact_front_3_dialogue", "warlord_pri_contactfront" );
}

technical_call_out_guys( ally, wait_flag, dialogue )
{
	level endon( "technical_combat_complete" );
	flag_wait( wait_flag );
	if ( IsDefined( ally.at_technical_area ) )
	{
		ally dialogue_queue( dialogue );
	}
}

player_technical_technical_blocker_dialogue()
{
	flag_wait( "technical_2_dialogue" );
	
	if ( IsDefined( level.price.at_technical_area ) )
	{
		//Enemy technical incoming!  Take it out!
		level.price dialogue_queue( "warlord_pri_technicalincoming" );
	}
}

player_technical_hurry_dialogue()
{
	level endon( "player_boarding_technical" );
	level endon( "technical_turret_combat_timer_complete" );
	level endon( "technical_stalled_combat_complete" );
	
	counter = 0;
	while( !flag( "player_boarding_technical" ) && counter < 3 )
	{
		wait( 5 );
		if( !flag( "player_boarding_technical" ) )
		{
			if ( IsDefined( level.price.at_technical_area ) )
			{
				//Yuri, get on that 50!
				level.price dialogue_queue( "warlord_pri_geton50" );
			}
			counter++;
		}
	}
}

player_technical_end_dialogue()
{
	level.soap endon( "death" );
	
	flag_wait( "player_technical_dialogue" );
	flag_wait( "mortar_technical" );
	
	//Mortar fire inbound!
	level.soap dialogue_queue( "warlord_mct_mortarfire" );
	
	if( flag( "player_on_technical" ) )
	{
		flag_wait( "mortar_technical_hit" );
		wait 10;
		flag_set( "militia_vo_done" );
	}
	
	if( !flag( "player_on_technical" ) )
	{
		wait( 2.5 );
		//The whole militia is headed straight for us!
		level.soap dialogue_queue( "warlord_mct_wholemilitia" );
		flag_set( "militia_vo_done" );
	}
}

mortar_run_dialogue()
{
	level.price endon( "death" );
	
	flag_wait( "mortar_run_dialogue" );
	wait( 2 );
	//Don’t stop moving. They’re triangulating your twenty!
	level.price dialogue_queue( "warlord_pri_triangulating" );
	
	flag_wait( "mortar_roof_fall_dialogue" );
	//Yuri's down!
	level.soap dialogue_queue( "warlord_mct_yurisdown" );
	//Yuri, keep moving!
	level.price dialogue_queue( "warlord_pri_keepmoving2" );
	
	flag_wait( "mortar_door_dialogue" );
	//Thought we lost you, mate!
	level.price dialogue_queue( "warlord_pri_lostyou" );
	flag_wait( "mortar_fight_shot" );
	//Price: Yuri, slot the bastard firing the mortar.
	level.price dialogue_queue( "warlord_pri_slotmortar" );
	
	flag_wait( "mortar_operator_off" );
	flag_waitopen( "dialogue_in_progress" );
	flag_set( "dialogue_in_progress" );
	//Soap: Mortar threat is down.
	level.soap dialogue_queue( "warlord_mct_mortardown" );
	flag_clear( "dialogue_in_progress" );
}

use_up_mortar_line( lines_array )
{
	if ( IsDefined( lines_array ) && lines_array.size > 0 )
	{
		dialogue_index = RandomInt( lines_array.size );
		level.vo_mortar_line = lines_array[ dialogue_index ];
		lines_array = array_remove_index( lines_array, dialogue_index );
		return lines_array;
	}
	
	return undefined;
}

mortar_run_fire_dialogue()
{
	level.player endon( "death" );
	level endon( "mortar_roof_fall_dialogue" );
	
	move_lines = [];
	//Move!
	move_lines[ move_lines.size ] = "warlord_pri_move";
	//Keep moving!
	move_lines[ move_lines.size ] = "warlord_pri_keepmoving";
	//Go!
	move_lines[ move_lines.size ] = "warlord_pri_go2";
	//Run!
	move_lines[ move_lines.size ] = "warlord_pri_run";
	//Don't stop moving!
	move_lines[ move_lines.size ] = "warlord_pri_dontstopmoving";
	//Go, go, go! 
	move_lines[ move_lines.size ] = "warlord_pri_gogogo";
	
	mortar_lines = [];
	//Mortar, incoming!
	mortar_lines[ mortar_lines.size ] = "warlord_pri_mortarincoming";
	
	mortar_left_lines = [];
	//Incoming left!
	mortar_left_lines[ mortar_left_lines.size ] = "warlord_pri_incomingleft";
	//Mortar incoming left!
	mortar_left_lines[ mortar_left_lines.size ] = "warlord_pri_mortarleft";
	
	mortar_right_lines = [];
	//Incoming right!
	mortar_right_lines[ mortar_right_lines.size ] = "warlord_pri_incomingright";
	//Mortar incoming right!
	mortar_right_lines[ mortar_right_lines.size ] = "warlord_pri_mortarright";
	
	min_delay_between_lines = 3000;		// time it has to wait before saying another line (in ms)
	last_mortar_line_time = min_delay_between_lines * -2;	// just so start points will work (first line will always play)
	
	flag_wait( "mortar_run_dialogue" );
	while( 1 )
	{
		mortar_side = wait_on_mortar_line();
		
		level.vo_mortar_line = undefined;
		if ( IsDefined( mortar_side ) )
		{
			if ( mortar_side == "right_side" )
			{
				mortar_right_lines = use_up_mortar_line( mortar_right_lines );
			}
			else if ( mortar_side == "left_side" )
			{
				mortar_left_lines = use_up_mortar_line( mortar_left_lines );
			}
			else if ( mortar_side == "no_side" )
			{
				mortar_lines = use_up_mortar_line( mortar_lines );
			}
			else
			{
				AssertEx( false, "unrecognized mortar_side parameter: " + mortar_side );
			}
		}
		
		if ( !IsDefined( level.vo_mortar_line ) )
		{
			move_lines = use_up_mortar_line( move_lines );
		}
		
		if ( IsDefined( level.vo_mortar_line ) )
		{
			if ( GetTime() - last_mortar_line_time > min_delay_between_lines )
			{
				level.price dialogue_queue( level.vo_mortar_line );
				
				last_mortar_line_time = GetTime();
			}
		}
	}
}

wait_on_mortar_line()
{
	level endon( "mortar_line_timeout" );
	thread mortar_line_timeout();
	level waittill( "mortar_incoming_dialogue", mortar_side );
	return mortar_side;
}

mortar_line_timeout()
{
	level endon( "mortar_incoming_dialogue" );
	wait 5;
	level notify( "mortar_line_timeout" );
}

player_mortar_dialogue()
{
	level.price endon( "death" );
	
	flag_wait( "head_to_mortar_dialogue" );
	waittillframeend;
	flag_waitopen( "dialogue_in_progress" );
	flag_set( "dialogue_in_progress" );
	//Yuri, head for the mortar tube on the rooftop.  We got a large group of militia headed our way.  Use the mortar to take them out!
	level.soap dialogue_queue( "warlord_pri_mortartube" );
	//Price: Then let's give them a proper welcome.  Yuri - man the mortar on the roof.
	level.price dialogue_queue( "warlord_pri_properwelcome" );
	flag_clear( "dialogue_in_progress" );
	
	thread player_use_mortar_nag();
	
	flag_wait( "player_at_mortar" );
	//Start putting shells downrange!
	level.price dialogue_queue( "warlord_pri_shellsdownrange" );
	wait( 2.0 );
	//Use the mortar and hose those bastards down!
	level.price dialogue_queue( "warlord_pri_hosedown" );
	
	flag_wait( "mortar_targets_dialogue" );
	//Looks like two technicals and a bunch of troops.  Light 'em up!
	level.price dialogue_queue( "warlord_pri_lightemup" );
	
	wait( 2.0 );
	//All targets in the village are hostile!  If it moves, put a mortar shell on it!
	level.price dialogue_queue( "warlord_pri_targetsinvillage" );
	
	flag_wait( "keep_firing_mortar" );
	//Keep firing the mortar!
	level.soap dialogue_queue( "warlord_mct_keepfiringmortar" );
}

player_use_mortar_nag()
{
	level endon( "player_at_mortar" );
	if ( flag( "player_at_mortar" ) )
		return;
	
	while ( true )
	{
		wait 8;
		//Yuri, take control of the mortar.
		level.price dialogue_queue( "warlord_pri_takecontrol" );
	}
}

assault_dialogue()
{
	thread regroup_dialogue();
	thread begin_assault_dialogue();
}
	
regroup_dialogue()
{
	level.price endon( "death" );
	
	flag_wait( "regroup_dialogue" );
	aud_send_msg( "mus_player_mortar_done" );
	//Regroup on me!
	level.price dialogue_queue( "warlord_pri_regroup" );
	//Let’s hit the church.
	level.price dialogue_queue( "warlord_pri_hitthechurch" );
	
	flag_wait( "assault_run_to_pipe" );
	wait( 2.0 );
	//Sewer pipe up ahead.
	level.soap dialogue_queue( "warlord_mct_sewerpipe" );
}

begin_assault_dialogue()
{
	flag_wait( "sewer_pipe_vo" );
	//Price: Nikolai, approaching the church now. You're sure about this location?
	level.price dialogue_queue( "warlord_pri_youcertain" );
	//Nikolai: I've just got confirmation from my source on the ground.
	radio_dialogue( "warlord_kgr_gotconfirmation" );
	//Soap: Let's hope he's right.
	level.soap dialogue_queue( "warlord_mct_letshope" );
	
	flag_wait( "assault_all_clear" );
	
	guys = GetAiArray( "axis" );
	if( !flag( "assault_compound_failsafe" ) && guys.size == 0 )
	{
		wait 2;
		//Area clear.
		level.soap dialogue_queue( "warlord_mct_areaclear" );
	}
	
	flag_wait( "house_door_dialogue" );
	//The church should be on the other side of this house. On me.
	level.price dialogue_queue( "warlord_pri_otherside" );
}

church_dialogue()
{
	// scene 15
	flag_wait( "theres_church_dialogue" );
	//There’s the church.
	level.price dialogue_queue( "warlord_pri_thereschurch" );
	wait( 2 );
	//Price: Nikolai, an MI17 just flew overhead!
	level.soap dialogue_queue( "warlord_pri_justflewover" );
	//Price: We're out of time!  Get to that church, NOW!
	level.price dialogue_queue( "warlord_pri_gettothatchurch" );
	//flag_wait( "compound_truck_right" );
	thread church_nag_lines();
	
	flag_wait( "church_breach_complete" );
	wait( 1 );
	//Soap: Church is clear!
	level.soap dialogue_queue( "warlord_mct_churchisclear" );
	//Price: Stack up on the door!
	level.price dialogue_queue( "warlord_pri_outoftime" );
	wait( 1 );
	//Price: Alright, lads.  Let's do this.
	level.price dialogue_queue( "warlord_pri_alrightlads" );
	thread breach_nag_lines();
}

church_nag_lines()
{
	lines = [];
	//Price: Push forward to the church!
	lines[0] = "warlord_pri_pushtochurch";
	//Price: Yuri, push forward!
	lines[1] = "warlord_pri_pushforward";
	//Price: Yuri, keep moving!
	lines[2] = "warlord_pri_keepmoving3";
	
	thread maps\_shg_common::dialogue_reminder( level.price, "end_church_nag_vo", lines, 7, 10 );
}

breach_nag_lines()
{
	lines = [];
	//Price: We're out of time! Yuri, on me!
	lines[0] = "warlord_pri_kamarashome";
	//Price: Yuri - stack up!  Let's go!
	lines[1] = "warlord_pri_stackupletsgo";
	//Price: Get the hell over here, Yuri!
	lines[2] = "warlord_pri_getoverhere";
	
	wait( 5 );
	thread maps\_shg_common::dialogue_reminder( level.price, "breach_starting", lines, 5, 6 );
}

confrontation_dialogue()
{
	// scene 17
	
	flag_wait( "getting_away_dialogue" );
	//Nikolai: What about Makarov?
	radio_dialogue( "warlord_nik_whatabout" );
	wait( 7 );
	//Nikolai: Copy that. Sending a bird to pick you up.
	//radio_dialogue( "warlord_nik_sendingbird" );
	flag_set( "confrontation_vo_finished" );
}
