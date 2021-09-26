main()
{
	//"image" sets image of slide to use
	//"dialog" sets dialog to start with slide
	//"delay" sets delay on this slide before continuing to the next delay overrides waiting for the sound on the current slide  
	//"dialog_wait" will wait on the dialog specified to finish.
	//  IE: sum of delays on previous delays < length of dialog 

	level.slide = [];
	
	slide = [];
	slide["image"] = "slideshow_caen_1";
	slide["dialog"] = "slideshow_caen_1";
	slide["delay"] = 5.5;
	level.slide[level.slide.size] = slide;

	slide = [];
	slide["image"] = "slideshow_caen_2";
	slide["delay"] = 4.7;
	level.slide[level.slide.size] = slide;

	slide = [];
	slide["dialog_wait"] = "slideshow_caen_1"; 
	slide["image"] = "slideshow_caen_3";
	slide["dialog"] = "slideshow_caen_2";
	slide["delay"] = 7;
	level.slide[level.slide.size] = slide;

	slide = [];
	slide["dialog_wait"] = "slideshow_caen_2"; 
	slide["image"] = "slideshow_caen_4";
	slide["dialog"] = "slideshow_caen_3";
	slide["delay"] = 5.9;
	level.slide[level.slide.size] = slide;

	slide = [];
	slide["dialog_wait"] = "slideshow_caen_3"; 
	slide["image"] = "slideshow_caen_5";
	slide["dialog"] = "slideshow_caen_4";
	slide["delay"] = 3;
	level.slide[level.slide.size] = slide;

	slide = [];
	slide["image"] = "slideshow_caen_6";
	slide["delay"] = 3;
	level.slide[level.slide.size] = slide;

//	level.tmpmsg["slideshow_caen_1"] = "June 11th, 1944. Only a few miles east of the American landing beaches in Normandy France, British Commonwealth forces struggle to capture the major city of Caen. ";
//	level.tmpmsg["slideshow_caen_2"] = "It is here that they are faced with the superior firepower of elite Panzer Divisions arrayed along the German defensive line. ";
//	level.tmpmsg["slideshow_caen_3"] = "To break the stalemate, the veteran Desert Rats of the 7th Armoured Division are sent into the hedgerows of Normandy. ";
//	level.tmpmsg["slideshow_caen_4"] = "Their mission: probe the western flank of the German defenses and clear a path to the city of Caen...";

	level.levelToLoad = "beltot";
	maps\_briefing::main();
}



