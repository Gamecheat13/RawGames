main()
{
	maps\moscow_anim::dialogue();
	maps\moscow_anim::misc();
	maps\moscow_anim::chair();
}
#using_animtree("moscow");
chair()
{
	level.scr_anim["chair"]["drop"]	 			= %chair_germanfall;
}

#using_animtree("generic_human");
misc()
{
	level.scr_anim["generic"]["nade_throw"]	 		= %stand_grenade_throw;
	level.scr_anim["generic"]["nade_reset1"]	 	= %stand_aim2alert_1;
	level.scr_anim["generic"]["nade_reset2"]	 	= %stand_aim2alertb;
	level.scr_anim["generic"]["fire_semi"]	 		= %stand_shoot_straight;
	level.scr_anim["generic"]["chamber"]	 		= %stand_rechamber;
	level.scr_anim["generic"]["fire_full"]	 		= %stand_shoot_auto_straight;
	level.scr_anim["generic"]["reload_crouch"]	 	= %reload_crouch_rifle;
	level.scr_anim["generic"]["reload_stand"]	 	= %reload_stand_rifle;

	level.scr_anim["generic"]["aim"][0]		 		= %stand_aim_straight_loop1;
	level.scr_anim["generic"]["aim"][1]		 		= %stand_aim_straight;
	
	level.scr_anim["generic"]["nade_throw_right"]	= %corner_stand_grenade_throw_right;
	level.scr_anim["generic"]["nade_death"]			= %moscow_german_nade_death;
	level.scr_anim["generic"]["wall_dive"] 			= %jump_over_low_wall;
	
	level.scr_anim["generic"]["kick_door_1"] 	= %chateau_kickdoor1;
	level.scr_anim["generic"]["kick_door_2"] 	= %chateau_kickdoor2;
	
	level.scr_anim["generic"]["setupladder"]	= (%moscow_armory_guy);
	
	level.scr_anim["generic"]["grab_gun1"]		= (%russian_guy1_riflepickup);
	level.scr_anim["generic"]["grab_gun2"]		= (%russian_guy2_riflepickup);
	level.scr_anim["generic"]["grab_gun3"]		= (%russian_guy3_riflepickup);
	
	level.scr_anim["generic"]["truck1"]			= (%moscow_guy1_jumpofftruck);
	level.scr_anim["generic"]["truck2"]			= (%moscow_guy2_jumpofftruck);
	level.scr_anim["generic"]["truck3"]			= (%moscow_guy3_jumpofftruck);
	
	level.scr_anim["generic"]["jump1"]			= (%moscow_guy1_jumpoffledge);
	level.scr_anim["generic"]["jump2"]			= (%moscow_guy2_jumpoffledge);
	level.scr_anim["generic"]["jump3"]			= (%moscow_guy3_jumpoffledge);
	
	level.scr_anim["restnode"]["listen"][0]		= (%moscow_rs4_idle);
	level.scr_anim["restnode"]["tired"][0]		= %eldaba_tired_idleB;
	level.scr_anim["restnode"]["lean"][0]		= %eldaba_tired_idleA;
	level.scr_anim["restnode"]["hurt"][0]		= %eldaba_tired_idleB;
	
	level.scr_anim["ht_mg"]["mg_idle"]			= (%eldaba_truckride_idle_guy2);
	level.scr_anim["ht_mg"]["mg_idle2"]			= (%halftrack_MGgunner_idle);	
													
	
	level.scr_anim["letlev"]["block_idle"][0]	= %downtown_sniper_blocking_door_idle;
	level.scr_anim["letlev"]["block_idle"][1]	= %downtown_sniper_blocking_door_idle;
	level.scr_anim["letlev"]["block_idle"][2]	= %downtown_sniper_blocking_door_idle;
	level.scr_anim["letlev"]["block_idle"][3]	= %downtown_sniper_blocking_door_twitch;
	//level.scr_anim["letlev"]["block_twitch"]	= %downtown_sniper_blocking_door_twitch;
	level.scr_anim["letlev"]["block_idle2"][0]	= %downtown_sniper_blocking_door_idle2;
	level.scr_anim["letlev"]["block2stand"]		= %downtown_sniper_blocking_door_block2stand;
	level.scr_anim["letlev"]["stand2block"]		= %downtown_sniper_blocking_door_stand2block;
	
	level.scr_anim["letlev"]["fire_pistol"]		= %pistol_standshoot_straight;
	level.scr_anim["letlev"]["fire_pistol_down"]= %pistol_standshoot_down;
	level.scr_anim["letlev"]["aim_pistol"]		= %pistol_standaim_idle;
	level.scr_anim["letlev"]["aim_pistol_down"]	= %pistol_standaim_idle_down;
	level.scr_anim["letlev"]["aim_pistol_idle"][0]	= %pistol_standaim_idle_down;
	
	//INTERROGATION
	level.scr_anim["letlev"]["idle"][0]			= %guard2_aimidle;
	level.scr_anim["letlev"]["idle_start"]		= %guard2_germanfallreaction_idle;
	level.scr_anim["letlev"]["react"]			= %moscow_guard2_door_react;
	level.scr_anim["letlev"]["react_idle"][0]	= %moscow_guard2_door_react_idle;
	
	level.scr_anim["german"]["idle"][0]	 		= %german_idle;
	level.scr_anim["german"]["double"]			= %german_doublepunch;
	level.scr_anim["german"]["hit"]				= %german_gethit1;
	level.scr_anim["german"]["pain"]			= %german_gethit2;
	level.scr_anim["german"]["spit"]			= %german_gethit3;
	
	level.scr_anim["guard"]["idle"][0]			= %guard_idle;
	level.scr_anim["guard"]["double"] 			= %guard_doublepunch;
	level.scr_anim["guard"]["spit"] 			= %guard_wipeface;
	level.scr_anim["guard"]["react"] 			= %moscow_guard_door_react;
	level.scr_anim["guard"]["react_idle"][0]	= %moscow_guard_door_react_idle;
	
	
	level.scr_anim["truck1"]["idle"][0]			= %moscow_guy1_coldidle;
	level.scr_anim["truck1"]["idleweight"][0]	= 3;
	level.scr_anim["truck1"]["idle"][1]			= %moscow_guy1_coldtwitch1;
	level.scr_anim["truck1"]["idleweight"][1]	= 1;
	level.scr_anim["truck1"]["idle"][2]			= %moscow_guy1_looktwitch2;
	level.scr_anim["truck1"]["idleweight"][2]	= 1;		
	
	level.scr_anim["truck2"]["idle"][0]			= %moscow_guy2_coldidle;
	level.scr_anim["truck2"]["idleweight"][0]	= 3;
	level.scr_anim["truck2"]["idle"][1]			= %moscow_guy2_coldtwitch2;
	level.scr_anim["truck2"]["idleweight"][1]	= 1;
	level.scr_anim["truck2"]["idle"][2]			= %moscow_guy2_looktwitch1;
	level.scr_anim["truck2"]["idleweight"][2]	= 1;	
	
	level.scr_anim["truck3"]["idle"][0]			= %moscow_guy3_coldidle;
	level.scr_anim["truck3"]["idleweight"][0]	= 3;
	level.scr_anim["truck3"]["idle"][1]			= %moscow_guy3_looktwitch;
	level.scr_anim["truck3"]["idleweight"][1]	= 1;	
}
#using_animtree("generic_human");
dialogue()
{
	lnum = 0;
	gnum = 0;
	rnum = 0;
	tnum = 0;
	
	level.scr_anim["letlev"]["moscow_rs1_pickuprifle"]						= (%mos_0_01_rs1_pickuprifle_t);
	level.scr_notetrack["letlev"][lnum]["notetrack"]						= "dialog";
	level.scr_notetrack["letlev"][lnum]["anime"]							= "moscow_rs1_pickuprifle";
	level.scr_notetrack["letlev"][lnum]["dialogue"]							= "moscow_rs1_pickuprifle";
	lnum++;

	level.scr_anim["letlev"]["moscow_rs1_pickupvasili"]						= (%mos_0_01a_rs1_pickupvasili_t);
	level.scr_notetrack["letlev"][lnum]["notetrack"]						= "dialog";
	level.scr_notetrack["letlev"][lnum]["anime"]							= "moscow_rs1_pickupvasili";
	level.scr_notetrack["letlev"][lnum]["dialogue"]							= "moscow_rs1_pickupvasili";
	lnum++;
	
	level.scr_anim["letlev"]["moscow_rs1_howgoodaim"]						= (%moscow_tcm_sc00_02);
	level.scr_notetrack["letlev"][lnum]["notetrack"]						= "dialog";
	level.scr_notetrack["letlev"][lnum]["anime"]							= "moscow_rs1_howgoodaim";
	level.scr_notetrack["letlev"][lnum]["dialogue"]							= "moscow_rs1_howgoodaim";
	lnum++;
	
	level.scr_anim["letlev"]["moscow_rs1_goodnowfire"]						= (%moscow_tcm_sc00_03);
	level.scr_notetrack["letlev"][lnum]["notetrack"]						= "dialog";
	level.scr_notetrack["letlev"][lnum]["anime"]							= "moscow_rs1_goodnowfire";
	level.scr_notetrack["letlev"][lnum]["dialogue"]							= "moscow_rs1_goodnowfire";
	lnum++;
	
	level.scr_anim["letlev"]["moscow_rs1_teddybear"]						= (%moscow_tcm_sc00_07);
	level.scr_notetrack["letlev"][lnum]["notetrack"]						= "dialog";
	level.scr_notetrack["letlev"][lnum]["anime"]							= "moscow_rs1_teddybear";
	level.scr_notetrack["letlev"][lnum]["dialogue"]							= "moscow_rs1_teddybear";
	lnum++;
	
	level.scr_anim["letlev"]["moscow_rs1_mannequinscold"]					= (%moscow_tcm_sc00_07);
	level.scr_notetrack["letlev"][lnum]["notetrack"]						= "dialog";
	level.scr_notetrack["letlev"][lnum]["anime"]							= "moscow_rs1_mannequinscold";
	level.scr_notetrack["letlev"][lnum]["dialogue"]							= "moscow_rs1_mannequinscold";
	lnum++;

	level.scr_anim["letlev"]["moscow_rs1_mannequinscold2"]					= (%moscow_tcm_sc00_08);
	level.scr_notetrack["letlev"][lnum]["notetrack"]						= "dialog";
	level.scr_notetrack["letlev"][lnum]["anime"]							= "moscow_rs1_mannequinscold2";
	level.scr_notetrack["letlev"][lnum]["dialogue"]							= "moscow_rs1_mannequinscold2";
	lnum++;
	
	level.scr_anim["letlev"]["moscow_rs1_mannequin"]						= (%moscow_tcm_sc00_05);
	level.scr_notetrack["letlev"][lnum]["notetrack"]						= "dialog";
	level.scr_notetrack["letlev"][lnum]["anime"]							= "moscow_rs1_mannequin";
	level.scr_notetrack["letlev"][lnum]["dialogue"]							= "moscow_rs1_mannequin";
	lnum++;
		
	level.scr_anim["letlev"]["moscow_rs1_shootbearscold"]					= (%mos_0_08a_rs1_shootbearscold_t);
	level.scr_notetrack["letlev"][lnum]["notetrack"]						= "dialog";
	level.scr_notetrack["letlev"][lnum]["anime"]							= "moscow_rs1_shootbearscold";
	level.scr_notetrack["letlev"][lnum]["dialogue"]							= "moscow_rs1_shootbearscold";
	lnum++;
	
	level.scrsound["letlev"]["moscow_traitor"]								= "moscow_traitor";
	level.scr_face["letlev"]["moscow_traitor"]								= (%moscow_tcm_sc00a_05_head);
	
	level.scr_anim["letlev"]["moscow_rs1_rangedweapons"]					= (%moscow_tcm_sc00_11a);
	level.scr_notetrack["letlev"][lnum]["notetrack"]						= "dialog";
	level.scr_notetrack["letlev"][lnum]["anime"]							= "moscow_rs1_rangedweapons";
	level.scr_notetrack["letlev"][lnum]["dialogue"]							= "moscow_rs1_rangedweapons";
	lnum++;
	
	level.scr_anim["letlev"]["moscow_rs1_shootingrange"]					= (%Moscow_tcm_sc00_11);
	level.scr_notetrack["letlev"][lnum]["notetrack"]						= "dialog";
	level.scr_notetrack["letlev"][lnum]["anime"]							= "moscow_rs1_shootingrange";
	level.scr_notetrack["letlev"][lnum]["dialogue"]							= "moscow_rs1_shootingrange";
	lnum++;
	
	level.scr_anim["letlev"]["moscow_rs1_imagine"]							= (%moscow_tcm_sc00_12);
	level.scr_notetrack["letlev"][lnum]["notetrack"]						= "dialog";
	level.scr_notetrack["letlev"][lnum]["anime"]							= "moscow_rs1_imagine";
	level.scr_notetrack["letlev"][lnum]["dialogue"]							= "moscow_rs1_imagine";
	lnum++;
	
	level.scrsound["letlev"]["moscow_rs1_toomanybottles"]			= "moscow_rs1_toomanybottles";
	level.scrsound["letlev"]["moscow_rs1_germanhelmets"]			= "moscow_rs1_germanhelmets";
	level.scrsound["letlev"]["moscow_rs1_expecttokill"]				= "moscow_rs1_expecttokill";
	
	level.scr_anim["letlev"]["moscow_rs1_ads2"]								= (%moscow_tcm_sc00_09);
	level.scr_notetrack["letlev"][lnum]["notetrack"]						= "dialog";
	level.scr_notetrack["letlev"][lnum]["anime"]							= "moscow_rs1_ads2";
	level.scr_notetrack["letlev"][lnum]["dialogue"]							= "moscow_rs1_ads";
	lnum++;
	
	level.scrsound["letlev"]["moscow_rs1_ads"]						= "moscow_rs1_ads";
	level.scr_face["letlev"]["moscow_rs1_ads"]						= (%moscow_tcm_sc00_09_head);
		
	level.scr_anim["letlev"]["moscow_rs1_difficultytest1"]					= (%moscow_tcm_sc00_17a);
	level.scr_notetrack["letlev"][lnum]["notetrack"]						= "dialog";
	level.scr_notetrack["letlev"][lnum]["anime"]							= "moscow_rs1_difficultytest1";
	level.scr_notetrack["letlev"][lnum]["dialogue"]							= "moscow_rs1_difficultytest1";
	lnum++;
	
	level.scr_anim["letlev"]["moscow_rs1_difficultytest2"]					= (%moscow_tcm_sc00_17b);
	level.scr_notetrack["letlev"][lnum]["notetrack"]						= "dialog";
	level.scr_notetrack["letlev"][lnum]["anime"]							= "moscow_rs1_difficultytest2";
	level.scr_notetrack["letlev"][lnum]["dialogue"]							= "moscow_rs1_difficultytest2";
	lnum++;
	
	level.scr_anim["letlev"]["moscow_rs1_difficultytest_idle"][0]			= %moscow_tcm_sc00_17b_idle;
	
	level.scr_anim["letlev"]["moscow_rs1_startbashing"]						= (%moscow_tcm_sc02b_01);
	level.scr_notetrack["letlev"][lnum]["notetrack"]						= "dialog";
	level.scr_notetrack["letlev"][lnum]["anime"]							= "moscow_rs1_startbashing";
	level.scr_notetrack["letlev"][lnum]["dialogue"]							= "moscow_rs1_startbashing";
	lnum++;
	
	level.scr_anim["letlev"]["moscow_rs1_hitmannequin"]						= (%moscow_rs1_hitmannequin);
	level.scr_notetrack["letlev"][lnum]["notetrack"]						= "dialog";
	level.scr_notetrack["letlev"][lnum]["anime"]							= "moscow_rs1_hitmannequin";
	level.scr_notetrack["letlev"][lnum]["dialogue"]							= "moscow_rs1_hitmannequin";
	lnum++;
	
	level.scr_anim["letlev"]["moscow_rs1_pickupgrenade"]					= (%mos_1a_01_rs1_pickupgrenade_t);
	level.scr_notetrack["letlev"][lnum]["notetrack"]						= "dialog";
	level.scr_notetrack["letlev"][lnum]["anime"]							= "moscow_rs1_pickupgrenade";
	level.scr_notetrack["letlev"][lnum]["dialogue"]							= "moscow_rs1_pickupgrenade";
	lnum++;
	
	level.scr_anim["letlev"]["moscow_rs1_throwpotato"]						= (%mos_1a_05_rs1_throwpotato_t);
	level.scr_notetrack["letlev"][lnum]["notetrack"]						= "dialog";
	level.scr_notetrack["letlev"][lnum]["anime"]							= "moscow_rs1_throwpotato";
	level.scr_notetrack["letlev"][lnum]["dialogue"]							= "moscow_rs1_throwpotato";
	lnum++;
	
	level.scr_anim["letlev"]["moscow_rs1_valuable"]							= (%moscow_tcm_sc01a_03);
	level.scr_notetrack["letlev"][lnum]["notetrack"]						= "dialog";
	level.scr_notetrack["letlev"][lnum]["anime"]							= "moscow_rs1_valuable";
	level.scr_notetrack["letlev"][lnum]["dialogue"]							= "moscow_rs1_valuable";
	lnum++;
	
	level.scr_anim["rs3"]["moscow_rs3_potatoes"]							= (%moscow_rs3_sc01a_02);
	level.scr_notetrack["rs3"][rnum]["notetrack"]							= "dialog";
	level.scr_notetrack["rs3"][rnum]["anime"]								= "moscow_rs3_potatoes";
	level.scr_notetrack["rs3"][rnum]["dialogue"]							= "moscow_rs3_potatoes";
	rnum++;
	
	level.scr_anim["rs3"]["potato_idle"][0]									= (%moscow_rs3_sc01a_02_idle);
	
	level.scr_anim["rs3"]["moscow_rs3_ofcourse"]							= (%moscow_rs3_sc01a_04);
	level.scr_notetrack["rs3"][rnum]["notetrack"]							= "dialog";
	level.scr_notetrack["rs3"][rnum]["anime"]								= "moscow_rs3_ofcourse";
	level.scr_notetrack["rs3"][rnum]["dialogue"]							= "moscow_rs3_ofcourse";
	rnum++;
	
	level.scrsound["letlev"]["moscow_rs1_throwcomp"]				= "moscow_rs1_throwcomp";	
	level.scrsound["letlev"]["moscow_rs1_throwtub"]					= "moscow_rs1_throwtub";
	level.scrsound["letlev"]["moscow_rs1_throwwindow"]				= "moscow_rs1_throwwindow";
	level.scrsound["letlev"]["moscow_rs1_throwdoor"]				= "moscow_rs1_throwdoor";
	
	
	level.scr_anim["letlev"]["moscow_rs1_comewithme"]						= (%mos_2a_03_rs1_comewithme_t);
	level.scr_notetrack["letlev"][lnum]["notetrack"]						= "dialog";
	level.scr_notetrack["letlev"][lnum]["anime"]							= "moscow_rs1_comewithme";
	level.scr_notetrack["letlev"][lnum]["dialogue"]							= "moscow_rs1_comewithme";
	lnum++;
	
	level.scrsound["rs4"]["moscow_rs4_comradecommissar"]			= "moscow_rs4_comradecommissar";
	
	level.scr_anim["rs4"]["moscow_rs4_gotprisoner"]							= (%moscow_rs4_sc02a_02);
	level.scr_notetrack["rs4"][tnum]["notetrack"]							= "dialog";
	level.scr_notetrack["rs4"][tnum]["anime"]								= "moscow_rs4_gotprisoner";
	level.scr_notetrack["rs4"][tnum]["dialogue"]							= "moscow_rs4_gotprisoner";
	tnum++;	
	
	level.scrsound["german"]["moscow_gs3_pleasenomore"]				= "moscow_gs3_pleasenomore";
	level.scrsound["german"]["moscow_gs3_ourforces"]				= "moscow_gs3_ourforces";
	level.scrsound["german"]["moscow_gs3_mobilearty"]				= "moscow_gs3_mobilearty";
	
	level.scr_anim["guard"]["moscow_rs3_theirforces"]						= (%moscow_rs3_sc02a_09a);
	level.scr_notetrack["guard"][gnum]["notetrack"]							= "dialog";
	level.scr_notetrack["guard"][gnum]["anime"]								= "moscow_rs3_theirforces";
	level.scr_notetrack["guard"][gnum]["dialogue"]							= "moscow_rs3_theirforces";
	gnum++;
	
	level.scr_anim["guard"]["moscow_rs3_theyhaveus"]						= (%moscow_rs3_sc02a_09c);
	level.scr_notetrack["guard"][gnum]["notetrack"]							= "dialog";
	level.scr_notetrack["guard"][gnum]["anime"]								= "moscow_rs3_theyhaveus";
	level.scr_notetrack["guard"][gnum]["dialogue"]							= "moscow_rs3_theyhaveus";
	gnum++;

	level.scr_anim["letlev"]["moscow_rs1_armory"]							= (%moscow_tcm_sc02a_11);
	level.scr_notetrack["letlev"][lnum]["notetrack"]						= "dialog";
	level.scr_notetrack["letlev"][lnum]["anime"]							= "moscow_rs1_armory";
	level.scr_notetrack["letlev"][lnum]["dialogue"]							= "moscow_rs1_armory";
	lnum++;
	
	level.scr_anim["rs4"]["moscow_rs4_seriousattack"]						= (%moscow_rs4_sc02a_10);
	level.scr_notetrack["rs4"][tnum]["notetrack"]							= "dialog";
	level.scr_notetrack["rs4"][tnum]["anime"]								= "moscow_rs4_seriousattack";
	level.scr_notetrack["rs4"][tnum]["dialogue"]							= "moscow_rs4_seriousattack";
	tnum++;

	level.scr_anim["rs4"]["listen"][0]								= (%moscow_rs4_idle);
	level.scr_anim["rs4"]["go"]										= (%moscow_rs4_finish);
	
	level.scrsound["rs4"]["moscow_rs4_toonarrow"]					= "moscow_rs4_toonarrow";
	level.scrsound["rs4"]["moscow_rs4_upladder"]					= "moscow_rs4_upladder";
	
	level.scr_anim["rs4"]["moscow_rs4_grabsmg"]								= (%moscow_rs4_grabsmg);
	level.scr_notetrack["rs4"][tnum]["notetrack"]							= "dialog";
	level.scr_notetrack["rs4"][tnum]["anime"]								= "moscow_rs4_grabsmg";
	level.scr_notetrack["rs4"][tnum]["dialogue"]							= "moscow_rs4_grabsmg";
	tnum++;	
	
	level.scr_anim["rs4"]["moscow_rs3_pickupsmoke"]							= (%moscow_sc07a_02);
	level.scr_notetrack["rs4"][tnum]["notetrack"]							= "dialog";
	level.scr_notetrack["rs4"][tnum]["anime"]								= "moscow_rs3_pickupsmoke";
	level.scr_notetrack["rs4"][tnum]["dialogue"]							= "moscow_rs3_pickupsmoke";
	tnum++;

	level.scr_anim["rs4"]["moscow_rs3_pickupsubgun"]						= (%moscow_sc07a_03);
	level.scr_notetrack["rs4"][tnum]["notetrack"]							= "dialog";
	level.scr_notetrack["rs4"][tnum]["anime"]								= "moscow_rs3_pickupsubgun";
	level.scr_notetrack["rs4"][tnum]["dialogue"]							= "moscow_rs3_pickupsubgun";
	tnum++;
	
	level.scr_anim["rs4"]["moscow_rs3_pickuphand"]							= (%moscow_sc07a_03b);
	level.scr_notetrack["rs4"][tnum]["notetrack"]							= "dialog";
	level.scr_notetrack["rs4"][tnum]["anime"]								= "moscow_rs3_pickuphand";
	level.scr_notetrack["rs4"][tnum]["dialogue"]							= "moscow_rs3_pickuphand";
	tnum++;

	level.scr_anim["rs4"]["corner_right_idle"][0]					= %corner_right_stand_alertidle;
	level.scr_anim["rs4"]["corner_right"]							= %corner_right_stand_alertidle;
	
	level.scr_anim["rs4"]["moscow_rs4_dontrunout"]							= (%moscow_rs4_sc04a_03_head);
	level.scr_notetrack["rs4"][tnum]["notetrack"]							= "dialog";
	level.scr_notetrack["rs4"][tnum]["anime"]								= "moscow_rs4_dontrunout";
	level.scr_notetrack["rs4"][tnum]["dialogue"]							= "moscow_rs4_dontrunout";
	tnum++;

	level.scrsound["rs4"]["moscow_rs4_toofar"]						= "moscow_rs4_toofar";
	level.scrsound["rs4"]["moscow_rs4_tooclose"]					= "moscow_rs4_tooclose";
	level.scrsound["rs4"]["moscow_rs4_toofarleft"]					= "moscow_rs4_toofarleft";
	level.scrsound["rs4"]["moscow_rs4_toofarright"]					= "moscow_rs4_toofarright";	
	level.scrsound["rs4"]["moscow_rs4_whatyoudoing"]				= "moscow_rs4_whatyoudoing";
	
	level.scr_anim["rs4"]["moscow_rs3_moresmoke"]							= (%moscow_rs3_sc07a_04);
	level.scr_notetrack["rs4"][tnum]["notetrack"]							= "dialog";
	level.scr_notetrack["rs4"][tnum]["anime"]								= "moscow_rs3_moresmoke";
	level.scr_notetrack["rs4"][tnum]["dialogue"]							= "moscow_rs3_moresmoke";
	tnum++;
		
	level.scr_anim["rs4"]["moscow_rs4_waitforsmoke"]						= (%moscow_rs4_sc04a_09_waitforsmoke);
	level.scr_notetrack["rs4"][tnum]["notetrack"]							= "dialog";
	level.scr_notetrack["rs4"][tnum]["anime"]								= "moscow_rs4_waitforsmoke";
	level.scr_notetrack["rs4"][tnum]["dialogue"]							= "moscow_rs4_waitforsmoke";
	tnum++;
	
	level.scr_anim["rs4"]["moscow_rs4_holdpositions"]						= (%moscow_rs4_sc04a_10_holdyourfire);
	level.scr_notetrack["rs4"][tnum]["notetrack"]							= "dialog";
	level.scr_notetrack["rs4"][tnum]["anime"]								= "moscow_rs4_holdpositions";
	level.scr_notetrack["rs4"][tnum]["dialogue"]							= "moscow_rs4_holdpositions";
	tnum++;
	
	level.scrsound["rs4"]["moscow_rs4_letsgo"]						= "moscow_rs4_letsgo";
	
	level.scrsound["rs4"]["moscow_rs4_panzerwerfer"]				= "moscow_rs4_panzerwerfer";
	
	level.scr_anim["generic"]["moscow_rs3_gate"]							= (%moscow_rs3_sc06a_03);
	level.scr_notetrack["generic"][0]["notetrack"]							= "dialog";
	level.scr_notetrack["generic"][0]["anime"]								= "moscow_rs3_gate";
	level.scr_notetrack["generic"][0]["dialogue"]							= "moscow_rs3_gate";
	
	level.scr_anim["letlev"]["moscow_rs1_nobetter"]							= (%moscow_tcm_sc08a_02);
	level.scr_notetrack["letlev"][lnum]["notetrack"]						= "dialog";
	level.scr_notetrack["letlev"][lnum]["anime"]							= "moscow_rs1_nobetter";
	level.scr_notetrack["letlev"][lnum]["dialogue"]							= "moscow_rs1_nobetter";
	lnum++;
	
	level.scr_anim["letlev"]["moscow_rs1_movefaster"]						= (%moscow_tcm_sc01_01);
	level.scr_notetrack["letlev"][lnum]["notetrack"]						= "dialog";
	level.scr_notetrack["letlev"][lnum]["anime"]							= "moscow_rs1_movefaster";
	level.scr_notetrack["letlev"][lnum]["dialogue"]							= "moscow_rs1_movefaster";
	lnum++;
	
	level.scr_anim["letlev"]["moscow_rs1_lookcompass"]						= (%moscow_tcm_sc01_02);
	level.scr_notetrack["letlev"][lnum]["notetrack"]						= "dialog";
	level.scr_notetrack["letlev"][lnum]["anime"]							= "moscow_rs1_lookcompass";
	level.scr_notetrack["letlev"][lnum]["dialogue"]							= "moscow_rs1_lookcompass";
	lnum++;
	
	level.scr_anim["letlev"]["moscow_rs1_storeroom"]						= (%moscow_tcm_sc01_03);
	level.scr_notetrack["letlev"][lnum]["notetrack"]						= "dialog";
	level.scr_notetrack["letlev"][lnum]["anime"]							= "moscow_rs1_storeroom";
	level.scr_notetrack["letlev"][lnum]["dialogue"]							= "moscow_rs1_storeroom";
	lnum++;
	
	level.scrsound["letlev"]["moscow_rs1_gunscold"]					= "moscow_rs1_gunscold";
	level.scrsound["letlev"]["moscow_rs1_testpatience"]				= "moscow_rs1_testpatience";
	level.scrsound["letlev"]["moscow_rs1_lastchance"]				= "moscow_rs1_lastchance";
	
	level.scr_anim["letlev"]["moscow_rs1_goodcompass"]						= (%moscow_tcm_sc01_07);
	level.scr_notetrack["letlev"][lnum]["notetrack"]						= "dialog";
	level.scr_notetrack["letlev"][lnum]["anime"]							= "moscow_rs1_goodcompass";
	level.scr_notetrack["letlev"][lnum]["dialogue"]							= "moscow_rs1_goodcompass";
	lnum++;
	
	level.scrsound["letlev"]["moscow_rs1_goodshot"]							= "moscow_rs1_goodshot";
	
	level.scr_anim["guard"]["moscow_rs3_weaptable"]							= (%moscow_rs3_sc01_08);
	level.scr_notetrack["guard"][gnum]["notetrack"]							= "dialog";
	level.scr_notetrack["guard"][gnum]["anime"]								= "moscow_rs3_weaptable";
	level.scr_notetrack["guard"][gnum]["dialogue"]							= "moscow_rs3_weaptable";
	gnum++;
	
	level.scr_anim["guard"]["moscow_rs3_pickuptable"]						= (%moscow_rs3_sc01_09);
	level.scr_notetrack["guard"][gnum]["notetrack"]							= "dialog";
	level.scr_notetrack["guard"][gnum]["anime"]								= "moscow_rs3_pickuptable";
	level.scr_notetrack["guard"][gnum]["dialogue"]							= "moscow_rs3_pickuptable";
	gnum++;
	
	level.scr_anim["guard"]["moscow_rs3_gobackmove"]						= (%moscow_rs3_sc01_10);
	level.scr_notetrack["guard"][gnum]["notetrack"]							= "dialog";
	level.scr_notetrack["guard"][gnum]["anime"]								= "moscow_rs3_gobackmove";
	level.scr_notetrack["guard"][gnum]["dialogue"]							= "moscow_rs3_gobackmove";
	gnum++;
	
	level.scr_anim["guard"]["block_idle"][0]	= %downtown_sniper_blocking_door_idle;
	level.scr_anim["guard"]["block_idle"][1]	= %downtown_sniper_blocking_door_idle;
	level.scr_anim["guard"]["block_idle"][2]	= %downtown_sniper_blocking_door_idle;
	level.scr_anim["guard"]["block_idle"][3]	= %downtown_sniper_blocking_door_twitch;
}




