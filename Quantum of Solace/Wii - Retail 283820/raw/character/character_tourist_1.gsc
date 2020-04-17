
main()
{
	codescripts\character::setModelFromArray(xmodelalias\tourist_bodies_B1_Aw1::main());
	self attach("head_tourist_4", "", false);
	self.voice = "american";
}

precache()
{
	codescripts\character::precacheModelArray(xmodelalias\tourist_bodies_B1_Aw1::main());
	precacheModel("head_tourist_4");
}
