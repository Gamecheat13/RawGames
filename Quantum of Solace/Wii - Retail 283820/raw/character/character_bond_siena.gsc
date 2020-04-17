
main()
{
	self setModel("bond_siena_body");
	self attach("bond_siena_head", "", false);
	self.voice = "american";
}

precache()
{
	precacheModel("bond_siena_body");
	precacheModel("bond_siena_head");
}
