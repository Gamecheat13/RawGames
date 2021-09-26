#using_animtree("generic_human");
main()
{

	   thread door_anim();
	   level.scr_anim["mcgregor"]["chateau_kickdoor1"]			= (%chateau_kickdoor1);
	   level.scr_anim["mcgregor"]["barndoor"]				= (%breakout_barngate_open_guy);

/* Mortar crew */

	// loadguy animations 
	level.scr_anim["loadguy"]["waitidle"]			= (%mortar_loadguy_waitidle);
	level.scr_anim["loadguy"]["waittwitch"]			= (%mortar_loadguy_waittwitch);
	level.scr_anim["loadguy"]["fire"]			= (%mortar_loadguy_fire);
	level.scr_anim["loadguy"]["pickup"]			= (%mortar_loadguy_pickup);
	// aimguy animations 
	level.scr_anim["aimguy"]["waitidle"]			= (%mortar_aimguy_waitidle);
	level.scr_anim["aimguy"]["waittwitch"]			= (%mortar_aimguy_waittwitch);
	level.scr_anim["aimguy"]["fire"]			= (%mortar_aimguy_fire);
	level.scr_anim["aimguy"]["pickup"]			= (%mortar_aimguy_pickup);
	/*
	level.scr_notetrack["loadguy"][0]["notetrack"] = "attach shell = left";
	level.scr_notetrack["loadguy"][0]["attach model"] = "xmodel/prop_mortar_ammunition";
	level.scr_notetrack["loadguy"][0]["selftag"] = "TAG_WEAPON_LEFT";

	level.scr_notetrack["loadguy"][1]["notetrack"] = "detach shell = left";
	level.scr_notetrack["loadguy"][1]["detach model"] = "xmodel/prop_mortar_ammunition";
	level.scr_notetrack["loadguy"][1]["selftag"] = "TAG_WEAPON_LEFT";


	level.scr_notetrack["loadguy"][2]["notetrack"] = "fire";
	level.scr_notetrack["loadguy"][2]["effect"] = "mortar launch";
	level.scr_notetrack["loadguy"][2]["selftag"] = "TAG_WEAPON_LEFT";

	level.scr_notetrack["loadguy"][3]["notetrack"] = "fire";
	level.scr_notetrack["loadguy"][3]["sound"] = "flak_reload";
	*/
	level dialogue();
}

