main()
{
	//"image" sets image of slide to use
	//"dialog" sets dialog to start with slide
	//"delay" sets delay on this slide before continuing to the next delay overrides waiting for the sound on the current slide  
	//"dialog_wait" will wait on the dialog specified to finish.
	//  IE: sum of delays on previous delays < length of dialog 

	level.slide = [];
	
	slide = [];
	slide["image"] = "slideshow_earlygrad_1";
	slide["dialog"] = "slideshow_earlygrad_1";
	slide["delay"] = 3;
	level.slide[level.slide.size] = slide;

	slide = [];
	slide["image"] = "slideshow_earlygrad_2";
	slide["delay"] = 5;
	level.slide[level.slide.size] = slide;

	slide = [];
	slide["image"] = "slideshow_earlygrad_3";
	slide["delay"] = 3.8;
	level.slide[level.slide.size] = slide;

	slide = [];
	slide["dialog_wait"] = "slideshow_earlygrad_1";
	slide["image"] = "slideshow_earlygrad_4";
	slide["dialog"] = "slideshow_earlygrad_2";
	slide["delay"] = 4;
	level.slide[level.slide.size] = slide;

	slide = [];
	slide["image"] = "slideshow_earlygrad_5";
	slide["delay"] = 4;
	level.slide[level.slide.size] = slide;

	slide = [];
	slide["dialog_wait"] = "slideshow_earlygrad_2";
	slide["image"] = "slideshow_earlygrad_6";
	slide["dialog"] = "slideshow_earlygrad_3";
	slide["delay"] = 5;
	level.slide[level.slide.size] = slide;

	slide = [];
	slide["image"] = "slideshow_earlygrad_7";
	slide["delay"] = 3;
	level.slide[level.slide.size] = slide;

	slide = [];		
	slide["dialog_wait"] = "slideshow_earlygrad_3";
	slide["image"] = "slideshow_earlygrad_8";
	slide["dialog"] = "slideshow_earlygrad_4";
	slide["delay"] = 7.5;
	level.slide[level.slide.size] = slide;

//	level.tmpmsg["slideshow_earlygrad_1"] = "Stalingrad, 1942. German forces, having reduced the city to rubble in a massive aerial bombardment, meet with heavy resistance as the Soviet Red Army throws its entire force into the defense of Stalingrad.";
//	level.tmpmsg["slideshow_earlygrad_2"] = "In the chaos of constant warfare, battle lines have dissolved. The ruins of the city have been divided up into hardpoints surrounded by no-man's-land.";
//	level.tmpmsg["slideshow_earlygrad_3"] = "The German tactical advantage of the mechanized blitzkrieg, and its coordinated infantry and tank attacks, is rendered useless in the concentrated street fighting. ";
//	level.tmpmsg["slideshow_earlygrad_4"] = "Threatened with execution if they retreat, the Soviet troops have no choice but to push forward into the bloodbath...";

	level.levelToLoad = "tankhunt";
	maps\_briefing::main();
}







