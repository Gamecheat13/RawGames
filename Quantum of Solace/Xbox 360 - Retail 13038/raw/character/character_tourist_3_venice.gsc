// THIS FILE IS AUTOGENERATED, DO NOT MODIFY
main()
{
	body = xmodelalias\tourist_bodies_venice::getnextmodel();
	self setModel( body );
	self attach("head_tourist_3_jack_venice", "", false);
	hatModel = xmodelalias\tourist_3_facials::getnextmodel();
	self.hatModel = hatModel;
	self attach(self.hatModel, "", true);
	self.voice = "american";
}

precache()
{
	codescripts\character::precacheModelArray(xmodelalias\tourist_bodies_venice::main());
	precacheModel("head_tourist_3_jack_venice");
	codescripts\character::precacheModelArray(xmodelalias\tourist_3_facials::main());
}