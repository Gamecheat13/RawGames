// THIS FILE IS AUTOGENERATED, DO NOT MODIFY
main()
{
	self setModel("mp_body_pmc_africa_shotgun_a");
	codescripts\character::attachHead( "alias_pmc_africa_heads", xmodelalias\alias_pmc_africa_heads::main() );
	self setViewmodel("viewhands_pmc");
	self.voice = "russian";
}

precache()
{
	precacheModel("mp_body_pmc_africa_shotgun_a");
	codescripts\character::precacheModelArray(xmodelalias\alias_pmc_africa_heads::main());
	precacheModel("viewhands_pmc");
}
