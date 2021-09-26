main()
{
	//"image" sets image of slide to use
	//"dialog" sets dialog to start with slide
	//"delay" sets delay on this slide before continuing to the next delay overrides waiting for the sound on the current slide  
	//"dialog_wait" will wait on the dialog specified to finish.
	//"movie" cinematic
	//  IE: sum of delays on previous delays < length of dialog 

	level.slide = [];
	
	slide = [];
	slide["movie"] = "movie_eastern";
	level.slide[level.slide.size] = slide;
	level.levelToLoad = "moscow";
	maps\_briefing::main();
}



