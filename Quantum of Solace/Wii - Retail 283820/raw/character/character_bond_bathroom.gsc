
main()
{
	self setModel("bond_bathroom_body");
	self attach("bond_bathroom_head", "", false);
	self.voice = "american";
}

precache()
{
	precacheModel("bond_bathroom_body");
	precacheModel("bond_bathroom_head");
}