
main()
{
	self setModel("bond_train_rain_body");
	self attach("bond_train_rain_head", "", false);
	self.voice = "american";
}

precache()
{
	precacheModel("bond_train_rain_body");
	precacheModel("bond_train_rain_head");
}
