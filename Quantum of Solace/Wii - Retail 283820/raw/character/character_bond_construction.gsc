
main()
{
	self setModel("bond_construction_body");
	self attach("bond_construction_head", "", false);
	self.voice = "american";
}

precache()
{
	precacheModel("bond_construction_body");
	precacheModel("bond_construction_head");
}
