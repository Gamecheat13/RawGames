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
}

dialogue()
{
		// tiger tank! take cover!
	level.scrSound["generic"]["tiger_tank"] = "newvillers_bs1_tigertanktakecover";
	
	level.scrsound["generic"]["destroyed_our_tank"] = "newvillers_bastarddestroyed";

	//iprintlnBold follow me!
	level.scrsound["price"]["follow_me"] 		= "UK_pri_order_move_follow";
	level.scrsound["price"]["follow_me"] 		= "newvillers_pri_moveout";

	//iprintlnBold ("Take up positions at this broken wall!");
	level.scrsound["price"]["brokenwall"] 		= "newvillers_bs4_brokenwall";
	
	//iprintlnBold ("Davis, clear out that house, we'll cover you!");
	level.scrsound["price"]["clearhouse"]			= "newvillers_pri_clearhouse";
	
		//iprintlnBold ("Davis get in there while we suppress them!");
	level.scrsound["price"]["getinthere"]			= "newvillers_pri_getinthere";

		////iprintlnBold ("Alright men good work! Let's move up!");
	level.scrsound["price"]["goodworkmen"]		= "newvillers_pri_goodworkmen";

		////iprintlnBold ("Davis, run down this alley while we lay down the fire!");
	level.scrsound["price"]["moveupalley"]		= "newvillers_pri_moveupalley";

		////iprintlnBold ("Davis we need the second story of that building CLEARED!");
	level.scrsound["price"]["secondstorycleared"]	= "newvillers_pri_secondstorycleared";

		//iprintlnBold ("The building is clear! Let's take of up offensive positions outside! Go go go!");
	level.scrsound["price"]["letsmoveup"]			= "newvillers_pri_letsmoveup";

		//iprintlnBold ("There's our objective, the town hall! Lay down the fire boys!");
	level.scrsound["price"]["townhall"]			= "newvillers_pri_townhall";

		//iprintlnBold ("Davis, move up and we'll swing around with a base of fire!");
	level.scrsound["price"]["keepjerriesbusy"]	= "newvillers_pri_keepjerriesbusy";

		//iprintlnBold ("Base of fire shift right!");
	level.scrsound["price"]["shiftright"]			= "newvillers_pri_shiftright";

		//iprintlnBold ("Davis, get some grenades in those windows!");
	level.scrsound["price"]["grenadesinwindows"]	= "newvillers_pri_grenadesinwindows";

		//iprintlnBold ("Davis, get that building cleared!");
	level.scrsound["price"]["getbuildingclear"]	= "newvillers_pri_getbuildingclear";

		//iprintlnBold ("We've secured the town hall. Bradley, Jacobs, hold this position while we move up to the post office.");
	level.scrsound["price"]["postoffice"]			= "newvillers_pri_postoffice";
	level.scr_face["price"]["postoffice"]			= %newvillers_pri_sc02_06_t2_head;
	
		//iprintlnBold ("Alright men move out!");
	level.scrsound["price"]["moveout"]			= "newvillers_pri_moveout";

		//iprintlnBold ("Move up move up!");
	level.scrsound["price"]["moveup"]				= "newvillers_bs1_moveup";

		//iprintlnBold ("Davis get up there and put some pressure on them!");
	level.scrsound["price"]["getupthere"]			= "newvillers_pri_getupthere";

		//iprintlnBold ("Ok go go go!");
	level.scrsound["price"]["okgogo"]				= "newvillers_bs3_okgogo";

		//iprintlnBold ("Base of fire shift right!");
	level.scrsound["price"]["bofright"]			= "newvillers_bs3_bofright";

	//iprintlnBold ("Base of fire shift right!");
	level.scrsound["price"]["bofleft"]			= "newvillers_bs3_bofleft";
	
	//iprintlnBold ("Let's take up an offensive position in this building!");
	level.scrsound["price"]["takeuppositions"]	= "newvillers_bs1_takeuppositions";

	//iprintlnBold ("Davis, move up to the post office! We'll cover you!");
	level.scrsound["price"]["movepostoffice"]		= "newvillers_pri_movepostoffice";

	//iprintlnBold ("Davis, get the lead out! You need to move up!");
	level.scrsound["price"]["getbloodymoveon"]	= "newvillers_pri_getbloodymoveon";

	//iprintlnBold ("Good work men. There should be a flak just up the road. Let's pay them a visit!");
	level.scrsound["price"]["flakgun"]			= "newvillers_pri_flakgun";

	//iprintlnBold ("We won't have to worry about that flak again, good work. Now we need to clear the church.");
	level.scrsound["price"]["securechurch"]		= "newvillers_pri_securechurch";

	//iprintlnBold ("Let's get some fire on those windows!");
	level.scrsound["price"]["fireonwindows"]		= "newvillers_bs1_fireonwindows";

	//iprintlnBold ("Davis, move up closer! We'll cover you!");
	level.scrsound["price"]["davismoveup"]		= "newvillers_pri_davismoveup";

	//iprintlnBold ("Let's use this building as a staging ground. Focus on the church!");
	level.scrsound["price"]["baseoffire"]			= "newvillers_pri_baseoffire";

	//iprintlnBold ("Squad! Assemble at that low wall! We need to get some pressure on the church!");
	level.scrsound["price"]["lowwall"]			= "newvillers_pri_lowwall";

	//iprintlnBold ("Squad, suppression fire!");
	level.scrsound["price"]["suppressingfire"]	= "newvillers_pri_suppressingfire";

	//iprintlnBold ("Davis, move up to the church!");
	level.scrsound["price"]["davischurch"]		= "newvillers_pri_davischurch";

	//iprintlnBold ("Davis, get a move on! Go go go!");
	level.scrsound["price"]["gogogo"]				= "newvillers_pri_gogogo";

	//iprintlnBold ("The church looks secure! Nelson and Wetley, hold the church until reinforcements arrive. Everybody else, you're with me. We have to take the German HQ! Let's move out!");
	level.scrsound["price"]["germanhq"]			= "newvillers_pri_germanhq";
	level.scr_face["price"]["germanhq"]			= %newvillers_pri_sc05_08_t1_head;

	//iprintlnBold ("Squad! Form a base of fire at this haycart");
	level.scrsound["price"]["fireathaycart"]		= "newvillers_pri_fireathaycart";

	//iprintlnBold ("Alright Davis we've got you covered! Move up!");
	level.scrsound["price"]["moveup"]				= "newvillers_pri_moveup";

	//iprintlnBold ("Go go go! Davis go!");
	level.scrsound["price"]["movedavisgo"]		= "newvillers_pri_movedavisgo";

	//iprintlnBold ("Squad move up! Form a base of fire at that wall! Davis, circle around!");
	level.scrsound["price"]["baseoffirewall"]		= "newvillers_pri_baseoffirewall";

	//iprintlnBold ("Get in that building Davis!");
	level.scrsound["price"]["stormbuilding"]		= "newvillers_pri_stormbuilding";

	//iprintlnBold ("Davis, start clearing those rooms! Hurry!");
	level.scrsound["price"]["clearrooms"]			= "newvillers_pri_clearrooms";

	//iprintlnbold ("Good work men, the town is secure ...");
	level.scrsound["price"]["squadleaders"] 		= "newvillers_pri_squadleaders";

	//Squad leaders, get your men into defensive positions and gather up weapons and ammo. 1st squad, on me. Let's get this town in order.
	level.scrsound["price"]["listen_up"]			= "newvillers_riggs_listenup";
	level.scr_face["price"]["listen_up"]			= %newvillers_pri_sc07_03_t3_head;

	level.whisper = [];
	level.whisper[level.whisper.size] = "newvillers_gi3_getmestatus";
	level.whisper[level.whisper.size] = "newvillers_gi3_takenoprisoners";
	level.whisper[level.whisper.size] = "newvillers_gi3_stretcher";
	level.whisper[level.whisper.size] = "newvillers_gi3_flanking";
	level.whisper[level.whisper.size] = "newvillers_gi3_whosincommand";
	level.whisper[level.whisper.size] = "newvillers_gi3_paras";
	level.whisper[level.whisper.size] = "newvillers_gi3_findlt";
	level.whisper[level.whisper.size] = "newvillers_gi3_movedresser";


/*	
	
	//LT RIGGS
	//Oi! You up there! Get your tanks moving man! WE'LL clear out the buildings while YOU take out their armor! Easy enough for you, mate?
		
		level.scrsound["riggs"]["newvillers_riggs_gettanksmoving"]		= "newvillers_riggs_gettanksmoving";
	
	//LT. RIGGS
	//Bloody nonce. Sergeant! Take the lead! Andrews! MacTavish! On the Sergeant, let's go! The rest of 1st squad, base of fire!
	
		level.scrsound["riggs"]["newvillers_riggs_takethelead"]			= "newvillers_riggs_takethelead";
	
	//LT. RIGGS 
	//2nd squad! Hold here and cover the tanks! 3rd squad, deploy left! 
	//Stick to cover, and watch for snipers! Move move move!
	
		level.scrsound["riggs"]["newvillers_riggs_squadorders"]			= "newvillers_riggs_squadorders";
	
	//LT. RIGGS 
	//About bloody time innit?
	
		level.scrsound["riggs"]["newvillers_riggs_abouttime"]			= "newvillers_riggs_abouttime";
	
	//LT. RIGGS
	//The Germans have better tanks than we do, Private. Thats just a fact. You just worry about killing their infantry and let the tanks do their job.
	
		level.scrsound["riggs"]["newvillers_riggs_bettertanks"]			= "newvillers_riggs_bettertanks";
	
	//LT RIGGS
	//Suppressing fire! Jerry is counterattacking!
	
		level.scrsound["riggs"]["newvillers_riggs_counterattacking"]		= "newvillers_riggs_counterattacking";
		
	//LT RIGGS
	//Heads up! Enemy counterattack!
	
		level.scrsound["riggs"]["newvillers_riggs_enemycounter"]		= "newvillers_riggs_enemycounter";
		
	//LT. RIGGS
	//We've got to capture the church! Stay low, and watch out for machine guns!
	
		level.scrsound["riggs"]["newvillers_riggs_church"]		= "newvillers_riggs_church";
	
	//LT. RIGGS 
	//1st squad! We need to overrun the town hall! That position covers the main road through here! 
	//We're going to lose a lot of our tanks if we don't take that building!
	
		level.scrsound["riggs"]["newvillers_riggs_townhall"]		= "newvillers_riggs_townhall";
		
	//LT. RIGGS
	//Do you see a red cross on that post office, soldier?? I want that building turned to swiss cheese before I hear any talk of taking prisoners!!
	
		level.scrsound["riggs"]["newvillers_riggs_postoffice"]		= "newvillers_riggs_postoffice";
	
	//LT. RIGGS
	//1st squad! Enemy command post in that house! Get some suppressing fire on it! Assault team, take the flank and move in!
	
		level.scrsound["riggs"]["newvillers_riggs_germanhq"]		= "newvillers_riggs_germanhq";
	
	//LT. RIGGS
	//Made it through in one piece? One piece? What war's he fightin' in?
	
		level.scrsound["riggs"]["newvillers_riggs_whatwar"]		= "newvillers_riggs_whatwar";
	
	//LT RIGGS 
	//What is it MacGregor?
	
		level.scrsound["riggs"]["newvillers_riggs_whatisit"]		= "newvillers_riggs_whatisit";
	
	//LT RIGGS
	//Likewise, Private. Likewise.
	
		level.scrsound["riggs"]["newvillers_riggs_likewise"]		= "newvillers_riggs_likewise";
	
	//LT. RIGGS 
	//All right! Listen up! We're not done yet. Jerry's probably getting ready to retake the town so we've got to be ready for him. 
	//Squad leaders, get your men into defensive positions and gather up weapons and ammo. 1st squad, on me. Let's get this town in order.
	level.scrsound["riggs"]["newvillers_riggs_listenup"]		= "newvillers_riggs_listenup";
	newvillers_pri_sc07_03_t3_head
	
	//=======================================
	
	//RIPPER JACK COMMANDER
	//We'll move when we're READY to move, LEFTENANT. We're still pulling up the rest of the column. In the meantime, I suggest you 
	//and your crunchies scout ahead and clear the way for the armor! We'll be along shortly to blast any Jerry tanks you find.
		
		level.scrsound["ripperjackguy"]["newvillers_ripperjack_whenready"]		= "newvillers_ripperjack_whenready";
		
	//RIPPER JACK COMMANDER
	//Nice work 2nd platoon! Good to see we made it through in one piece! We're going to take up positions around the perimeter 
	//and get ready for any counterattacks. Leftenant, I suggest you and your men do the same.
	
		level.scrsound["ripperjackguy"]["newvillers_ripperjack_nicework"]		= "newvillers_ripperjack_nicework";
	
	//=======================================
	
	//BRITISH SOLDIER ONE
	//Wha-?! That Tiger just cut that Sherman in half like it was nothing!
	
		level.scrsound["bs1"]["newvillers_bs1_cutinhalf"]		= "newvillers_bs1_cutinhalf";
		
	//BRITISH SOLDIER ONE
	//Yes sir.
	
		level.scrsound["bs1"]["newvillers_bs1_yessir"]			= "newvillers_bs1_yessir";
		
	//BRITISH SOLDIER ONE
	//Did you just hear what Mac said to the Leftenant?
	
		level.scrsound["bs1"]["newvillers_bs1_didyouhear"]		= "newvillers_bs1_didyouhear";
	
	//=======================================
	
	//BRITISH SOLDIER TWO
	//Bloody hell! Those German tanks are unbelievable!
	
		level.scrsound["bs2"]["newvillers_bs2_unbelievable"]		= "newvillers_bs2_unbelievable";
	
	//BRITISH SOLDIER TWO
	//I heard it, but I don't bloody believe it!
	
		level.scrsound["bs2"]["newvillers_bs2_heardit"]			= "newvillers_bs2_heardit";
	
	//=======================================
	
	//BRITISH SOLDIER THREE
	//That's one Jerry tank for our boys!
	
		level.scrsound["bs3"]["newvillers_bs3_thatsone"]		= "newvillers_bs3_thatsone";
	
	//=======================================

	//BRITISH SOLDIER FOUR
	//Leftenant Riggs! The Jerries just moved some of their wounded into the town post office! Not a bad way to nab a few prisoners, don't your think, sir?
	
		level.scrsound["bs4"]["newvillers_bs4_prisoners"]		= "newvillers_bs4_prisoners";
	
	//=======================================
	
	//PVT MACGREGOR
	//Uh, Leftenant…?
	
		level.scrsound["macgregor"]["newvillers_macgregor_uhlt"]	= "newvillers_macgregor_uhlt";
	
	//PVT MACGREGOR
	//It's um, - well…it's been an honor to serve with you - sir.
	
		level.scrsound["macgregor"]["newvillers_macgregor_honorsir"]	= "newvillers_macgregor_honorsir";
		*/
}
