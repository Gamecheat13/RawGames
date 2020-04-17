
main()
{
	codescripts\character::setModelFromArray(xmodelalias\lc_thug_bodies_afro_venice::main());
	self attach("lc_thug_3_head_SC_A", "", false);
	self attach("hands_white_1", "", false);
	self.voice = "american";
}

precache()
{
	codescripts\character::precacheModelArray(xmodelalias\lc_thug_bodies_afro_venice::main());
	precacheModel("lc_thug_3_head_SC_A");
	precacheModel("hands_white_1");
}
