#include maps\_anim;

main()
{
	level dialog();	
}

#using_animtree("generic_human");
dialog()
{
	level.scr_sound["marine1"]["meetsquad"] = "training_ge1_senttorelieve";
	level.scr_sound["marine1"]["squadwaiting"] = "training_ge1_squadiswaiting";

	level.scr_sound["smith"]["firstsquad"] = "training_sth_firstsquadnext";
	level.scr_sound["smith"]["getinformation"] = "training_sth_getinformation";
	level.scr_sound["smith"]["getinline"] = "training_sth_getinline";
	level.scr_sound["smith"]["gogogo"] = "training_sth_gogogo";
	level.scr_sound["smith"]["crouch"] = "training_sth_duckunderobstacles";
	level.scr_sound["smith"]["prone"] = "training_sth_hitthedeck";
	level.scr_sound["smith"]["openfire"] = "training_sth_openfire";
	level.scr_sound["smith"]["sprint"] = "training_sth_sprinttofinish";
	level.scr_sound["smith"]["melee"] = "training_sth_hitemharder";
	level.scr_sound["smith"]["carvermelee"] = "training_sth_hitdummyweapon";
	level.scr_sound["smith"]["gotorange"] = "training_sth_thatsitobstacle";

	level.scr_sound["marine2"]["getammo"] = "training_ge2_ammofromtable";
	level.scr_sound["marine2"]["loadweapon"] = "training_ge2_carverreload";
	level.scr_sound["marine2"]["assignments"] = "training_ge2_mcleodyoureone";
	level.scr_sound["marine2"]["dontfire"] = "training_ge2_dontwantanyfiring";
	level.scr_sound["marine2"]["ceasefire"] = "training_ge2_ceasefire";
	level.scr_sound["marine2"]["isaidcease"] = "training_ge2_isaidcease";
	level.scr_sound["marine2"]["timedtargets"] = "training_ge2_targetspopup";
	level.scr_sound["marine2"]["gotofour"] = "training_ge2_gotofour";
	level.scr_sound["marine2"]["backtostation"] = "training_ge2_backtostation";
	level.scr_sound["marine2"]["aimdownrange"] = "training_ge2_aimdownrange";
	level.scr_sound["marine2"]["aimyourweapon"] = "training_ge2_aimyourweapon";
	level.scr_sound["marine2"]["carverceasefire"] = "training_ge2_ceasefirecarver";
	level.scr_sound["marine2"]["weaponsfree"] = "training_ge2_weaponsfree";
	level.scr_sound["marine2"]["changemags"] = "training_ge2_changemags";
	level.scr_sound["marine2"]["fire"] = "training_ge2_fire";
	level.scr_sound["marine2"]["tooslow"] = "training_ge2_tooslow";
	level.scr_sound["marine2"]["stilltooslow"] = "training_ge2_stilltooslow";
	level.scr_sound["marine2"]["gotorange"] = "training_ge2_sidearmrange";

	level.scr_sound["marine3"]["getammo"] = "training_ge3_secondsquad";
	level.scr_sound["marine3"]["weaponsfree"] = "training_ge3_weaponsfree";
	level.scr_text["marine3"]["usesidearm"] = &"MARINE3_USE_SIDEARM";
	level.scr_sound["marine3"]["gotomout"] = "training_ge3_ceasefire";
	level.scr_sound["marine3"]["penetratesome"] = "training_ge3_penetratesomematerials";
	level.scr_sound["marine3"]["stowsidearm"] = "training_ge3_stowsidearm";
	level.scr_sound["marine3"]["hittarget"] = "training_ge3_hittargetfourtimes";
	level.scr_sound["marine3"]["alrightweaponsfree"] = "training_ge3_allrightweaponsfree";
	

	level.scr_sound["marine4"]["getammo"] = "training_ge4_pickupgrenades";
	level.scr_sound["marine4"]["firstwindow"] = "training_ge4_grenadefirstwindow";
	level.scr_sound["marine4"]["firstwindowagain"] = "training_ge4_tryfirstwindow";
	level.scr_sound["marine4"]["secondwindow"] = "training_ge4_fragsecondwindow";
	level.scr_sound["marine4"]["secondwindowagain"] = "training_ge4_stillsecondwindow";
	level.scr_sound["marine4"]["dumpster"] = "training_ge4_throwdumpster";
	level.scr_sound["marine4"]["dumpsteragain"] = "training_ge4_grenadedumpster";
	level.scr_sound["marine4"]["gotorange"] = "training_ge4_gainesgrenades";
	
	level.scr_sound["marine5"]["getammo"] = "training_ge5_pickupm16a4";
	level.scr_sound["marine5"]["useonwall"] = "training_ge5_usem203";
	level.scr_sound["marine5"]["didntexplode"] = "training_ge5_didntexplode";
	level.scr_sound["marine5"]["othertargets"] = "training_ge5_twothreefour";
	level.scr_sound["marine5"]["hittwo"] = "training_ge5_stilltargettwo";
	level.scr_sound["marine5"]["hitthree"] = "training_ge5_stilltargetthree";
	level.scr_sound["marine5"]["hitfour"] = "training_ge5_stilltargetfour";
	level.scr_sound["marine5"]["oorah"] = "training_ge5_oohrah";
	level.scr_sound["marine5"]["getdetpack"] = "training_ge5_pickupdetpack";
	level.scr_sound["marine5"]["carvergetdetpack"] = "training_ge5_pickupexplosive";
}