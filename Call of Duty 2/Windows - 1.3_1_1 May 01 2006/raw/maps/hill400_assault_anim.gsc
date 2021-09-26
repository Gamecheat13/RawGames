#using_animtree("generic_human");

main()
{	
	//PVT. BRAEBURN
	//Man, I don’t get it. If they need officers, why not promote the Sarge?
	//See that green L.T. over there? That F.N.G. couldn’t lead us out of a paper bag. 
	//Never mind... just watch your sector.
	level.scr_anim["braeburn"]["hill400_dialogue_scene1"]	= (%hill400_dialogue_scene1_guy2);
	level.scr_notetrack["braeburn"][0]["notetrack"]			= "dialogue01";
	level.scr_notetrack["braeburn"][0]["anime"]				= "hill400_dialogue_scene1";
	level.scr_notetrack["braeburn"][0]["dialogue"]			= "hill400_assault_braeburn_idontgetit";
	level.scr_notetrack["braeburn"][1]["notetrack"]			= "dialogue03";
	level.scr_notetrack["braeburn"][1]["anime"]				= "hill400_dialogue_scene1";
	level.scr_notetrack["braeburn"][1]["dialogue"]			= "hill400_assault_braeburn_paperbag";
	level.scr_notetrack["braeburn"][2]["notetrack"]			= "dialogue05";
	level.scr_notetrack["braeburn"][2]["anime"]				= "hill400_dialogue_scene1";
	level.scr_notetrack["braeburn"][2]["dialogue"]			= "hill400_assault_braeburn_nevermind";

	//PVT. MCCLOSKEY
	//What do you mean, Braeburn?
	//What bag? Huh? What’re you talkin’ about?
	//Ok!
	level.scr_anim["mccloskey"]["hill400_dialogue_scene1"]	= (%hill400_dialogue_scene1_guy1);
	level.scr_notetrack["mccloskey"][0]["notetrack"]		= "dialogue02";
	level.scr_notetrack["mccloskey"][0]["anime"]			= "hill400_dialogue_scene1";
	level.scr_notetrack["mccloskey"][0]["dialogue"]			= "hill400_assault_mccloskey_whatdoyoumean";
	level.scr_notetrack["mccloskey"][1]["notetrack"]		= "dialogue04";
	level.scr_notetrack["mccloskey"][1]["anime"]			= "hill400_dialogue_scene1";
	level.scr_notetrack["mccloskey"][1]["dialogue"]			= "hill400_assault_mccloskey_whatbag";
	level.scr_notetrack["mccloskey"][2]["notetrack"]		= "dialogue06";
	level.scr_notetrack["mccloskey"][2]["anime"]			= "hill400_dialogue_scene1";
	level.scr_notetrack["mccloskey"][2]["dialogue"]			= "hill400_assault_mccloskey_ok";
	
	//Scout runs out and gets shot. Braeburn and McCloskey pull him back.
	level.scr_anim["mcallister"]["hill400_scoutscene"]		= (%hill400_scoutscene_scout);
	level.scr_anim["braeburn"]["hill400_scoutscene"]		= (%hill400_scoutscene_guy2);
	level.scr_anim["mccloskey"]["hill400_scoutscene"]		= (%hill400_scoutscene_guy1);

//	level.scr_anim["henderson"]["hill400_runandwave"]		= (%dawn_moody_run_and_wave);

	level dialogue();
}

