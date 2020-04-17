
main()
{
	codescripts\character::setModelFromArray(xmodelalias\lc_thug_bodies_barge::main());
	self attach("lc_thug_4_head_barge", "", false);
	self attach("hands_white_1", "", false);
	self.voice = "american";
}

precache()
{
	codescripts\character::precacheModelArray(xmodelalias\lc_thug_bodies_barge::main());
	precacheModel("lc_thug_4_head_barge");
	precacheModel("hands_white_1");
}
