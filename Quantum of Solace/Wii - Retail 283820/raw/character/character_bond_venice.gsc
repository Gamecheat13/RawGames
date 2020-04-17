
main()
{
	self setModel("bond_venice_body");
	self attach("bond_venice_head", "", false);
	self.voice = "american";
}

precache()
{
	precacheModel("bond_venice_body");
	precacheModel("bond_venice_head");
}
