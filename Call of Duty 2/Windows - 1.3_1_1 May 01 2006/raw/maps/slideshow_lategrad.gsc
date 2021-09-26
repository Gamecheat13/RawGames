main()
{
	//"image" sets image of slide to use
	//"dialog" sets dialog to start with slide
	//"delay" sets delay on this slide before continuing to the next delay overrides waiting for the sound on the current slide  
	//"dialog_wait" will wait on the dialog specified to finish.
	//  IE: sum of delays on previous delays < length of dialog 

	level.slide = [];
	
	slide = [];
	slide["image"] = "slideshow_lategrad_1";
	slide["dialog"] = "slideshow_lategrad_1";
	slide["delay"] = 7;
	level.slide[level.slide.size] = slide;

	slide = [];
	slide["image"] = "slideshow_lategrad_2";
	slide["delay"] = 3.5;
	level.slide[level.slide.size] = slide;

	slide = [];
	slide["dialog_wait"] = "slideshow_lategrad_1"; 
	slide["image"] = "slideshow_lategrad_3";
	slide["dialog"] = "slideshow_lategrad_2";
	slide["delay"] = 5;
	level.slide[level.slide.size] = slide;

	slide = [];
	slide["image"] = "slideshow_lategrad_4";
	slide["delay"] = 5.4;
	level.slide[level.slide.size] = slide;

	slide = [];
	slide["dialog_wait"] = "slideshow_lategrad_2"; 
	slide["image"] = "slideshow_lategrad_5";
	slide["dialog"] = "slideshow_lategrad_3";
	slide["delay"] = 4;
	level.slide[level.slide.size] = slide;

	slide = [];
	slide["image"] = "slideshow_lategrad_6";
	slide["delay"] = 5.5;
	level.slide[level.slide.size] = slide;

//	level.tmpmsg["slideshow_lategrad_1"] = "January 2nd, 1943. Surrounded on all sides by Soviet forces, the German 6th Army at Stalingrad continues to crumble in the absence of a desperately-needed supply line. ";
//	level.tmpmsg["slideshow_lategrad_2"] = "Many German soldiers trapped in the city, who are now literally starving and running out of ammunition, continue to fight regardless, fearing that the Soviets will execute those who attempt to surrender. ";
//	level.tmpmsg["slideshow_lategrad_3"] = "The fighting amongst the firebombed ruins of the city intensifies, as thousands of Soviet infantry continue to retake Stalingrad, one block at a time...";

	level.levelToLoad = "downtown_assault";
	maps\_briefing::main();
}







