
main()
{
	self setModel("greene_tux_body");
	self attach("greene_tux_head", "", false);
	self.voice = "american";
}

precache()
{
	precacheModel("greene_tux_body");
	precacheModel("greene_tux_head");
}
