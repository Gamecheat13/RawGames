// THIS FILE IS AUTOGENERATED, DO NOT MODIFY
main()
{
	self setModel("mp_body_gign_paris_lmg");
	self attach("head_gign_a", "", true);
	self.headModel = "head_gign_a";
	self setViewmodel("viewhands_sas");
	self.voice = "french";
}

precache()
{
	precacheModel("mp_body_gign_paris_lmg");
	precacheModel("head_gign_a");
	precacheModel("viewhands_sas");
}
