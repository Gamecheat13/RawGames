
main()
{
	codescripts\character::setModelFromArray(xmodelalias\cons_site_wrkr_bodies::main());
	headArray = xmodelalias\cons_site_wrkr_heads::main();
	headIdx = codescripts\character::attachFromArray(headArray);
	self attach("cons_site_arms", "", false);
	self.hatModel = codescripts\character::randomElement(xmodelalias\cons_site_wrkr_helmets::main());
	self attach(self.hatModel, "", true);
	self.voice = "american";
}

precache()
{
	codescripts\character::precacheModelArray(xmodelalias\cons_site_wrkr_bodies::main());
	codescripts\character::precacheModelArray(xmodelalias\cons_site_wrkr_heads::main());
	precacheModel("cons_site_arms");
	codescripts\character::precacheModelArray(xmodelalias\cons_site_wrkr_helmets::main());
}
