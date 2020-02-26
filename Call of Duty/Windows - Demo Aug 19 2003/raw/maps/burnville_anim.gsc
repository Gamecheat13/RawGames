#using_animtree("generic_human");
main()
{
 
//*-1a. All right guys, get set to move, on my command!	
//	level.scr_anim["foley"]["intro"]				= (%fullbody_foley1);
//	level.scr_face["foley"]["intro"]				= (%facial_foley1);
	level.scrsound["foley"]["intro"]				= ("burnville_foley_1a");

//*-1b. (continues:) Let's go, let's go!
	level.scrsound["foley"]["lets go"]				= ("burnville_foley_1b");

	
//*-2. MG42s! Hit the dirt!
	level.scr_face["foley"]["hit the dirt"]			= (%facial_foley2);
	level.scrsound["foley"]["hit the dirt"]			= ("burnville_foley_2");
	
//*-3. Get suppressing fire on those '42s! 
//	level.scr_anim["foley"]["suppress"]				= (%fullbody_foley3);
	level.scr_face["foley"]["suppress"]				= (%facial_foley3);
	level.scrsound["foley"]["suppress"]				= ("burnville_foley_3");

//*-4. Mortars!
	level.scr_face["foley"]["mortars"]				= (%facial_foley4);
	level.scrsound["foley"]["mortars"]				= ("burnville_foley_4");
	
//*-5. Keep your heads down!
	level.scr_face["foley"]["head down"]			= (%facial_foley5);
	level.scrsound["foley"]["head down"]			= ("burnville_foley_5");
	
//*-6. Incoming
	level.scr_face["foley"]["incoming"]				= (%facial_foley6);
	level.scrsound["foley"]["incoming"]				= ("burnville_foley_6");
	
//*-7. Down, dammit! Stay down!
	level.scr_face["foley"]["stay down"]			= (%facial_foley7);
	level.scrsound["foley"]["stay down"]			= ("burnville_foley_7");
	
//*-8. Everybody move! Come on!
//	level.scr_anim["foley"]["get moving"]			= (%fullbody_foley8);
	level.scr_face["foley"]["get moving"]			= (%facial_foley8);
	level.scrsound["foley"]["get moving"]			= ("burnville_foley_8");
	
//*-9. Faster! Keep moving forward! We get caught here, we're dead!
	level.scr_face["foley"]["move forward"]			= (%facial_foley9);
	level.scrsound["foley"]["move forward"]			= ("burnville_foley_9");
	
//*-10. Watch your angles!
	level.scr_face["foley"]["watch angles"]			= (%facial_foley10);
	level.scrsound["foley"]["watch angles"]			= ("burnville_foley_10");
	
//*-11. Jerry on the right 
	level.scr_face["foley"]["on the right"]			= (%facial_foley11);
	level.scrsound["foley"]["on the right"]			= ("burnville_foley_11");
	
//*-12. Martin, help clear that building! 
	level.scr_face["foley"]["clear building"]		= (%facial_foley12);
	level.scrsound["foley"]["clear building"]		= ("burnville_foley_12");
	
//*-13a. Get some grenades in those windows!
	level.scr_face["foley"]["grenades"]				= (%facial_foley13);
	level.scrsound["foley"]["grenades"]				= ("burnville_foley_13a");
	
//*-13b. Good job! All right guys, we're moving on!
	level.scr_face["foley"]["moving on"]			= (%facial_foley13);
	level.scrsound["foley"]["moving on"]			= ("burnville_foley_13b");
	
//	13c. Up at that window!
	level.scr_face["foley"]["up window"]			= (%facial_foley13);
	level.scrsound["foley"]["up window"]			= ("burnville_foley_13c");
	
//*-14a. Clear that building! Get that gunner on the halftrack and lets go!
	level.scr_face["foley"]["get halftrack gunner"]	= (%facial_foley14);
	level.scrsound["foley"]["get halftrack gunner"]	= ("burnville_foley_14a");
	
//*	14b. Hold right here!
	level.scr_face["foley"]["hold here"]			= (%facial_foley14);
	level.scrsound["foley"]["hold here"]			= ("burnville_foley_14b");
	
//*-15. Good job, son!
	level.scr_face["foley"]["good job"]				= (%facial_foley15);
	level.scrsound["foley"]["good job"]				= ("burnville_foley_15");

//*-16. Squad, move up! Go! Go! Go!
	level.scr_face["foley"]["go go"]				= (%facial_foley16);
	level.scrsound["foley"]["go go"]				= ("burnville_foley_16");

//*-17a. Lay down a base of fire! Martin, take their left flank!
	level.scr_face["foley"]["base of fire"]			= (%facial_foley17);
	level.scrsound["foley"]["base of fire"]			= ("burnville_foley_17a");

//*-17b. Martin, take their left flank! Clear that building! Move it! Go!
	level.scr_face["foley"]["left flank"]			= (%facial_foley17);
	level.scrsound["foley"]["left flank"]			= ("burnville_foley_17b");

//*-18. Base of fire, shift right!
	level.scr_face["foley"]["shift right"]			= (%facial_foley18);
	level.scrsound["foley"]["shift right"]			= ("burnville_foley_18");

//*-19. We gotta cut through these houses! Move it! Go!
	level.scr_face["foley"]["cut through houses"]	= (%facial_foley19);
	level.scrsound["foley"]["cut through houses"]	= ("burnville_foley_19");
 	
//*-19.5 Foleys idle
	level.scr_anim["foley"]["idle"][0]				= (%fullbody_foley_idle);
	level.scr_anim["foley"]["idleweight"][0]		= 0.75;
	level.scr_anim["foley"]["idle"][1]				= (%fullbody_foley_look);
	level.scr_anim["foley"]["idleweight"][1]		= 0.25;
	
//*-19.8 Foleys wave
 	level.scr_anim["foley"]["wave"]					= (%fullbody_foley_wave);

//*-20. Flakpanzer covered by '42s! We gotta flank 'em!
	level.scr_anim["foley"]["flank mg42s"]			= (%fullbody_foley20);
	level.scr_face["foley"]["flank mg42s"]			= (%facial_foley20);
	level.scrsound["foley"]["flank mg42s"]			= ("burnville_foley_20");

//*-21. Martin, check the church!
	level.scr_anim["foley"]["check church"]			= (%fullbody_foley21);
	level.scr_face["foley"]["check church"]			= (%facial_foley21);
	level.scrsound["foley"]["check church"]			= ("burnville_foley_21");
	
//*-22. Way to chuck, Private!
	level.scr_face["foley"]["nice chuck"]			= (%facial_foley22);
	level.scrsound["foley"]["nice chuck"]			= ("burnville_foley_22");
	
//*-23a. Martin, plant your explosives and take that Flakpanzer out.
	level.scr_face["foley"]["plant explosives"]		= (%facial_foley23);
	level.scrsound["foley"]["plant explosives"]		= ("burnville_foley_23a");

//*-23b. Stand back! Fire in the hole!
	level.scr_face["foley"]["fire in the hole"]		= (%facial_foley23);
	level.scrsound["foley"]["fire in the hole"]		= ("burnville_foley_23b");
	
//*-24. Okay. Move, move!
	level.scr_face["foley"]["move move"]			= (%facial_foley24);
	level.scrsound["foley"]["move move"]			= ("burnville_foley_24");

//	25a. Ok, number next! Let's take 'er out!
	level.scr_face["foley"]["take her out"]			= (%facial_foley25);
	level.scrsound["foley"]["take her out"]			= ("burnville_foley_25a");
	
//	25b. Martin, to the right! We'll lay down covering fire!
	level.scr_face["foley"]["to the right"]			= (%facial_foley25);
	level.scrsound["foley"]["to the right"]			= ("burnville_foley_25b");
	
//*-25c. Ya did good son, blow 'er up!
	level.scr_face["foley"]["blow her up"]			= (%facial_foley25);
	level.scrsound["foley"]["blow her up"]			= ("burnville_foley_25c");

//*	26. There's one more, get your butt movin'!
	level.scr_face["foley"]["1 more"]				= (%facial_foley26);
	level.scrsound["foley"]["1 more"]				= ("burnville_foley_26");

//	27. Work your way toward it! Shut 'er down!
	level.scr_face["foley"]["shut her down"]		= (%facial_foley27);
	level.scrsound["foley"]["shut her down"]		= ("burnville_foley_27");

//*	28. Martin! Explosives, go!
	level.scr_face["foley"]["explosives go"]		= (%facial_foley27);
	level.scrsound["foley"]["explosives go"]		= ("burnville_foley_28");

/*	
	29. All right fellas, take five, but listen up. We'll hold this place till reinforced, but this is just
	one tiny village in a war and country full of 'em, so our work has just begun. For those of you who've
	seen your first action, welcome to the Big Time. For those of you who've seen it before, trust me, you ain't seen
	nothing yet. We'll redeploy those German machine guns, setting up a perimeter. Keep your guard up and your buddies
	in mind.  Good work.
	level.scr_anim["foley"]["finale 1"]				= (%fullbody_foley28a);
	level.scr_face["foley"]["finale 1"]				= (%facial_foley28a);
	level.scrsound["foley"]["finale 1"]				= ("burnville_foley_29a");
	level.scr_anim["foley"]["finale 2"]				= (%fullbody_foley28b);
	level.scr_face["foley"]["finale 2"]				= (%facial_foley28b);
	level.scrsound["foley"]["finale 2"]				= ("burnville_foley_29b");
	level.scr_anim["foley"]["finale 3"]				= (%fullbody_foley28b);
	level.scr_face["foley"]["finale 3"]				= (%facial_foley28b);
	level.scrsound["foley"]["finale 3"]				= ("burnville_foley_29c");
*/ 	

	level.scr_anim["foley"]["finale"]				= %fullbody_foley28;
//	level.scr_face["foley"]["finale"]				= %facial_foley28a;
	level.scr_notetrack["foley"][0]["notetrack"]	= "dialogue";
	level.scr_notetrack["foley"][0]["anime"]		= "finale";
	level.scr_notetrack["foley"][0]["dialogue"]		= "burnville_foley_29a";
	level.scr_notetrack["foley"][0]["facial"]		= %Burnville_facial_Foley_061alt_a;
	
	level.scr_notetrack["foley"][1]["notetrack"]	= "dialogue";
	level.scr_notetrack["foley"][1]["anime"]		= "finale";
	level.scr_notetrack["foley"][1]["dialogue"]		= "burnville_foley_29b";
	level.scr_notetrack["foley"][1]["facial"]		= %Burnville_facial_Foley_061alt_b;

	level.scr_notetrack["foley"][2]["notetrack"]	= "dialogue";
	level.scr_notetrack["foley"][2]["anime"]		= "finale";
	level.scr_notetrack["foley"][2]["dialogue"]		= "burnville_foley_29c";
	level.scr_notetrack["foley"][2]["facial"]		= %Burnville_facial_Foley_061alt_c;

		


/*
	level.scr_anim["foley"]["finale 2"]				= (%fullbody_foley28b);
	level.scr_face["foley"]["finale 2"]				= (%facial_foley28b);
	level.scrsound["foley"]["finale 2"]				= ("burnville_foley_28b");
*/
	parachute();
	treeguy();
} 

#using_animtree("animation_rig_parachute");
parachute ()
{
	level.scr_animtree["parachute"] = #animtree;
	level.scr_anim["parachute"]["idle"][0]			= (%hanginggear_church_idle);
}

#using_animtree("pathfinder_treeguy");
treeguy()
{
	level.scr_animtree["tree_guy"] = #animtree;
	level.scr_anim["tree_guy"]["idle"][0]			= (%hangingguy_church_idle);
}
