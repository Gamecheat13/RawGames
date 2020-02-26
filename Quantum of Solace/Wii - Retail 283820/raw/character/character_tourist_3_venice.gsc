
main()
{
	codescripts\character::setModelFromArray(xmodelalias\tourist_bodies_venice::main());
	self attach("head_tourist_3_jack_venice", "", false);
	self.voice = "american";
}

precache()
{
	codescripts\character::precacheModelArray(xmodelalias\tourist_bodies_venice::main());
	precacheModel("head_tourist_3_jack_venice");
}
