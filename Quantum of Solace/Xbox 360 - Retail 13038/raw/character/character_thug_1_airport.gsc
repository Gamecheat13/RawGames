// THIS FILE IS AUTOGENERATED, DO NOT MODIFY
main()
{
	body = xmodelalias\cas_thug_bodies_afro_airport::getnextmodel();
	self setModel( body );
	self attach("cas_thug_1_head_airport", "", false);
	hatModel = xmodelalias\cas_thug_1_beards_airport::getnextmodel();
	self.hatModel = hatModel;
	self attach(self.hatModel, "", true);
	self.voice = "american";
}

precache()
{
	codescripts\character::precacheModelArray(xmodelalias\cas_thug_bodies_afro_airport::main());
	precacheModel("cas_thug_1_head_airport");
	codescripts\character::precacheModelArray(xmodelalias\cas_thug_1_beards_airport::main());
}