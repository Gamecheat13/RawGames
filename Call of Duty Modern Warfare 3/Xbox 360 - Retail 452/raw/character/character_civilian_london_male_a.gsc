// THIS FILE IS AUTOGENERATED, DO NOT MODIFY
main()
{
	self setModel("body_london_male_a");
	codescripts\character::attachHead( "alias_civilian_heads_male", xmodelalias\alias_civilian_heads_male::main() );
	self.voice = "british";
}

precache()
{
	precacheModel("body_london_male_a");
	codescripts\character::precacheModelArray(xmodelalias\alias_civilian_heads_male::main());
}
