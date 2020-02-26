
main()
{
	codescripts\character::setModelFromArray(xmodelalias\tourist_bodies_venice::main());
	self attach("head_tourist_1_kent_venice", "", false);
	self.voice = "american";
}

precache()
{
	codescripts\character::precacheModelArray(xmodelalias\tourist_bodies_venice::main());
	precacheModel("head_tourist_1_kent_venice");
}
