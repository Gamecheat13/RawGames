main()
{
	//"image" sets image of slide to use
	//"dialog" sets dialog to start with slide
	//"delay" sets delay on this slide before continuing to the next delay overrides waiting for the sound on the current slide  
	//"dialog_wait" will wait on the dialog specified to finish.
	//  IE: sum of delays on previous delays < length of dialog 

	level.slide = [];
	
	slide = [];
	slide["image"] = "slideshow_bergstein_1";
	slide["dialog"] = "slideshow_bergstein_1";
	slide["delay"] = 5;
	level.slide[level.slide.size] = slide;

	slide = [];
	slide["image"] = "slideshow_bergstein_2";
	slide["delay"] = 3.3;
	level.slide[level.slide.size] = slide;

	slide = [];
	slide["dialog_wait"] = "slideshow_bergstein_1"; 
	slide["image"] = "slideshow_bergstein_3";
	slide["dialog"] = "slideshow_bergstein_2";
	slide["delay"] = 4.5;
	level.slide[level.slide.size] = slide;

	slide = [];
	slide["image"] = "slideshow_bergstein_4";
	slide["delay"] = 4;
	level.slide[level.slide.size] = slide;

	slide = [];
	slide["dialog_wait"] = "slideshow_bergstein_2"; 
	slide["image"] = "slideshow_bergstein_5";
	slide["dialog"] = "slideshow_bergstein_3";
	slide["delay"] = 3;
	level.slide[level.slide.size] = slide;

	slide = [];
	slide["image"] = "slideshow_bergstein_6";
	slide["delay"] = 2.5;
	level.slide[level.slide.size] = slide;

	slide = [];
	slide["dialog_wait"] = "slideshow_bergstein_3";
	slide["image"] = "slideshow_bergstein_7";
	slide["dialog"] = "slideshow_bergstein_4";
	slide["delay"] = 7;
	level.slide[level.slide.size] = slide;


//	level.tmpmsg["slideshow_bergstein_1"] = "December 7th, 1944. Allied forces cross the border between Belgium and Germany, encountering heavy resistance near the town of Bergstein. ";
//	level.tmpmsg["slideshow_bergstein_2"] = "Towering over the small town is Hill 400, providing German artillery spotters with a perfect view of Allied forces for miles in all directions. ";
//	level.tmpmsg["slideshow_bergstein_3"] = "Devastating artillery barrages directed from the summit inflict numerous losses upon the Allies. ";
//	level.tmpmsg["slideshow_bergstein_4"] = "Now, the U.S. 2nd Ranger Battalion prepares to capture the hill, and deny its use to the Germans...";

	level.levelToLoad = "bergstein";
	maps\_briefing::main();
}



