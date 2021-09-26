main()
{
	//"image" sets image of slide to use
	//"dialog" sets dialog to start with slide
	//"delay" sets delay on this slide before continuing to the next delay overrides waiting for the sound on the current slide  
	//"dialog_wait" will wait on the dialog specified to finish.
	//  IE: sum of delays on previous delays < length of dialog 

	level.slide = [];
	
	slide = [];
	slide["image"] = "slideshow_libya_1";
	slide["dialog"] = "slideshow_libya_1";
	slide["delay"] = 7;
	level.slide[level.slide.size] = slide;

	slide = [];
	slide["dialog_wait"] = "slideshow_libya_1"; 
	slide["image"] = "slideshow_libya_2";
	slide["dialog"] = "slideshow_libya_2";
	slide["delay"] = 4;
	level.slide[level.slide.size] = slide;

	slide = [];
	slide["image"] = "slideshow_libya_3";
	slide["delay"] = 6;
	level.slide[level.slide.size] = slide;

	slide = [];
	slide["dialog_wait"] = "slideshow_libya_2"; 
	slide["image"] = "slideshow_libya_4";
	slide["dialog"] = "slideshow_libya_3";
	slide["delay"] = 2;
	level.slide[level.slide.size] = slide;

	slide = [];
	slide["image"] = "slideshow_libya_5";
	slide["delay"] = 3.5;
	level.slide[level.slide.size] = slide;

	slide = [];
	slide["dialog_wait"] = "slideshow_libya_3"; 
	slide["image"] = "slideshow_libya_6";
	slide["dialog"] = "slideshow_libya_4";
	slide["delay"] = 4;
	level.slide[level.slide.size] = slide;

	slide = [];
	slide["image"] = "slideshow_libya_7";
	slide["delay"] = 3;
	level.slide[level.slide.size] = slide;

	slide = [];
	slide["image"] = "slideshow_libya_8";
	slide["delay"] = 5;
	level.slide[level.slide.size] = slide;

//	level.tmpmsg["slideshow_libya_1"] = "Libya, 1943. The British Crusader tank enters its second year of service in the North African desert campaign. ";
//	level.tmpmsg["slideshow_libya_2"] = "Desert tank warfare proves difficult and challenging for both sides. Dust clouds kicked up by the movement of the tanks and the firing of their cannons create poor visibility conditions during combat. ";
//	level.tmpmsg["slideshow_libya_3"] = "Navigation is also a problem - the vast Libyan desert offers little in the way of recognizable landmarks.";
//	level.tmpmsg["slideshow_libya_4"] = "The British Crusaders, whose guns lack the range of their German counterparts, are forced to use massed, high speed charges to close within firing range - a dangerous strategy that leaves much to be desired…";

	level.levelToLoad = "libya";
	maps\_briefing::main();
}







