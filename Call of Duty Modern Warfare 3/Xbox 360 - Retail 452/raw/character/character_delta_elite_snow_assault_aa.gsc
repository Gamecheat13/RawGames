// THIS FILE IS AUTOGENERATED, DO NOT MODIFY
main()
{
	self setModel("body_delta_elite_snow_assault_aa");
	codescripts\character::attachHead( "alias_delta_elite_heads_longsleeves", xmodelalias\alias_delta_elite_heads_longsleeves::main() );
	self.voice = "delta";
}

precache()
{
	precacheModel("body_delta_elite_snow_assault_aa");
	codescripts\character::precacheModelArray(xmodelalias\alias_delta_elite_heads_longsleeves::main());
}