dialogue()
{
	//CPT Price
	//Take cover!!! Get to the barn! Move!!!
	level.scrsound["price"]["breakout_pri_takecoverbarn"]				= "breakout_pri_takecoverbarn";

	//CPT Price
	//Keep moving!!! Don't stop!!!
	level.scrsound["price"]["breakout_pri_keepmoving"]				= "breakout_pri_keepmoving";

	//CPT Price
	//Hold up here lads - we have to find and take out those mortars. MacGregor - get that barn door open!
	level.scrsound["price"]["breakout_pri_holdupherelads"]				= "breakout_pri_holdupherelads";
	level.scr_face["price"]["breakout_pri_holdupherelads"]			= %breakout_pri_sc01_04_head;
		

	//CPT Price
	//"Heads up! Halftrack full of Jerries!"
	level.scrsound["price"]["breakout_pri_halftrackfull"]				= "breakout_pri_halftrackfull";

	//Pvt. MacGregor
	//Take out those mortar crews!!!
	level.scrsound["mcgregor"]["breakout_mcg_mortarcrews"]				= "breakout_mcg_mortarcrews";

	//Pvt. MacGregor
	//"Oi! Stay off that street, that halftrack’s got it locked down tighter than a bearded nun!"
	level.scrsound["mcgregor"]["breakout_mcg_beardednun"]				= "breakout_mcg_beardednun";

	//CPT Price
	//Good work lads! Come on, we've got to take that field HQ to the north!
	level.scrsound["price"]["breakout_pri_takefieldhq"]				= "breakout_pri_takefieldhq";

	//CPT Price
	//They know we're here lads - dig in and fight!
	level.scrsound["price"]["breakout_pri_digin"]				= "breakout_pri_digin";

	//CPT Price
	//So much for the easy stuff lads! That big farm house is the centerpiece of the German defense here! We've got to capture it!
	level.scrsound["price"]["breakout_pri_easystuff"]				= "breakout_pri_easystuff";

	//Pvt. MacGregor
	//Move out!!
	level.scrsound["mcgregor"]["breakout_mcg_moveout"]				= "breakout_mcg_moveout";
	
	//CPT Price
	//Regroup, lads! Over here! On my position let's go!
	level.scrsound["price"]["breakout_pri_regrouplads"]				= "breakout_pri_regrouplads";
	
	//CPT Price
	//King Six to Easy Six - we've taken our bloody objective, over!
	level.scrsound["price"]["breakout_pri_takenobjective"]				= "breakout_pri_takenobjective";
 	//level.scr_anim["price"]["breakout_pri_takenobjective"]				= (%breakout_pri_sc11_05_radioman_talk);
 		
	//British Radio Voice 2
	//Understood King Six. Be advised, more enemy patrols sighted approaching your sector! Hold our flank against the German counterattacks! You must buy us enough time to move the rest of the division to safety! Out!
	//level.scrsound["price"]["breakout_brv2_understood"]				= "breakout_brv2_understood";
 	//level.scr_anim["price"]["breakout_brv2_understood"][0]				= (%breakout_pri_sc11_05_radioman_idle);
 		
	//Pvt. MacGregor
	//You heard it lads! Take up defensive positions in the farm house, let's move!
	level.scrsound["mcgregor"]["breakout_mcg_hearditlads"]				= "breakout_mcg_hearditlads";

	//Pvt. MacGregor
	//They'll be coming from the south! Find a good position and get ready!
	level.scrsound["mcgregor"]["breakout_mcg_getready"]				= "breakout_mcg_getready";
	
	//Pvt. MacGregor
	//Jerries incoming!!!! Let 'em have it!!!! Open fire!!!
	level.scrsound["mcgregor"]["breakout_mcg_jerriesincoming"]				= "breakout_mcg_jerriesincoming";

	//Pvt. MacGregor
	//They're insiiiide!!!!
	level.scrsound["mcgregor"]["breakout_mcg_theyreinside"]				= "breakout_mcg_theyreinside";

	//Pvt. MacGregor
	//Halftrack coming in from the south!!!
	level.scrsound["mcgregor"]["breakout_mcg_halftracksouth"]				= "breakout_mcg_halftracksouth";

	//Pvt. MacGregor
	//Tiger tank!!!!
	level.scrsound["mcgregor"]["breakout_mcg_tigertank"]				= "breakout_mcg_tigertank";

	//British Soldier 4
	//We're buggered without an anti-tank weapon!!!
	level.scrsound["brit"]["breakout_bs4_antitankweapon"]				= "breakout_bs4_antitankweapon";

	//British Soldier 4
	//They're using smoke grenades!!! Watch the flanks! It could be a diversion!!!
	level.scrsound["brit"]["breakout_smokeattack_warning"]				= "breakout_smokeattack_warning";

	//British Soldier 4
	//Jerries closing on the east flank!!! We need some help over here!!!
	level.scrsound["brit"]["breakout_leftflank_warning"]				= "breakout_leftflank_warning";

	//British Soldier 4
	//Bloody hell, more Germans coming around the east side!!!
	level.scrsound["brit"]["breakout_leftflank_warning"]				= "breakout_leftflank_warning";

	//CPT Price
	//Hold your bloody ground until our reinforcements arrive!!! That's an order!
	level.scrsound["price"]["breakout_pri_holdbloodyground"]				= "breakout_pri_holdbloodyground";
	
	//British Soldier 3
	//We're being overrun!!!
	level.scrsound["brit"]["breakout_bs2_beingoverrun"]				= "breakout_bs2_beingoverrun";

	//British Soldier 3
	//German smokescreen!!! Hold your fire until you have a target!!! Make every shot count!!!
	level.scrsound["brit"]["breakout_smokeattack_warning"]				= "breakout_smokeattack_warning";

	//British Soldier 3
	//They're coming around the left flank!!! Get over there and stop 'em!!!
	level.scrsound["brit"]["breakout_leftflank_warning"]				= "breakout_leftflank_warning";
	
	//CPT Price
	//Sergeant Davis! Circle around to the left and disable that tank! Move!
	level.scrsound["price"]["breakout_pri_killtank"]				= "breakout_pri_killtank";
	
	//CPT Price
	//Sergeant Davis! Use your explosives and plant them on that tank! Go!!
	level.scrsound["price"]["breakout_pri_killtanknag"]				= "breakout_pri_killtanknag";
	
	//Pvt. MacGregor
	//Hold your position dammit!
	level.scrsound["mcgregor"]["breakout_mcg_holddammit"]				= "breakout_mcg_holddammit";
	
	//British Soldier 3
	//Looks like they're retreating!!
	level.scrsound["brit"]["breakout_bs2_looksretreating"]				= "breakout_bs2_looksretreating";
	
	//British Soldier 4
	//And come back any time, you Jerry bastards! We'll be waiting for you!
	level.scrsound["brit"]["breakout_bs4_comebackanytime"]				= "breakout_bs4_comebackanytime";

	//CPT Price
	//We did it boys!!! Bloody fine work!!!
	level.scrsound["price"]["breakout_pri_wedidit"]				= "breakout_pri_wedidit";

	//CPT Price
	//All right, let's go, regroup out back!
	level.scrsound["price"]["breakout_pri_regroupoutback"]				= "breakout_pri_regroupoutback";

	//CPT Price
	//Bloody fine work men. The 7th Armored's made it out of this mess thanks to our efforts on this exposed flank. Our job here is done. Come on - let's get the hell out of here.
	level.scrsound["price"]["breakout_pri_7tharmored"]				= "breakout_pri_7tharmored";
	level.scr_face["price"]["breakout_pri_7tharmored"]			= %breakout_pri_sc12_08_head;
;	
}
#using_animtree("barndoor");

door_anim()
{
	level.scr_anim["barn_door"]["barndoor"]			= (%breakout_barngate_open_door);
}



