#using_animtree("generic_human");
main()
{	
	Plane_Anims();
	SoundAliases();
	Player_Anims();
	
	//level.scr_anim["gunner"]["alive_idle"][0]			= %toujane_german_armored_car_idle;
	level.scr_anim["gunner"]["alive_idle"][0]			= %toujane_german_armored_car_basic_idle;
	
	level.scr_anim["gunner"]["death"]					= %toujane_german_armored_car_death;
	level.scr_anim["gunner"]["death_idle"][0]			= %toujane_german_armored_car_death_pose;
	level.scr_anim["gunner"]["grab"]					= %toujane_german_armored_car_grab;
	level.scr_anim["gunner"]["deathPose"][0]			= %toujane_german_armored_car_death_end_pose;
	
	level.scr_anim["macgregor"]["getin"]				= %toujane_mgreg_armored_car_getin;
	
	level.scr_anim["price"]["getin"]					= %toujane_price_armored_car_getin;
	level.scr_anim["price"]["getinEnd"]					= %toujane_price_armored_car_end_getin;
	level.scr_anim["price"]["sitIdle"][0]				= %toujane_price_armored_car_idle;
	
	level.scr_anim["generic"]["wave"]					= %wave_overhere;	
}

#using_animtree("toujane_ride_player");
Player_Anims()
{
	level.scr_animtree["player"]						= #animtree;
	level.scr_anim["player"]["player_thrown"]			= %player_armored_car_shellshock_explosion;
	level.scr_anim["player"]["player_standup"]			= %player_armored_car_shellshock_standup;
}

#using_animtree("eldaba_dogfight");
Plane_Anims()
{
	level.scr_animtree["dogfight"]		 				= #animtree;
	level.scr_anim["plane rig"]["axis"][0]				= (%eldaba_germanplane_loopA);
	level.scr_anim["plane rig"]["allies"][0]			= (%eldaba_britishplane_loopA);
	
	level.scr_anim["plane rig"]["axis"][1]				= (%eldaba_germanplane_loopB);
	level.scr_anim["plane rig"]["allies"][1]			= (%eldaba_britishplane_loopB);
	
    level.scr_anim["plane rig"]["axis"][2]				= (%eldaba_germanplane_loopC);
	level.scr_anim["plane rig"]["allies"][2]			= (%eldaba_britishplane_loopC);
	
	level.scr_anim["plane rig"]["axis"][3]				= (%eldaba_germanplane_loopD);
	level.scr_anim["plane rig"]["allies"][3]			= (%eldaba_britishplane_loopD);
}

