
main()
{
	codescripts\character::setModelFromArray(xmodelalias\lc_thug_bodies_casino::main());
	self attach("lc_thug_2_head_casino", "", false);
	self attach("hands_white_1", "", false);
	self.voice = "american";
}

precache()
{
	codescripts\character::precacheModelArray(xmodelalias\lc_thug_bodies_casino::main());
	precacheModel("lc_thug_2_head_casino");
	precacheModel("hands_white_1");
}
