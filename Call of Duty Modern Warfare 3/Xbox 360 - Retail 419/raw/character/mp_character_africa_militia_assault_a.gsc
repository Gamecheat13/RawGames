// THIS FILE IS AUTOGENERATED, DO NOT MODIFY
main()
{
	self setModel("mp_body_africa_militia_assault_a");
	codescripts\character::attachHead( "alias_africa_militia_heads_mp", xmodelalias\alias_africa_militia_heads_mp::main() );
	self setViewmodel("viewhands_african_militia");
	self.voice = "african";
}

precache()
{
	precacheModel("mp_body_africa_militia_assault_a");
	codescripts\character::precacheModelArray(xmodelalias\alias_africa_militia_heads_mp::main());
	precacheModel("viewhands_african_militia");
}
