// THIS FILE IS AUTOGENERATED, DO NOT MODIFY
main()
{
	codescripts\character::setModelFromArray(xmodelalias\alias_russian_naval_bodies::main());
	codescripts\character::attachHead( "alias_russian_naval_heads", xmodelalias\alias_russian_naval_heads::main() );
	self.voice = "russian";
}

precache()
{
	codescripts\character::precacheModelArray(xmodelalias\alias_russian_naval_bodies::main());
	codescripts\character::precacheModelArray(xmodelalias\alias_russian_naval_heads::main());
}
