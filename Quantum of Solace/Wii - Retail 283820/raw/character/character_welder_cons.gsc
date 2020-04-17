
main()
{
	self setModel("cons_welder_body");
	headArray = xmodelalias\cons_site_wrkr_heads::main();
	headIdx = codescripts\character::attachFromArray(headArray);
	self attach("cons_site_arms", "", false);
	self.hatModel = codescripts\character::randomElement(xmodelalias\cons_site_welder_helmets::main());
	self attach(self.hatModel, "", true);
	self.voice = "american";
}

precache()
{
	precacheModel("cons_welder_body");
	codescripts\character::precacheModelArray(xmodelalias\cons_site_wrkr_heads::main());
	precacheModel("cons_site_arms");
	codescripts\character::precacheModelArray(xmodelalias\cons_site_welder_helmets::main());
}
