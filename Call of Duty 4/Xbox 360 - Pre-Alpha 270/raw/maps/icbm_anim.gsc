#using_animtree("generic_human");

main()
{
	anims();
	tower_explode_anims();
	//run_anims();
	
	//Price - Haggerty, you see where Griggs landed?
	level.scr_sound[ "price" ][ "grigsby_landed" ]				= "icbm_us_lead_griggslanded";
	
	//Marine1 - Yeah, over by the buildings to the east. You think they got him?
	level.scr_sound[ "generic" ][ "bybuildingseast" ]				= "icbm_gm1_bybuildingseast";
	
	//Price - We're about to find out. Haggerty, take point
	level.scr_sound[ "price" ][ "abouttofindout" ]				= "icbm_us_lead_abouttofindout";
	
	//Marine1 - You got it sir
	level.scr_sound[ "generic" ][ "yougotit" ]				= "icbm_gm1_yougotit";
	
	//Marine1 - Contact front. Enemy vehicle.
	level.scr_sound[ "generic" ][ "enemyvehicle" ]				= "icbm_gm1_enemyvehicle";
	
	//Price - Move
	level.scr_sound[ "price" ][ "move" ]				= "icbm_us_lead_move";
	
	//Price - Keep it quiet
	level.scr_sound[ "price" ][ "keepitquiet" ]				= "icbm_us_lead_keepitquiet";
	
	//Marine1 - Room clear
	level.scr_sound[ "generic" ][ "roomclear" ]				= "icbm_gm1_roomclear";
	
	//Marine2 - Room clear
	level.scr_sound[ "generic" ][ "roomclear2" ]				= "icbm_gm2_roomclear";
	
	//Marine1 - Roger
	level.scr_sound[ "generic" ][ "roger" ]				= "icbm_gm1_roger";
	
	//Marine2 - building1 clear
	level.scr_sound[ "generic" ][ "building1clear" ]				= "icbm_gm1_building1clear";
	
	//Marine1 - Tango down
	level.scr_sound[ "generic" ][ "tangodown" ]				= "icbm_gm1_tangodown";
	
	//Marine1 - Copy that
	level.scr_sound[ "generic" ][ "copythat" ]				= "icbm_gm3_copythat";
	
	//Marine1 - Copy that
	level.scr_sound[ "generic" ][ "copythat" ]				= "icbm_gm3_copythat";
	
		
	//Price - Lets go
	level.scr_sound[ "price" ][ "letsgo" ]				= "icbm_us_lead_letsgo";
	
	//Marine2 - Contact
	level.scr_sound[ "generic" ][ "contact" ]				= "icbm_gm1_contact";
	
	//Marine2 - All Clear
	level.scr_sound[ "generic" ][ "allclear" ]				= "icbm_gm1_allclear";
	
	//Marine2 - Building 2 secured
	level.scr_sound[ "generic" ][ "building2secured" ]				= "icbm_gm2_building2secured";
	
	
	//Mark - Leave me behind
	level.scr_sound[ "mark" ][ "leavemebehind" ]				= "icbm_grg_leavemebehind";
	
	//Price - That was the plan
	level.scr_sound[ "price" ][ "wastheplan" ]				= "icbm_us_lead_wastheplan";
	
	//Mark - Good to go
	level.scr_sound[ "mark" ][ "goodtogo" ]				= "icbm_grg_goodtogo";
	
	//Price - That was the plan
	level.scr_sound[ "price" ][ "gotgriggs" ]				= "icbm_us_lead_gotgriggs";
	
	//Marine2 - Choppers
	level.scr_sound[ "generic" ][ "enemyhelicopters" ]				= "icbm_gm1_enemyhelicopters";
	
	//Price - Slicks in bound
	level.scr_sound[ "price" ][ "slicksinbound" ]				= "icbm_us_lead_slicksinbound";
	
	//Price - Status
	level.scr_sound[ "price" ][ "status" ]				= "icbm_us_lead_status";
	
	//Prices radio - Kill power
	level.scr_sound[ "price" ][ "killthepower" ]				= "icbm_pri_killthepower";
	
	//Price - Roger. Jackson. Griggs. Plant the charges. Go
	level.scr_sound[ "price" ][ "jackgriggsplant" ]				= "icbm_us_lead_jackgriggsplant";
	 
	 //Mark - Charges set. Everyone get clear
	level.scr_sound[ "mark" ][ "chargesset" ]				= "icbm_grg_chargesset";
	
	//Price - Jackson DO IT!
	level.scr_sound[ "price" ][ "doit" ]				= "icbm_us_lead_doit";
	
	//Price - Team Two, the tower's down and the power's out. Twenty seconds.
	level.scr_sound[ "price" ][ "towersdown" ]				= "icbm_us_lead_towersdown";
	
	//Price radio - Roger. We're breaching the perimeter. Standby.
	level.scr_sound[ "price" ][ "breachingperimeter" ]				= "icbm_pri_breachingperimeter";
	
	//Price radio - standby
	level.scr_sound[ "price" ][ "standby" ]				= "icbm_pri_standby";
	
	//Mark - Backup power in ten seconds…
	level.scr_sound[ "mark" ][ "backuppower" ]				= "icbm_grg_backuppower";	
	
	//Mark - Five seconds…
	level.scr_sound[ "mark" ][ "fiveseconds" ]				= "icbm_grg_fiveseconds";
	
	//Price radio - Meet at rallypoint
	level.scr_sound[ "price" ][ "rallypoint" ]				= "icbm_pri_rallypoint";
	
	//Price - Roger Team Two, we're on our way. Out
	level.scr_sound[ "price" ][ "onourway" ]				= "icbm_us_lead_onourway";
	
	//Mark - Backup power's online. Damn that was close!
	level.scr_sound[ "mark" ][ "poweronline" ]				= "icbm_grg_poweronline";
	
	//Price - Grigsby, Haggerty chop the fence
	//level.scr_sound[ "price" ][ "onourway" ]				= "icbm_us_lead_onourway";
	
	//Marine4 - Team One, this is Team Two.  Three trucks packed with shooters are headed your way.
	level.scr_sound[ "price" ][ "truckswithshooters" ]				= "icbm_pri_truckswithshooters";	
	
	//Price - Movein
	level.scr_sound[ "price" ][ "movin" ]				= "icbm_us_lead_movin";	
	
	//Price - Copy. We're entering the old base now. Standby.
	level.scr_sound[ "price" ][ "approachingbase" ]				= "icbm_us_lead_approachingbase";
	
	//Marine1 - I have a visual on the trucks. There's a shitload of troops sir.
	level.scr_sound[ "generic" ][ "haveavisual" ]				= "icbm_gm1_haveavisual";
	
	//Price - All right squad, you know the drill.  Griggs, you're with Jackson. Haggerty, on me. Move.
	level.scr_sound[ "price" ][ "youknowdrill" ]				= "icbm_us_lead_youknowdrill";	
	
	//Marin1 - What the hell…
	level.scr_sound[ "generic" ][ "whatthe" ]				= "icbm_gm1_whatthe";
	
	//Mark - What the hell…
	level.scr_sound[ "mark" ][ "problemhere" ]				= "icbm_grg_problemhere";
	
	//Price - Delta One X-Ray, we have a missile launch, I repeat we have a missile
	level.scr_sound[ "price" ][ "onemissile" ]				= "icbm_us_lead_onemissile";
	
	//Mark - There's another one!
	level.scr_sound[ "mark" ][ "anotherone" ]				= "icbm_grg_anotherone";
	
	//Price - Delta One X-Ray - we have two missiles in the air over!
	level.scr_sound[ "price" ][ "twomissiles" ]				= "icbm_us_lead_twomissiles";
	
	//HQ on Price's Radio
	level.scr_sound[ "price" ][ "gettingabortcodes" ]				= "icbm_hqr_gettingabortcodes";
	
	//Mark - Shits hit the fan now
	level.scr_sound[ "mark" ][ "itsonnow" ]				= "icbm_grg_itsonnow";
	
	//Price - You're tellin' me…. Let's go! We gotta move!
	level.scr_sound[ "price" ][ "youretellinme" ]				= "icbm_us_lead_youretellinme";
	
	//Marine3 - I have a visual on the trucks. There's a shitload of troops sir.
	level.scr_sound[ "generic" ][ "enemyinsight" ]				= "icbm_gm3_enemyinsight";		
}

anims()
{

	// First house
	level.scr_anim[ "price" ][ "hunted_open_barndoor" ] =			%hunted_open_barndoor;
	level.scr_anim[ "price" ][ "hunted_open_barndoor_stop" ] =		%hunted_open_barndoor_stop;
	level.scr_anim[ "price" ][ "hunted_open_barndoor_idle" ][0] =	%hunted_open_barndoor_idle;
	

}

#using_animtree( "icbm" );
tower_explode_anims()
{
	level.scr_animtree[ "tower_explosion" ]		= #animtree;
	level.scr_anim[ "tower" ][ "explosion" ]		= %ICBM_power_tower_crash;
}
