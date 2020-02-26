
main()
{
	self setModel("lc_thug_2_body_SC_B");
	self attach("lc_thug_2_head_SC_A", "", false);
	self attach("hands_white_1", "", false);
	self.voice = "american";
}

precache()
{
	precacheModel("lc_thug_2_body_SC_B");
	precacheModel("lc_thug_2_head_SC_A");
	precacheModel("hands_white_1");
}
