// THIS FILE IS AUTOGENERATED, DO NOT MODIFY
main()
{
	body = xmodelalias\cons_site_wrkr_bodies::getnextmodel();
	self setModel( body );
	headArray = xmodelalias\cons_site_wrkr_heads::main();
	headIdx = codescripts\character::attachFromArray(headArray);
	self attach("cons_site_arms", "", false);
	hatModel = xmodelalias\cons_site_wrkr_helmets::getnextmodel();
	self.hatModel = hatModel;
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