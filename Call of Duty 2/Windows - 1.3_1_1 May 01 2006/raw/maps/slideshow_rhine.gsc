main()
{
	//"image" sets image of slide to use
	//"dialog" sets dialog to start with slide
	//"delay" sets delay on this slide before continuing to the next delay overrides waiting for the sound on the current slide  
	//"dialog_wait" will wait on the dialog specified to finish.
	//  IE: sum of delays on previous delays < length of dialog 

	level.slide = [];
	
	slide = [];
	slide["image"] = "slideshow_rhine_1";
	slide["dialog"] = "slideshow_rhine_1";
	slide["delay"] = 6;
	level.slide[level.slide.size] = slide;

	slide = [];
	slide["image"] = "slideshow_rhine_2";
	slide["delay"] = 3;
	level.slide[level.slide.size] = slide;

	slide = [];
	slide["dialog_wait"] = "slideshow_rhine_1"; 
	slide["image"] = "slideshow_rhine_3";
	slide["dialog"] = "slideshow_rhine_2";
	slide["delay"] = 4;
	level.slide[level.slide.size] = slide;

	slide = [];
	slide["image"] = "slideshow_rhine_4";
	slide["delay"] = 3.5;
	level.slide[level.slide.size] = slide;

	slide = [];
	slide["dialog_wait"] = "slideshow_rhine_2"; 
	slide["image"] = "slideshow_rhine_5";
	slide["dialog"] = "slideshow_rhine_3";
	slide["delay"] = 3.7;
	level.slide[level.slide.size] = slide;

	slide = [];
	slide["image"] = "slideshow_rhine_6";
	slide["delay"] = 3.5;
	level.slide[level.slide.size] = slide;

	slide = [];
	slide["dialog_wait"] = "slideshow_rhine_3"; 
	slide["image"] = "slideshow_rhine_7";
	slide["dialog"] = "slideshow_rhine_4";
	slide["delay"] = 3;
	level.slide[level.slide.size] = slide;

	slide = [];
	slide["image"] = "slideshow_rhine_8";
	slide["delay"] = 5;
	level.slide[level.slide.size] = slide;


//	level.tmpmsg["slideshow_rhine_1"] = "March 7th, 1945. In an extraordinary turn of events, a single bridge across the Rhine river is captured intact by the U.S. 9th Armored Division. ";
//	level.tmpmsg["slideshow_rhine_2"] = "German forces desperately establish new pockets of defense along the length of the Rhine river in an effort to slow the Allies' advance. ";
//	level.tmpmsg["slideshow_rhine_3"] = "Then, on March 24th, a massive assault is unleashed by Allied airborne divisions to secure positions east of the Rhine. ";
//	level.tmpmsg["slideshow_rhine_4"] = "At the same time, at various points up and down the river, more Allied forces prepare to make their own crossings into the heart of Germany...";

	level.levelToLoad = "rhine";
	maps\_briefing::main();
}



