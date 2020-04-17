
main()
{
	codescripts\character::setModelFromArray(xmodelalias\obanno_henchman_bodies::main());
	self attach("obanno_henchman_01_head", "", false);
	self.voice = "american";
}

precache()
{
	codescripts\character::precacheModelArray(xmodelalias\obanno_henchman_bodies::main());
	precacheModel("obanno_henchman_01_head");
}
