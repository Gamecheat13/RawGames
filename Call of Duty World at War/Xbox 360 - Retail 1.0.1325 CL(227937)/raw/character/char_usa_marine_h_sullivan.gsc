// THIS FILE IS AUTOGENERATED, DO NOT MODIFY
main()
{
	self setModel("char_usa_marine_sullivan");
	self.hatModel = "char_usa_raider_helm2";
	self attach(self.hatModel);
	self.voice = "american";
}

precache()
{
	precacheModel("char_usa_marine_sullivan");
	precacheModel("char_usa_raider_helm2");
}