// THIS FILE IS AUTOGENERATED, DO NOT MODIFY
main()
{
	self setModel("body_fso_vest_c");
	codescripts\character::attachHead( "alias_fso_heads", xmodelalias\alias_fso_heads::main() );
	self.voice = "russian";
}

precache()
{
	precacheModel("body_fso_vest_c");
	codescripts\character::precacheModelArray(xmodelalias\alias_fso_heads::main());
}
