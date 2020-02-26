
main()
{
	self setModel("bond_sienarooftop_body");
	self attach("bond_sienarooftop_head", "", false);
	self.voice = "american";
}

precache()
{
	precacheModel("bond_sienarooftop_body");
	precacheModel("bond_sienarooftop_head");
}
