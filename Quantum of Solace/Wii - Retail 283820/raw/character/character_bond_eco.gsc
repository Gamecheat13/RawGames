
main()
{
	self setModel("bond_eco_body");
	self attach("bond_eco_head", "", false);
	self.voice = "american";
}

precache()
{
	precacheModel("bond_eco_body");
	precacheModel("bond_eco_head");
}
