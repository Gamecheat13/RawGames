// THIS FILE IS AUTOGENERATED, DO NOT MODIFY
main()
{
	self setModel("body_henchmen_lmg_b");
	codescripts\character::attachHead( "alias_henchmen_heads", xmodelalias\alias_henchmen_heads::main() );
	self.voice = "russian";
}

precache()
{
	precacheModel("body_henchmen_lmg_b");
	codescripts\character::precacheModelArray(xmodelalias\alias_henchmen_heads::main());
}
