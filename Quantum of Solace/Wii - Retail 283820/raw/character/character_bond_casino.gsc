
main()
{
	self setModel("bond_tux_1_body");
	self attach("bond_tux_head", "", false);
	self.voice = "american";
}

precache()
{
	precacheModel("bond_tux_1_body");
	precacheModel("bond_tux_head");
}
