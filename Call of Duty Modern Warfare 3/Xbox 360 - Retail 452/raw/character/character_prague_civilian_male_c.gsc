// THIS FILE IS AUTOGENERATED, DO NOT MODIFY
main()
{
	self setModel("body_prague_civ_male_c");
	self attach("head_prague_civ_male_b_hat", "", true);
	self.headModel = "head_prague_civ_male_b_hat";
	if ( isendstr( self.headModel, "_hat" ) )
	{
		self.hatModel = "hat_prague_civ_e";
		self attach(self.hatModel);
	}
	self.voice = "czech";
}

precache()
{
	precacheModel("body_prague_civ_male_c");
	precacheModel("head_prague_civ_male_b_hat");
	precacheModel("hat_prague_civ_e");
}
