
main()
{
	codescripts\character::setModelFromArray(xmodelalias\lc_thug_bodies_SC_B::main());
	self attach("lc_thug_4_head_SC_A", "", false);
	self attach("hands_white_1", "", false);
	self.voice = "american";
}

precache()
{
	codescripts\character::precacheModelArray(xmodelalias\lc_thug_bodies_SC_B::main());
	precacheModel("lc_thug_4_head_SC_A");
	precacheModel("hands_white_1");
}
