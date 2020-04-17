
main()
{
	codescripts\character::setModelFromArray(xmodelalias\tourist_bodies_venice::main());
	self attach("head_tourist_2_alex_venice", "", false);
	self.hatModel = codescripts\character::randomElement(xmodelalias\tourist_hats_alex_venice::main());
	self attach(self.hatModel, "", true);
	self.voice = "american";
}

precache()
{
	codescripts\character::precacheModelArray(xmodelalias\tourist_bodies_venice::main());
	precacheModel("head_tourist_2_alex_venice");
	codescripts\character::precacheModelArray(xmodelalias\tourist_hats_alex_venice::main());
}
