// THIS FILE IS AUTOGENERATED, DO NOT MODIFY
main()
{
	self setModel("mp_body_henchmen_smg_b");
	codescripts\character::attachHead( "alias_henchmen_heads_mp", xmodelalias\alias_henchmen_heads_mp::main() );
	self setViewmodel("viewhands_henchmen");
	self.voice = "russian";
}

precache()
{
	precacheModel("mp_body_henchmen_smg_b");
	codescripts\character::precacheModelArray(xmodelalias\alias_henchmen_heads_mp::main());
	precacheModel("viewhands_henchmen");
}