dialogue()
{
	
	//1st SGT RANDALL
	//What are your orders sir?
	level.scrsound["randall"]["hill400_assault_rnd_whatareorders"]				= "hill400_assault_rnd_whatareorders";
	
	//2nd LT. MYERS
	//SHUT UP!*
	level.scrsound["myers"]["hill400_assault_myers_shutup"]			= "hill400_assault_myers_shutup";
	
	//PVT. MCALLISTER
	//Well you better think fast... 
	level.scrsound["gr1"]["hill400_assault_cof_thinkfast"]				= "hill400_assault_cof_thinkfast";
		
	//2nd SGT RANDALL
	//we can't sit here...
	level.scrsound["randall"]["hill400_assault_rnd_wecantsithere"]		= "hill400_assault_rnd_wecantsithere";
		
	//PVT. MCALLISTER
	//Yes sir!
	level.scrsound["mcallister"]["hill400_assault_mcallister_yessir"]		= "hill400_assault_mcallister_yessir";

	//2nd SGT RANDALL
	//"Hold right here! Wait for them to reload!"
	level.scrsound["randall"]["hill400_assault_rnd_holdrighthere"]				= "hill400_assault_rnd_holdrighthere";

	//PVT. MCALLISTER
	//Right away sir!
	level.scrsound["mcallister"]["hill400_assault_mcallister_rightaway"]	= "hill400_assault_mcallister_rightaway";

	//GENERIC RANGER 1
	//LETS GO GET THE BASTARDS!
	level.scrsound["gr1"]["hill400_assault_gr5_letsgoget"]			= "hill400_assault_gr5_letsgoget";
		
	//2nd LT. MYERS
	//Wait! Wait! What are you doing??
	level.scrsound["myers"]["hill400_assault_myers_waitwait"]				= "hill400_assault_myers_waitwait";

	//1st SGT NIXON
	//Grenade those foxholes! Get your grenades into those foxholes!
	level.scrsound["nixon"]["hill400_assault_nixon_grenadethosefoxholes"]	= "hill400_assault_nixon_grenadethosefoxholes";

	//2nd SGT RANDALL
	//Hold right here! Wait for them to reload!
	level.scrsound["randall"]["hill400_assault_nixon_waitforreload"]			= "hill400_assault_nixon_waitforreload";

	//2nd SGT RANDALL
	//Get ready Taylor! Get those satchel charges ready! On my signal!
	level.scrsound["randall"]["hill400_assault_rnd_getsatchelcharges"]			= "hill400_assault_rnd_getsatchelcharges";

	//2nd SGT RANDALL
	//Go! Go! Go!
	level.scrsound["randall"]["hill400_assault_rnd_gogogo"]					= "hill400_assault_rnd_gogogo";

	//2nd SGT RANDALL
	//"Taylor! Use your satchel charge on that door! Hurry up!"
	level.scrsound["randall"]["hill400_assault_rnd_usesatchelcharge"]			= "hill400_assault_rnd_usesatchelcharge";
	
	//2nd SGT RANDALL
	//"Use your smoke grenades!!"
	level.scrsound["randall"]["hill400_assault_rnd_usesmoke"]			= "hill400_assault_rnd_usesmoke";

	//2nd SGT RANDALL
	//"Someone get a smoke grenade out there!!!"
	level.scrsound["randall"]["hill400_assault_rnd_getsmoke"]			= "hill400_assault_rnd_getsmoke";
	
	//2nd SGT RANDALL
	//"Taylor!!! Use your smoke grenades!!"
	level.scrsound["randall"]["hill400_assault_rnd_taylorsmoke"]			= "hill400_assault_rnd_taylorsmoke";
	
	//2nd SGT RANDALL
	//"We need more concealment! Put up a smokescreen!!! Use your smoke grenades!!"
	level.scrsound["randall"]["hill400_assault_rnd_concealsmoke"]			= "hill400_assault_rnd_concealsmoke";
	
	//2nd SGT RANDALL
	//"Corporal Taylor!!! Take down that door! Move!"
	level.scrsound["randall"]["hill400_assault_rnd_takedowndoor"]	= "hill400_assault_rnd_takedowndoor";
	
	//1st SGT NIXON
	//Clear up!
	level.scrsound["nixon"]["hill400_assault_nixon_clearup"]				= "hill400_assault_nixon_clearup";
	
	//PVT. BRAEBURN
	//Clear down!
	level.scrsound["braeburn"]["hill400_assault_braeburn_cleardown"]		= "hill400_assault_braeburn_cleardown";


	//GENERIC RANGER 2
	//Counterattack! South side!
	level.scrsound["ranger2"]["hill400_assault_ranger2_enemysouth"]			= "hill400_assault_ranger2_enemysouth";

	//GENERIC RANGER 3
	//Counterattack from the east! We need more men here!
	level.scrsound["ranger3"]["hill400_assault_ranger3_enemyeast"]			= "hill400_assault_ranger3_enemyeast";

	//GENERIC RANGER 4
	//Krauts on the north slope!
	level.scrsound["ranger4"]["hill400_assault_ranger4_enemynorth"]			= "hill400_assault_ranger4_enemynorth";

	//GENERIC RANGER 5
	//They’re coming from everywhere! Get on those MG42s! Let ‘em have a taste of their own medicine!
	level.scrsound["ranger5"]["hill400_assault_ranger5_getonthosemg42s"]	= "hill400_assault_ranger5_getonthosemg42s";
	
	//1st SGT NIXON
	//Rangers!!! Stand your ground!
	level.scrsound["nixon"]["hill400_assault_nixon_standyourground"]		= "hill400_assault_nixon_standyourground";

	//1st SGT NIXON
	//D Company! Get the wounded into the bunker! Gather up weapons and ammo! Jerry’s sure to be comin’ back! Get moving! Now!
	level.scrsound["nixon"]["hill400_assault_nixon_outro"]					= "hill400_assault_nixon_outro";
	
	//GENERIC RANGER 9
	//"Throwing smoke!!!"
	level.scrsound["ranger5"]["hill400_assault_gr9_tossingsmoke"]	= "hill400_assault_gr9_tossingsmoke";
	
	//2nd SGT RANDALL
	//"D Company! Get the wounded into the bunker! Gather up weapons and ammo! Jerry’s sure to be comin’ back! Get moving! Now!"
	level.scrsound["randall"]["hill400_assault_rnd_dcompany"]			= "hill400_assault_rnd_dcompany";
	
	//2nd SGT RANDALL
	//"There's minefields all over this damn place! Watch for the signs!!!"
	level.scrsound["randall"]["hill400_assault_rnd_minefieldwarning"]			= "hill400_assault_rnd_minefieldwarning";
	
	//2nd SGT RANDALL
	//"There's minefields all over this damn place! Watch for the signs!!!"
	level.scrsound["randall"]["hill400_assault_rnd_minefieldwarning"]			= "hill400_assault_rnd_minefieldwarning";
	
	
	
}








