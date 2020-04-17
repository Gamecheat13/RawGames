
main()
{
	codescripts\character::setModelFromArray(xmodelalias\lc_thug_bodies_white::main());
	self attach("lc_thug_3_head_white", "", false);
	self attach("hands_white_1", "", false);
	self.voice = "american";
}

precache()
{
	codescripts\character::precacheModelArray(xmodelalias\lc_thug_bodies_white::main());
	precacheModel("lc_thug_3_head_white");
	precacheModel("hands_white_1");
}
