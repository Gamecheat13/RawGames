#include maps\_anim;
#using_animtree("generic_human");

main()
{
	level.scr_anim["soldier3"]["plantbomb"]	= (%demolition_hall_plant_tnt_1);

	level.scr_anim["engineer"]["plant"]						= %demolition_hall_plant_tnt_1;
	level.scr_anim["engineer"]["crouch"]					= %demolition_hall_tntcrouch;
	level.scr_anim["engineer"]["idle"][0]					= %demolition_hall_checktnt;
	level.scr_anim["engineer"]["stand"]						= %demolition_hall_tntgetup;

	level.scrsound["soldier4"]["depot"] = "decoytrench_bs4_supplydepot";
	level.scrsound["soldier4"]["wipeout"] = "decoytrench_bs4_wipeout";
	level.scr_anim["soldier4"]["wipeout"] = %decoytrench_thisisit;

	level.scrsound["soldier4"]["plantexp"] = "decoytrench_bs4_plantexp";

	level.scrsound["soldier4"]["stopmg"] = "decoytrench_stopmg";

	level.scrsound["soldier4"]["clearthosebunkers"] = "decoytrench_clearthosebunkers";

	level.scrsound["soldier4"]["linkup"] = "decoytrench_bs4_linkup";
	
	level.scrsound["price"]["givedaviscover"] = "decoytrench_pri_givedaviscover";
	
	level.scrsound["price"]["goodtosee"] = "decoytrench_pri_goodtosee";

	level.scrsound["price"]["ammodump"]	= "decoytrench_pri_takeoutammo";
	level.scrsound["macgregor"]["ammodump"]	= "decoytrench_mcg_whatthebloodyhell";
	
	level.scrsound["price"]["shootfuel"] = "decoytrench_pri_shootfuel";
	level.scrsound["price"]["bunkers"] = "decoytrench_pri_bunkers";

	level.scrsound["soldier4"]["getbunkeropen"] = "decoytrench_bs4_getbunkeropen";
	level.scrsound["soldier3"]["getbunkeropen"] = "decoytrench_bs2_yessirbunkerdoor";

	level.scrsound["price"]["checkbunker"] 			= "decoytrench_pri_checkbunker";
	level.scrsound["macgregor"]["stupidmaps"]		= "decoytrench_mcg_stupidmaps";
	level.scrsound["price"]["shutitmac"] 			= "decoytrench_pri_shutitmac";
	level.scrsound["macgregor"]["but"]				= "decoytrench_mcg_but";
	level.scrsound["price"]["keepmouthshut"] 		= "decoytrench_pri_keepmouthshut";

	level.scr_anim["price"]["idle"][0]	= %stand_alertb_idle1;

	level.scr_anim["soldier1"]["needintown"]			= %decoytrench_bs1_sc06_01;
	addNotetrack_dialogue("soldier1", "dialog", "needintown", "decoytrench_bs1_neededintown");

	level.scr_anim["price"]["bloodyhardfight"]			= %decoytrench_pri_sc06_02_t2;
	addNotetrack_dialogue("price", "dialog", "bloodyhardfight", "decoytrench_pri_bloodyhardfight");
	
	level.scr_anim["soldier1"]["yessir"]				= %decoytrench_bs1_sc06_03;
	addNotetrack_dialogue("soldier1", "dialog", "yessir", "decoytrench_bs1_yessir");
	
	level.scr_anim["price"]["getinbrencarrier"] 		= %decoytrench_pri_sc06_04;
	addNotetrack_dialogue("price", "dialog", "getinbrencarrier", "decoytrench_pri_getinbrencarrier");
}
