#using_animtree("generic_human");

main()
{	
	/*
		Guy plants explosives on a Flak88
		level.scr_anim["plantbomb"]["flak"]		= (%brecourt_flak_foleyplantsbomb);
		level.scr_anim["left"]["kickdoor"]		= (%kickdoor_guy2);
		level.scr_anim["right"]["kickdoor"]		= (%kickdoor_guy1);
	*/
	level dialogue();
	level radioman_animations();
}

dialogue()
{
	//SGT. RANDALL
	//Sounds like we've got screaming meemies up ahead, but I couldn't make visual contact. 
	
		level.scrsound["randall"]["silotown_rnd_screamingmeemies"]		= "silotown_rnd_screamingmeemies";
	
	//SGT. RANDALL	
	//I did spot an 88 on the other side of this hedgerow. Expect a crew of at least two 
	//and a couple of MG42s. 

		level.scrsound["randall"]["silotown_rnd_spot88"]	= "silotown_rnd_spot88";
		level.scr_face["randall"]["silotown_rnd_spot88"]	= (%silotownassault_rnd_sc01_02_t1_head);
		//level.scr_anim["randall"]["silotown_rnd_spot88"]	= (%decoytrench_thisisit);
	
	//SGT. RANDALL
	//I need runners with suppressing fire. Garcia, Hawkins, take the left with 
	//Rosetti and Jones. The rest will follow me up the right flank. 
	
		level.scrsound["randall"]["silotown_rnd_needrunners"]		= "silotown_rnd_needrunners";
		level.scr_face["randall"]["silotown_rnd_needrunners"]		= (%silotownassault_rnd_sc01_04_t2_head);

	//SGT. RANDALL
	//I want grenades on them as soon as we're in range. Braeburn, McCloskey, and 
	//Taylor - you stay back and provide a base of fire. 
	
		level.scrsound["randall"]["silotown_rnd_wantgrenades"]		= "silotown_rnd_wantgrenades";
		level.scr_face["randall"]["silotown_rnd_wantgrenades"]		= (%silotownassault_rnd_sc01_05_t1_head);

	//SGT. RANDALL
	//Keep those Krauts off of us so we can move in. 
		
		level.scrsound["randall"]["silotown_rnd_keepkrautsoff"]		= "silotown_rnd_keepkrautsoff";
		level.scr_face["randall"]["silotown_rnd_keepkrautsoff"]		= (%silotownassault_rnd_sc01_06_t1_head);
	
	//SGT. RANDALL
	//All right. Move up, and wait for my signal.
	
		level.scrsound["randall"]["silotown_rnd_allrightmoveup"]		= "silotown_rnd_allrightmoveup";
		level.scr_face["randall"]["silotown_rnd_allrightmoveup"]		= (%silotownassault_rnd_sc01_06_t1_head);
	
	//SGT. RANDALL
	//McCloskey! Do it!
	
		level.scrsound["randall"]["silotown_rnd_mccloskeydoit"]		= "silotown_rnd_mccloskeydoit";
		level.scr_face["randall"]["silotown_rnd_mccloskeydoit"]		= (%silotownassault_rnd_sc02_01_t1_head);
	
	//SGT. RANDALL
	//Open fire!!
	
		level.scrsound["randall"]["silotown_randall_openfire"]		= "silotown_randall_openfire";
		level.scr_face["randall"]["silotown_randall_openfire"]		= (%silotownassault_rnd_sc02_01_t1_head);
	
	//SGT. RANDALL
	//Flankers out! Let's go! Let's go!
	
		level.scrsound["randall"]["silotown_rnd_flankersout"]		= "silotown_rnd_flankersout";
	
	//SGT. RANDALL
	//Garcia! (distant)
	
		level.scrsound["randall"]["silotown_rnd_garcia"]		= "silotown_rnd_garcia";
		
	//SGT. RANDALL
	//Hawkins! (distant)
	
		level.scrsound["randall"]["silotown_rnd_hawkins"]		= "silotown_rnd_hawkins";
		
	//SGT. RANDALL
	//Rosetti! (distant)
	
		level.scrsound["randall"]["silotown_rnd_rosetti"]		= "silotown_rnd_rosetti";
		
	//SGT. RANDALL
	//Jones! (distant)
	
		level.scrsound["randall"]["silotown_rnd_jones"]		= "silotown_rnd_jones";
	
	//SGT. RANDALL
	//Lentz! (distant)
	
		level.scrsound["randall"]["silotown_rnd_lentz"]		= "silotown_rnd_lentz";
	
	//SGT. RANDALL
	//Get on that 88 and blast that silo! (distant)
	
		level.scrsound["randall"]["silotown_rnd_geton88"]		= "silotown_rnd_geton88";
	
	//SGT. RANDALL
	//McCloskey! Braeburn! Taylor! Get up here! We gotta clear out these buildings! (distant)

		level.scrsound["randall"]["silotown_rnd_getuphere"]		= "silotown_rnd_getuphere";
		level.scr_anim["randall"]["silotown_rnd_getuphere"]		= (%duhoc_assault_randall_waves);

	//SGT. RANDALL
	//All right, I think that's the last of 'em! Everyone assemble on me!
	
		level.scrsound["randall"]["silotown_rnd_lastofem"]		= "silotown_rnd_lastofem";

	//SGT. RANDALL
	//Corporal Taylor, climb that silo with Braeburn and McCloskey and watch for an enemy counterattack. 
	
		level.scrsound["randall"]["silotown_rnd_climbsilo"]		= "silotown_rnd_climbsilo";
		level.scr_anim["randall"]["silotown_rnd_climbsilo"]		= (%silotown_rnd_climbsilo);
		//level.scr_face["randall"]["silotown_rnd_climbsilo"]		= (%silotownassault_rnd_sc08_02_t2_head);
	
	//Everyone else, take up positions around the perimeter and stay sharp!

		level.scrsound["randall"]["silotown_rnd_everyoneelse"]		= "silotown_rnd_everyoneelse";
		level.scr_anim["randall"]["silotown_rnd_everyoneelse"]		= (%silotown_rnd_everyoneelse);
		//level.scr_face["randall"]["silotown_rnd_everyoneelse"]		= (%silotownassault_rnd_sc08_03_t1_head);

	//SGT. RANDALL
	//Braebuuurn!!!! Get through to Captain Blake and get us some reinforcements!!
	
	 	level.scrsound["randall"]["silotown_rnd_getthru"]		= "silotown_rnd_getthru";

	//SGT. RANDALL
	//Squaaad! Regroup on me!!! Hustle up!
	
		level.scrsound["randall"]["silotown_rnd_squadregroup"]		= "silotown_rnd_squadregroup";

	//SGT. RANDALL
	//Good work everyone. The Shermans may have saved our skins, but if you haven't 
	//already figured it out, they're sure to counterattack with armor next time.
	 
	 	level.scrsound["randall"]["silotown_rnd_goodwork"]		= "silotown_rnd_goodwork";
	 
	//Gather up whatever spare weapons and ammo you can, and keep your eyes open 
	//for mines, 'schrecks, and Panzerfausts - grab any anti-tank weapons you can 
	//find. 
	
		level.scrsound["randall"]["silotown_rnd_gatherup"]		= "silotown_rnd_gatherup";
	
	//Make sure your sectors are well covered and we'll meet back here in 
	//an hour. Dismissed.

		level.scrsound["randall"]["silotown_rnd_sectorscovered"]	= "silotown_rnd_sectorscovered";
		level.scr_anim["randall"]["silotown_rnd_sectorscovered"]	= (%silotown_rnd_sectorscovered);
		//level.scr_face["randall"]["silotown_rnd_sectorscovered"]	= (%silotownassault_rnd_sc11_04_t3_head);

	//=======================================
	
	//PVT. BRAEBURN
	//So what's the plan, sarge?
		
		level.scrsound["braeburn"]["silotown_braeburn_whatplan"]	= "silotown_braeburn_whatplan";
		level.scr_face["braeburn"]["silotown_braeburn_whatplan"]	= (%silotownassault_bra_sc01_03_t8_head);

	//PVT. BRAEBURN
	//"Where the hell are you goin' Taylor?! Hang back and cover the squad!!"

		level.scrsound["braeburn"]["silotown_braeburn_whereyougoing"]	= "silotown_braeburn_whereyougoing";

	//PVT. BRAEBURN
	//"Taylor get back here! We gotta lay down suppressing fire for the rest of the squad!"

		level.scrsound["braeburn"]["silotown_braeburn_getbackhere"]		= "silotown_braeburn_getbackhere";

	//PVT. BRAEBURN
	//"Taylor! Stay here and take out those Krauts with your sniper rifle!"

		level.scrsound["braeburn"]["silotown_braeburn_taylorstayhere"]	= "silotown_braeburn_taylorstayhere";

	//PVT. BRAEBURN
	//I've got problems of my own! Where's your spare can of ammo?
	
		level.scrsound["braeburn"]["silotown_braeburn_sparecan"]	= "silotown_braeburn_sparecan";

	//PVT. BRAEBURN
	//Jeez Louise, McCloskey, how the hell did you get to be company gunner?!?! Shootin' chickens in a barnyard?!
	
		level.scrsound["braeburn"]["silotown_braeburn_chickens"]	= "silotown_braeburn_chickens";
	
	//PVT. BRAEBURN 
	//What!? Sorry Doc, I can't hear you!

		level.scrsound["braeburn"]["silotown_braeburn_canthear"]	= "silotown_braeburn_canthear";
	
	//PVT. BRAEBURN
	//MG42 to the right of the flak gun! Take it out!
	
		level.scrsound["braeburn"]["silotown_braeburn_mgbyflakgun"]	= "silotown_braeburn_mgbyflakgun";
	
	//PVT. BRAEBURN
	//MG42 in the window!
	
		level.scrsound["braeburn"]["silotown_braeburn_mg42window"]	= "silotown_braeburn_mg42window";
		
	//PVT. BRAEBURN
	//MG42! Hedgerow gap on the left!
	
		level.scrsound["braeburn"]["silotown_braeburn_mg42gapleft"]	= "silotown_braeburn_mg42gapleft";

	//PVT. BRAEBURN
	//MG42 in the hedgerow gap by the house!
	
		level.scrsound["braeburn"]["silotown_braeburn_mg42gapbyhouse"]	= "silotown_braeburn_mg42gapbyhouse";
	
	//PVT. BRAEBURN
	//Kraut squad on the bridge at 2 o'clock!
	
		level.scrsound["braeburn"]["silotown_braeburn_squadbridge"]	= "silotown_braeburn_squadbridge";
	
	//PVT. BRAEBURN
	//Enemy squad by the wall on the far right!
	
		level.scrsound["braeburn"]["silotown_braeburn_squadwall"]	= "silotown_braeburn_squadwall";
	
	//PVT. BRAEBURN
	//Kraut squad in the hedgerow gap by the house!
	
		level.scrsound["braeburn"]["silotown_braeburn_squadgaphouse"]	= "silotown_braeburn_squadgaphouse";
	
	//PVT. BRAEBURN
	//Enemy reinforcements, 11 o'clock!  
		
		level.scrsound["braeburn"]["silotown_braeburn_enemy11oclock"]	= "silotown_braeburn_enemy11oclock";
	
	//PVT. BRAEBURN
	//Enemy infanty heading for the flak gun!
	
		level.scrsound["braeburn"]["silotown_braeburn_headingflakgun"]	= "silotown_braeburn_headingflakgun";
	
	//PVT. BRAEBURN
	//Mortar team! Coming through the gap in the hedgerow, 11 o'clock!
	
		level.scrsound["braeburn"]["silotown_braeburn_mortargaphedge"]	= "silotown_braeburn_mortargaphedge";
	
	//PVT. BRAEBURN
	//Mortar team by the house!
		
		level.scrsound["braeburn"]["silotown_braeburn_mortarbyhouse"]	= "silotown_braeburn_mortarbyhouse";
	
	//++++missing
	//PVT. BRAEBURN
	//Nice shootin' Taylor. Pack your bags we're movin' in.
	
		level.scrsound["braeburn"]["silotown_braeburn_packbags"]	= "silotown_braeburn_packbags";
		
	//PVT. BRAEBURN
	//I'm on it Sarge!!!	
	
		level.scrsound["braeburn"]["silotown_braeburn_onitsarge"]	= "silotown_braeburn_onitsarge";
		level.scr_face["braeburn"]["silotown_braeburn_onitsarge"]	= (%silotownassault_bra_sc09_04_t2_head);
	
	//PVT. BRAEBURN
	//Baker Six this is Baker One-Four, objective taken at Rally Point Echo! Enemy infantry 
	//counterattacking in force, request additional support, over!

		level.scrsound["braeburn"]["silotown_braeburn_request"]	= "silotown_braeburn_request";
		level.scr_face["braeburn"]["silotown_braeburn_request"]	= (%silotownassault_bra_sc09_05_t4_head);
	
	//PVT. BRAEBURN
	//Due respect sir, I don't think we're gonna last that long! Over!

		level.scrsound["braeburn"]["silotown_braeburn_respect"]	= "silotown_braeburn_respect";
		level.scr_face["braeburn"]["silotown_braeburn_respect"]	= (%silotownassault_bra_sc09_07_t1_head);
	
	//PVT. BRAEBURN
	//German mortar team in the field to the southeast!!!

		level.scrsound["braeburn"]["silotown_braeburn_mortarfieldse"]	= "silotown_braeburn_mortarfieldse";

	//PVT. BRAEBURN
	//Enemy mortar to the northeast!!! Take 'em out!

		level.scrsound["braeburn"]["silotown_braeburn_mortarne"]	= "silotown_braeburn_mortarne";

	//PVT. BRAEBURN
	//German mortar emplacement! North-northeast!!!

		level.scrsound["braeburn"]["silotown_braeburn_mortarnne"]	= "silotown_braeburn_mortarnne";

	//PVT. BRAEBURN
	//Enemy mortar team to the north!!!

		level.scrsound["braeburn"]["silotown_braeburn_mortarnorth"]	= "silotown_braeburn_mortarnorth";

	//PVT. BRAEBURN
	//German mortar team in the field, to the northwest!!!

		level.scrsound["braeburn"]["silotown_braeburn_mortarfieldnw"]	= "silotown_braeburn_mortarfieldnw";

	//PVT. BRAEBURN
	//Kraut mortar to the southwest!!!

		level.scrsound["braeburn"]["silotown_braeburn_mortarsw"]	= "silotown_braeburn_mortarsw";

	//PVT. BRAEBURN
	//German mortar crew to the south!!!

		level.scrsound["braeburn"]["silotown_braeburn_mortarsouth"]	= "silotown_braeburn_mortarsouth";
		
	//PVT. BRAEBURN
	//Enemy mortar team to the southwest by the halftrack!

		level.scrsound["braeburn"]["silotown_braeburn_mortarhtsw"]	= "silotown_braeburn_mortarhtsw";

	//PVT. BRAEBURN
	//They're settin' up a mortar in the field to the northwest!

		level.scrsound["braeburn"]["silotown_braeburn_mortarfieldnw2"]	= "silotown_braeburn_mortarfieldnw2";

	//PVT. BRAEBURN
	//Take out that mortar crew to the north at the fork in the road!

		level.scrsound["braeburn"]["silotown_braeburn_mortarnorthfork"]	= "silotown_braeburn_mortarnorthfork";

	//PVT. BRAEBURN
	//Mortar team, low to the west!
	
		level.scrsound["braeburn"]["silotown_braeburn_mortarwest"]	= "silotown_braeburn_mortarwest";
	
	//PVT. BRAEBURN
	//South-southeast! Kraut mortar set up by the flak gun, take it out!

		level.scrsound["braeburn"]["silotown_braeburn_mortarsseflak"]	= "silotown_braeburn_mortarsseflak";

	//PVT. BRAEBURN
	//Mortar team by the road to the east!!

		level.scrsound["braeburn"]["silotown_braeburn_mortareastroad"]	= "silotown_braeburn_mortareastroad";

	//PVT. BRAEBURN
	//Bout' damn time! The Krauts are givin' up the fight! Thaaat's right Fritz! Just keep on runnin'!!

		level.scrsound["braeburn"]["silotown_braeburn_givingup"]	= "silotown_braeburn_givingup";
		level.scr_face["braeburn"]["silotown_braeburn_givingup"]	= (%silotownassault_bra_sc10_02_t2_head);
	
	//=======================================
	
	//PVT. MCCLOSKEY
	//Braeburn! I'm runnin' out of .30 cal!
	
		level.scrsound["mccloskey"]["silotown_mccloskey_runningout"]	= "silotown_mccloskey_runningout";
	
	//PVT. MCCLOSKEY
	//I thought you had it!
	
		level.scrsound["mccloskey"]["silotown_mccloskey_youhadit"]	= "silotown_mccloskey_youhadit";
	
	//PVT. MCCLOSKEY
	//Hey! It's the Doc!
	
		level.scrsound["mccloskey"]["silotown_mccloskey_doc"]	= "silotown_mccloskey_doc";
	
	//PVT. MCCLOSKEY	
	//Thanks Doc! Braeburn! Doc here says you forgot the ammo.
	
		level.scrsound["mccloskey"]["silotown_mccloskey_docsays"]	= "silotown_mccloskey_docsays";

	//PVT. MCCLOSKEY
	//Hey! We got friendly tanks comin' in from the east! Looks like they sent us a couple a' Shermans!

		level.scrsound["mccloskey"]["silotown_mccloskey_friendlytanks"]	= "silotown_mccloskey_friendlytanks";
		level.scr_anim["mccloskey"]["silotown_mccloskey_friendlytanks"]	= (%silotown_mccloskey_friendlytanks);
		//level.scr_face["mccloskey"]["silotown_mccloskey_friendlytanks"]	= (%silotownassault_mcc_sc10_01_t2_head);
		
	//=======================================
	
	//++++missing
	//T5 MEDIC WELLS
	//Private Braeburn!
	
		level.scrsound["wells"]["silotown_med_pvtbraeburn"]	= "silotown_med_pvtbraeburn";
	
	//++++missing
	//T5 MEDIC WELLS
	//Braeburn! You left this ammo on the road! You'd forget your ass if it wasn't glued on!
	
		level.scrsound["wells"]["silotown_med_ammo"]	= "silotown_med_ammo";
		level.scr_face["wells"]["silotown_med_ammo"]	= (%silotownassault_rnd_sc01_02_t1_head);
		
	//=======================================
	
	//++++missing
	//GENERIC RANGER 1 (representing Garcia, Hawkins, Rosetti, Jones, or Lentz)
	//Yes sir!
	
		level.scrsound["gr1"]["silotown_gr1_yessir"]	= "silotown_gr1_yessir";	
	
	//++++missing	
	//GENERIC RANGER 1 (representing Garcia, Hawkins, Rosetti, Jones, or Lentz)
	//Here they come!!!
		
		level.scrsound["gr1"]["silotown_gr1_heretheycome"]	= "silotown_gr1_heretheycome";		
		
	//=======================================	
	
	//++++missing
	//GENERIC RANGER 2 (representing Garcia, Hawkins, Rosetti, Jones, or Lentz)
	//German counterattack!
	
		level.scrsound["gr2"]["silotown_gr2_counterattack"]	= "silotown_gr2_counterattack";		
	
	//=======================================	
		
	//CAPTAIN BLAKE (AS RADIO VOICE)
	//Baker One Four, Baker Six. I've got a couple of Shermans headed your way E.T.A. five minutes, over.

		//level.scrsound["blake"]["silotown_blake_shermans"]	= "silotown_blake_shermans";		
		//played as a sound effect off of Braeburn's origin
		
	//CAPTAIN BLAKE (AS RADIO VOICE)
	//Calm DOWN one-four. Now you hold that town until relieved! Out.
	
		//level.scrsound["blake"]["silotown_blake_calmdown"]	= "silotown_blake_calmdown";		
		//played as a sound effect off of Braeburn's origin
}

#using_animtree("duhoc_radioman");
radioman_animations()
{
	level.scr_animtree["radioman"] = #animtree;
	
	//this one has a “dialogue” notetrack to play this sound file...  duhocassault_cof_sc14_03_t3
	//level.scr_anim["radioman"]["talk"]				= %duhoc_radioman_talk;
	
	//this is the main idle
	//level.scr_anim["braeburn"]["silotown_braeburn_request"]			= %duhoc_radioman_listen;
	//level.scr_anim["braeburn"]["silotown_braeburn_respect"]			= %duhoc_radioman_listen;
	
	//this is a twitch and can also be used with other generic radio talking dialogue
	//level.scr_anim["radioman"]["idle"][3]			= %duhoc_radioman_nod;
}







