
main()
{
	codescripts\character::setModelFromArray(xmodelalias\obanno_henchman_bodies::main());
	self attach("thug_01_head_shanty", "", false);
	self.voice = "american";
}

precache()
{
	codescripts\character::precacheModelArray(xmodelalias\obanno_henchman_bodies::main());
	precacheModel("thug_01_head_shanty");
}
