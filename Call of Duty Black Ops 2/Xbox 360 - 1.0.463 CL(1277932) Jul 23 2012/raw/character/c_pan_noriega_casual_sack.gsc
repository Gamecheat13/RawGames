// THIS FILE IS AUTOGENERATED, DO NOT MODIFY
main()
{
	self setModel("c_pan_noriega_body1");
	self.headModel = "c_pan_noriega_head";
	self attach(self.headModel, "", true);
	self.hatModel = "c_pan_noriega_sack";
	self attach(self.hatModel);
	self.voice = "american";
	self.skeleton = "base";
}

precache()
{
	precacheModel("c_pan_noriega_body1");
	precacheModel("c_pan_noriega_head");
	precacheModel("c_pan_noriega_sack");
}