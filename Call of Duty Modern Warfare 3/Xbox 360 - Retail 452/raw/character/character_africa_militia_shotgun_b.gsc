// THIS FILE IS AUTOGENERATED, DO NOT MODIFY
main()
{
	self setModel("body_africa_militia_shotgun_b");
	self attach("head_africa_militia_c_hat", "", true);
	self.headModel = "head_africa_militia_c_hat";
	if ( isendstr( self.headModel, "_hat" ) )
		codescripts\character::attachHat( "alias_africa_militia_hats_c", xmodelalias\alias_africa_militia_hats_c::main() );
	self.voice = "african";
}

precache()
{
	precacheModel("body_africa_militia_shotgun_b");
	precacheModel("head_africa_militia_c_hat");
	codescripts\character::precacheModelArray(xmodelalias\alias_africa_militia_hats_c::main());
}
