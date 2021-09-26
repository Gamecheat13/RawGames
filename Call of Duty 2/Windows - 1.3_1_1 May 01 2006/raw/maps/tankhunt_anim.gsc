#include maps\_anim;
#using_animtree("generic_human");

main()
{
	level.scr_anim["gunguy"]["grenadetank"]						= (%panzertank2_runup_gunguy);
	level.scr_anim["gunguy"]["grenadetank_run"]					= (%panzertank2_hatchopencloseandrun_gunguy);

	level.scr_anim["runupguy"]["grenadetank"]					= (%panzertank2_runup_grenadeguy);
	level.scr_anim["runupguy"]["grenadetank_loop"][0]			= (%panzertank2_waitloop_grenadeguy);
	level.scr_anim["runupguy"]["grenadetank_run"]				= (%panzertank2_hatchopencloserun_grenadeguy);

	level.scrsound["runupguy"]["demolition_rs4_motherrussia"]	= "demolition_rs4_motherrussia";
	level.scrsound["runupguy"]["commissar_charge_killfascists"]	= "commissar_charge_killfascists";
	level.scrsound["runupguy"]["commissar_charge_attack"]		= "commissar_charge_attack";
	level.scrsound["runupguy"]["moscow_rs3_fireinthehole"]	 	= "moscow_rs3_fireinthehole";

	addNotetrack_customFunction("gunguy", "fire = open_hatch", ::shootGun, "grenadetank_run");
	addNotetrack_sound("runupguy", "weap_fraggrenade_pin", "grenadetank_run", "weap_fraggrenade_pin");
	addNotetrack_sound("runupguy", "weap_fraggrenade_fire", "grenadetank_run", "weap_fraggrenade_fire");
	addNotetrack_sound("runupguy", "open_hatch", "grenadetank_run", "tank_hatch");

	level.scr_anim["generic"]["nade_throw"]	 					= (%stand_grenade_throw);

	level.scrsound["generic"]["mg42_warning"]	 				= "RU_0_threat_emplacement_mg42";
	level.scrsound["generic"]["mg42_location"]	 				= "RU_0_landmark_near_rubble";

	level.scrsound["generic"]["tankhunt_rs3_usegrenades"]	 	= "tankhunt_rs3_usegrenades";
	level.scr_text["generic"]["tankhunt_rs3_usegrenades"]		= "Use your grenades!!!";

	level.scrsound["generic"]["tankhunt_rs3_cablebreaches"]	 	= "tankhunt_rs3_cablebreaches";
	level.scr_text["generic"]["tankhunt_rs3_cablebreaches"]		= "We must have missed some cable breaches along the way.  Vasili, Let's go back and fix them.";

	level.scrsound["generic"]["tankhunt_rs3_pickupbombs"]	 	= "tankhunt_rs3_pickupbombs";
	level.scr_text["generic"]["tankhunt_rs3_pickupbombs"]		= "Pick up the sticky bombs Vasili, quickly! They're on top of the crates next to the field phone.";


	level.scrsound["volsky"]["tankhunt_volsky_repairthewire"]	= "tankhunt_volsky_repairthewire";
	level.scr_text["volsky"]["tankhunt_volsky_repairthewire"]	= "Vasili! Take 2nd squad and repair the field phone wire! I'll clear these buildings with 1st squad and meet you on the other side! Go!";

	level.scrsound["volsky"]["tankhunt_volsky_repairthewire"]	= "tankhunt_volsky_repairthewire";
	level.scr_text["volsky"]["tankhunt_volsky_repairthewire"]	= "Vasili! Take 2nd squad and repair the field phone wire! I'll clear these buildings with 1st squad and meet you on the other side! Go!";

	level.scrsound["volsky"]["tankhunt_volsky_penzenskaiast"]	= "tankhunt_volsky_penzenskaiast";
	level.scr_text["volsky"]["tankhunt_volsky_penzenskaiast"]	= "Comrades! This way! We're needed at the trainyard! Let's go!";

}


shootGun(guy)
{
	guy shoot();
	wait .15;
	if (guy.weapon != "mosin_nagant")
		guy shoot();
	wait .2;
	if (guy.weapon != "mosin_nagant")
		guy shoot();
	wait .3;
	if (guy.weapon != "mosin_nagant")
		guy shoot();
	wait .2;
	guy shoot();
}