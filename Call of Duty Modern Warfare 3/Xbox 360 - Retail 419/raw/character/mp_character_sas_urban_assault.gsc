// THIS FILE IS AUTOGENERATED, DO NOT MODIFY
main()
{
	self setModel("mp_body_sas_urban_assault");
	codescripts\character::attachHead( "alias_sas_heads", xmodelalias\alias_sas_heads::main() );
	self setViewmodel("viewhands_sas");
	self.voice = "british";
}

precache()
{
	precacheModel("mp_body_sas_urban_assault");
	codescripts\character::precacheModelArray(xmodelalias\alias_sas_heads::main());
	precacheModel("viewhands_sas");
}
