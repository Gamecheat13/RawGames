
main()
{
	codescripts\character::setModelFromArray(xmodelalias\lc_thug_bodies_sienna::main());
	self attach("lc_thug_1_head_sienna", "", false);
	self attach("hands_white_1", "", false);
	self.voice = "american";
}

precache()
{
	codescripts\character::precacheModelArray(xmodelalias\lc_thug_bodies_sienna::main());
	precacheModel("lc_thug_1_head_sienna");
	precacheModel("hands_white_1");
}
