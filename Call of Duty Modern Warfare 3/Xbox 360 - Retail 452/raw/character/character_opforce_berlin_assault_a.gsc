// THIS FILE IS AUTOGENERATED, DO NOT MODIFY
main()
{
	self setModel("body_russian_military_assault_a_woodland");
	codescripts\character::attachHead( "alias_russian_military_heavy_heads", xmodelalias\alias_russian_military_heavy_heads::main() );
	self.voice = "russian";
}

precache()
{
	precacheModel("body_russian_military_assault_a_woodland");
	codescripts\character::precacheModelArray(xmodelalias\alias_russian_military_heavy_heads::main());
}
