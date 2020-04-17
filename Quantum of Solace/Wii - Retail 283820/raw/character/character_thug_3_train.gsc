
main()
{
	codescripts\character::setModelFromArray(xmodelalias\lc_thug_bodies_train::main());
	self attach("lc_thug_3_head_train", "", false);
	self attach("hands_white_1", "", false);
	self.voice = "american";
}

precache()
{
	codescripts\character::precacheModelArray(xmodelalias\lc_thug_bodies_train::main());
	precacheModel("lc_thug_3_head_train");
	precacheModel("hands_white_1");
}
