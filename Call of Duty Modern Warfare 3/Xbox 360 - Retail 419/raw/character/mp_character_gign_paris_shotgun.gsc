// THIS FILE IS AUTOGENERATED, DO NOT MODIFY
main()
{
	self setModel("mp_body_gign_paris_shotgun");
	self attach("head_gign_b", "", true);
	self.headModel = "head_gign_b";
	self setViewmodel("viewhands_sas");
	self.voice = "french";
}

precache()
{
	precacheModel("mp_body_gign_paris_shotgun");
	precacheModel("head_gign_b");
	precacheModel("viewhands_sas");
}
