// THIS FILE IS AUTOGENERATED, DO NOT MODIFY
main()
{
	self setModel("body_prague_civ_male_b");
	self attach("head_prague_civ_male_a_hat", "", true);
	self.headModel = "head_prague_civ_male_a_hat";
	if ( isendstr( self.headModel, "_hat" ) )
		codescripts\character::attachHat( "alias_prague_civilian_hats", xmodelalias\alias_prague_civilian_hats::main() );
	self.voice = "czech";
}

precache()
{
	precacheModel("body_prague_civ_male_b");
	precacheModel("head_prague_civ_male_a_hat");
	codescripts\character::precacheModelArray(xmodelalias\alias_prague_civilian_hats::main());
}
