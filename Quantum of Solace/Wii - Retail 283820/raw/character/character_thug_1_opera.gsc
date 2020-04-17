
main()
{
	codescripts\character::setModelFromArray(xmodelalias\lc_thug_bodies_opera::main());
	self attach("lc_thug_1_head_opera", "", false);
	self attach("hands_white_1", "", false);
	self.voice = "american";
}

precache()
{
	codescripts\character::precacheModelArray(xmodelalias\lc_thug_bodies_opera::main());
	precacheModel("lc_thug_1_head_opera");
	precacheModel("hands_white_1");
}