#using_animtree("generic_human");
SoundAliases()
{
	//opening dialogue
	level.scrsound["radio"]["opfivejerriesattack"]	= "toujaneride_radiovoice1_opfivejerriesattack";
	level.scrsound["price"]["davisisntdrill"]		= "toujaneride_price_davisisntdrill";
	level.scr_face["price"]["davisisntdrill"]		= %toujaneride_pri_sc02_01_t5_head;
	level.scrsound["price"]["davisgetonmg"]			= "toujaneride_price_davisgetonmg";
	level.scr_face["price"]["davisgetonmg"]			= %toujaneride_pri_sc04_03_t1_head;
	
	/*
	//todo
	//if player not using mg...
	level.scrsound["price"]["davisareyoudeaf"]		= "toujaneride_price_davisareyoudeaf";
	level.scr_face["price"]["davisareyoudeaf"]		= %toujaneride_pri_sc04_04_t1_head;
	level.scrsound["price"]["corporaldavis"]		= "toujaneride_price_corporaldavis";
	level.scr_face["price"]["corporaldavis"]		= %toujaneride_pri_sc04_05_t1_head;
	*/
	
	//toujaneride_pri_sc09_02_t1_head - "Davis, you're on point..."
	
	//20 mil armored car enters
	level.scrsound["price"]["twentymil"]			= "toujaneride_price_twentymil";
	level.scrsound["macgregor"]["everyonedown"]		= "toujaneride_macgregor_everyonedown";	
	
	//have to leave the building now (and radio is spamming things)
	level.scrsound["radio"]["allreceivingunits"]	= "toujaneride_radiovoice1_allreceivingunits";
	level.scrsound["price"]["flankarmoredcar"]		= "toujaneride_price_flankarmoredcar";
	//level.scr_face["price"]["flankarmoredcar"]		= %toujaneride_pri_sc06_01_t1_head;
	level.scrsound["radio"]["opthreeunderattack"]	= "toujaneride_radiovoice2_opthreeunderattack";
	level.scrsound["price"]["everyoneoutnow"]		= "toujaneride_price_everyoneoutnow";
	level.scrsound["price"]["davisonpoint"]			= "toujaneride_price_davisonpoint";
	level.scrsound["radio"]["thisisopsix"]			= "toujaneride_radiovoice3_thisisopsix";
	
	level.scrsound["price"]["macgregorwheel"]		= "toujaneride_price_macgregorwheel";
	
	
	//-------------------------------------------
	//price and macgregor talk in the armored car
	//-------------------------------------------
	
	//starting it up
	level.scrsound["price"]["whatyouwaitinfor"]		= "toujaneride_price_whatyouwaitinfor";
	level.scrsound["macgregor"]["controlsingerman"]	= "toujaneride_macgregor_controlsingerman";
	level.scrsound["price"]["davistwelveoclock"]	= "toujaneride_price_davistwelveoclock";
	level.scrsound["price"]["youdunce"]				= "toujaneride_price_youdunce";
	level.scrsound["macgregor"]["rightsir"]			= "toujaneride_macgregor_rightsir";
	level.scrsound["macgregor"]["hangon"]			= "toujaneride_macgregor_hangon";
	level.scrsound["price"]["whatonearth"]			= "toujaneride_price_whatonearth";
	level.scrsound["macgregor"]["thankyousir"]		= "toujaneride_macgregor_thankyousir";
	
	//halftrack comes through wall
	level.scrsound["price"]["davishalftrack"]		= "toujaneride_price_davishalftrack";
	level.scrsound["price"]["notbadcorporal"]		= "toujaneride_price_notbadsergeant";
	
	//tank spotted - look out!
	level.scrsound["price"]["lookoutfortank"]		= "toujaneride_price_lookoutfortank";
	level.scrsound["macgregor"]["didyousaytank"]	= "toujaneride_macgregor_didyousaytank";
	level.scrsound["price"]["hespottedus"]			= "toujaneride_price_hespottedus";
	level.scrsound["macgregor"]["dontseetank"]		= "toujaneride_macgregor_dontseetank";
	level.scrsound["price"]["makealeft"]			= "toujaneride_price_makealeft";
	level.scrsound["macgregor"]["ihopeyouknow"]		= "toujaneride_macgregor_ihopeyouknow";
	level.scrsound["price"]["now"]					= "toujaneride_price_now";
	
	level.scrsound["macgregor"]["placelooks"]		= "toujaneride_macgregor_placelooks";
	level.scrsound["price"]["wherewestarted"]		= "toujaneride_price_wherewestarted";
	level.scrsound["price"]["rightturn"]			= "toujaneride_price_rightturn";
	level.scrsound["macgregor"]["yessir"]			= "toujaneride_macgregor_yessir";
	level.scrsound["price"]["hopethisworks"]		= "toujaneride_price_hopethisworks";
	level.scrsound["price"]["keepitsteady"]			= "toujaneride_price_keepitsteady";
	
	//car stalls and tank is going to blow you up
	level.scrsound["macgregor"]["bloodyhell"]		= "toujaneride_macgregor_bloodyhell";
	level.scrsound["price"]["wellgetitstarted"]		= "toujaneride_price_wellgetitstarted";
	level.scrsound["price"]["nowwouldbegood"]		= "toujaneride_price_nowwouldbegood";
	level.scrsound["macgregor"]["doinmebest"]		= "toujaneride_macgregor_doinmebest";
	level.scrsound["price"]["macgregor"]			= "toujaneride_price_macgregor";
	level.scrsound["macgregor"]["thatsdoneit"]		= "toujaneride_macgregor_thatsdoneit";
	
	//dead end and panzerschreck attacks
	level.scrsound["price"]["itsadeadend"]			= "toujaneride_price_itsadeadend";
	
	// at the car crash 
	level.scrsound["price"]["runner"]				= "toujaneride_price_timeforarunner";
	
	//Misc sounds played throughout the drive
	level.scrsound["price"]["leftturnleft"]			= "toujaneride_price_leftturnleft";
	//level.scrsound["macgregor"]["imonit"]			= "toujaneride_macgregor_imonit";
	level.scrsound["price"]["righthere"]			= "toujaneride_price_righthere";
	
	
	//After crash:
	level.scrsound["price"]["toujaneride_pri_maccovertherear"]		= "toujaneride_pri_maccovertherear";
	level.scrsound["macgregor"]["toujaneride_mcg_considerdone"]		= "toujaneride_mcg_considerdone";
	level.scrsound["price"]["toujaneride_pri_pushingrally"]			= "toujaneride_pri_pushingrally";
	level.scrsound["soldier"]["toujaneride_bs4_laddertorear"]		= "toujaneride_bs4_laddertorear";
	level.scrsound["price"]["toujaneride_pri_wheresrallypoint"]		= "toujaneride_pri_wheresrallypoint";
	level.scrsound["soldier"]["toujaneride_bs4_rallytosouth"]		= "toujaneride_bs4_rallytosouth";
	level.scrsound["macgregor"]["toujaneride_mcg_smoketonorth"]		= "toujaneride_mcg_smoketonorth";
	level.scrsound["price"]["toujaneride_pri_notimeforthat"]		= "toujaneride_pri_notimeforthat";
	level.scrsound["soldier"]["toujaneride_bs4_lasttruck"]			= "toujaneride_bs4_lasttruck";
	level.scrsound["price"]["toujaneride_price_backforthistown"]	= "toujaneride_price_backforthistown";
	level.scrsound["macgregor"]["toujaneride_mcg_teachthose"]		= "toujaneride_mcg_teachthose";
	level.scrsound["price"]["toujaneride_pri_rallyjustahead"]		= "toujaneride_pri_rallyjustahead";
	level.scrsound["macgregor"]["toujaneride_mcg_totallyoutnumbered"]	= "toujaneride_mcg_totallyoutnumbered";
}