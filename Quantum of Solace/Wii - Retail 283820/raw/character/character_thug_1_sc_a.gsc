
main()
{
	self setModel("lc_thug_1_body_SC_A");
	self attach("lc_thug_1_head_SC_A", "", false);
	self attach("hands_white_1", "", false);
	self.voice = "american";
}

precache()
{
	precacheModel("lc_thug_1_body_SC_A");
	precacheModel("lc_thug_1_head_SC_A");
	precacheModel("hands_white_1");
}
