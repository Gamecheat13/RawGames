// THIS FILE IS AUTOGENERATED, DO NOT MODIFY
main()
{
	self setModel("body_russian_military_rpg_a_arctic");
	codescripts\character::attachHead( "alias_russian_military_rescue_heads", xmodelalias\alias_russian_military_rescue_heads::main() );
	self.voice = "russian";
}

precache()
{
	precacheModel("body_russian_military_rpg_a_arctic");
	codescripts\character::precacheModelArray(xmodelalias\alias_russian_military_rescue_heads::main());
}
