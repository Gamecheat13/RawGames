
main()
{
	codescripts\character::setModelFromArray(xmodelalias\lc_thug_bodies_airport::main());
	self attach("lc_thug_4_head_airport", "", false);
	self attach("hands_white_1", "", false);
	self.voice = "american";
}

precache()
{
	codescripts\character::precacheModelArray(xmodelalias\lc_thug_bodies_airport::main());
	precacheModel("lc_thug_4_head_airport");
	precacheModel("hands_white_1");
}
