// THIS FILE IS AUTOGENERATED, DO NOT MODIFY
main()
{
	self setModel("body_russian_military_smg_a_woodland_dusty");
	codescripts\character::attachHead( "alias_russian_military_heavy_heads", xmodelalias\alias_russian_military_heavy_heads::main() );
	self.voice = "russian";
}

precache()
{
	precacheModel("body_russian_military_smg_a_woodland_dusty");
	codescripts\character::precacheModelArray(xmodelalias\alias_russian_military_heavy_heads::main());
}
