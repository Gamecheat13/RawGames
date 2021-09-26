main()
{
	//"image" sets image of slide to use
	//"dialog" sets dialog to start with slide
	//"delay" sets delay on this slide before continuing to the next delay overrides waiting for the sound on the current slide  
	//"dialog_wait" will wait on the dialog specified to finish.
	//  IE: sum of delays on previous delays < length of dialog 

	level.slide = [];
	
	slide = [];
	slide["image"] = "slideshow_tunisia_1";
	slide["dialog"] = "slideshow_tunisia_1";
	slide["delay"] = 5;
	level.slide[level.slide.size] = slide;

	slide = [];
	slide["image"] = "slideshow_tunisia_2";
	slide["delay"] = 5;
	
	level.slide[level.slide.size] = slide;

	slide = [];
	slide["dialog_wait"] = "slideshow_tunisia_1"; 
	slide["image"] = "slideshow_tunisia_3";
	slide["dialog"] = "slideshow_tunisia_2";
	slide["delay"] = 7;
	level.slide[level.slide.size] = slide;

	slide = [];
	slide["image"] = "slideshow_tunisia_4";
	slide["delay"] = 3;
	level.slide[level.slide.size] = slide;

	slide = [];
	slide["image"] = "slideshow_tunisia_5";
	slide["delay"] = 3;
	level.slide[level.slide.size] = slide;

	slide = [];
	slide["dialog_wait"] = "slideshow_tunisia_2"; 
	slide["image"] = "slideshow_tunisia_6";
	slide["delay"] = 3;
	slide["dialog"] = "slideshow_tunisia_3";
	level.slide[level.slide.size] = slide;

	slide = [];
	slide["image"] = "slideshow_tunisia_7";
	slide["delay"] = 5;
	level.slide[level.slide.size] = slide;

//	level.tmpmsg["slideshow_tunisia_1"] = "Tunisia, 1943. Gaining momentum, the Allies press Rommel's Afrika Korps into the Mareth Line, a twenty-two-mile stretch of defenses in eastern Tunisia. ";
//	level.tmpmsg["slideshow_tunisia_2"] = "Having lost their main supply base in Libya in January of 1943, the Afrika Korps prepares to hold their ground on two sides, as they are now trapped between the American forces to their west, and the British Commonwealth forces to the east. ";
//	level.tmpmsg["slideshow_tunisia_3"] = "Despite these advantages, the Allies must proceed with caution, for the local terrain favors the defenders...";

	level.levelToLoad = "toujane_ride";
	maps\_briefing::main();
}







