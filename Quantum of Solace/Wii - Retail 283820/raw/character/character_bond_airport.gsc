
main()
{
	self setModel("bond_miami_body");
	self attach("bond_miami_head", "", false);
	self.voice = "american";
}

precache()
{
	precacheModel("bond_miami_body");
	precacheModel("bond_miami_head");
}