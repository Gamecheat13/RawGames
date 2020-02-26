
main()
{
	self setModel("getler_body");
	self attach("getler_head", "", false);
	self attach("hands_white_1", "", false);
	self.voice = "american";
}

precache()
{
	precacheModel("getler_body");
	precacheModel("getler_head");
	precacheModel("hands_white_1");
}
