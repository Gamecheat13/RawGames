// THIS FILE IS AUTOGENERATED, DO NOT MODIFY
main()
{
	self setModel("body_opforce_fsb_assault_a");
	codescripts\character::attachHead( "alias_opforce_fsb_heads", xmodelalias\alias_opforce_fsb_heads::main() );
	self.voice = "russian";
}

precache()
{
	precacheModel("body_opforce_fsb_assault_a");
	codescripts\character::precacheModelArray(xmodelalias\alias_opforce_fsb_heads::main());
}