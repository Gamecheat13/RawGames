// THIS FILE IS AUTOGENERATED, DO NOT MODIFY
main()
{
	self setModel("c_usa_mp_sealteam6_smg_body_prev");
	self.headModel = "c_usa_mp_sealteam6_smg_head1";
	self attach(self.headModel, "", true);
	self.voice = "american";
	self.skeleton = "base";
}

precache()
{
	precacheModel("c_usa_mp_sealteam6_smg_body_prev");
	precacheModel("c_usa_mp_sealteam6_smg_head1");
}